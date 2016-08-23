//
//  SGSWMTSInfo.m
//  WMSDemoOC
//
//  Created by Lee on 16/5/27.
//  Copyright © 2016年 ArK. All rights reserved.
//

#import "SGSWMTSInfo.h"
#import "SGSWMTSLayerInfo.h"
#import "SGSWMTSLayer.h"
#include <CommonCrypto/CommonCrypto.h>

#import "NSDictionary+YYAdd.h"


// 默认DPI
const NSUInteger SGSWMTSDefaultDPI = 96;

// 英寸转米制常数
const double kInchToMetreConst = 0.0254;

// 空间坐标系（非投影坐标系）计算分辨率的常数
const double kGeoCoordinateConst  = 111194.872221777;

// 空间坐标系最大范围的四角坐标
const double kMinXByGeoCoordinate = -180.0;
const double kMinYByGeoCoordinate = -90.0;
const double kMaxXByGeoCoordinate = 180.0;
const double kMaxYByGeoCoordinate = 90.0;

// 墨卡托投影坐标系最大范围的四角坐标
const double kMinXByMercator = -20037508.3427892;
const double kMinYByMercator = -20037508.3427892;
const double kMaxXByMercator = 20037508.3427892;
const double kMaxYByMercator = 20037508.3427892;



@interface SGSWMTSInfo ()

@property (nonatomic, copy, readwrite) NSURL *URL;
@property (nonatomic, copy, readwrite) NSString *version;
@property (nonatomic, weak, readwrite) id<SGSWMTSInfoDelegate> delegate;
@property (nonatomic, copy, readwrite) NSArray<SGSWMTSLayerInfo *> *layerInfos;
@property (nonatomic, copy, readwrite) NSDictionary<NSString *, NSArray<NSString *> *> *tileMatrixSets;
@property (nonatomic, copy, readwrite) NSDictionary<NSString *, AGSTileInfo *> *tileInfos;

@property (nonatomic, assign) NSUInteger dpi;
@property (nonatomic, assign, getter=isRest) BOOL restful;    // 图层切片是否是REST方式请求
@property (nonatomic, strong) NSMutableDictionary *imageFormats;   // 图层切片格式
@property (nonatomic, strong) NSMutableDictionary *fullEnvelopes;  // 各坐标系的全范围
@property (nonatomic, strong) NSURLSessionDataTask *task;     // GetCapabilities 请求 task

@end



@implementation SGSWMTSInfo

#pragma mark - Public Methods

// 初始化方法
- (instancetype)initWithURLString:(NSString *)url delegate:(id<SGSWMTSInfoDelegate>)delegate {
    return [self initWithURLString:url tileDPI:SGSWMTSDefaultDPI delegate:delegate];
}

// 初始化方法
- (instancetype)initWithURLString:(NSString *)url
                          tileDPI:(NSUInteger)dpi
                         delegate:(id<SGSWMTSInfoDelegate>)delegate
{
    self = [super init];
    if (self) {
        if (url.length > 0 && ![url hasSuffix:@"?"]) {
            url = [url stringByAppendingString:@"?"];
        }
        
        url = [url stringByAppendingString:@"SERVICE=WMTS&REQUEST=GetCapabilities"];
        _URL = [NSURL URLWithString:url];
        _dpi = dpi;
        _delegate = delegate;
        
        
        // 优先加载本地的缓存数据
        NSData *cacheXMLData = [self p_localXMLData];
        
        if (cacheXMLData != nil) {
            [self p_configWithXMLData:cacheXMLData];
            
        } else {
            
            [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
            
            __weak typeof(&*self) weakSelf = self;
            
            // GetCapabilities 请求
            _task = [[NSURLSession sharedSession] dataTaskWithURL:_URL completionHandler:^(NSData * _Nullable data, NSURLResponse * _Nullable response, NSError * _Nullable error) {
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                    
                    weakSelf.task = nil;
                    
                    if (error) {
                        _error = error;
                        
                        if (weakSelf.delegate != nil && [weakSelf.delegate respondsToSelector:@selector(sgsWMTSInfo:didFailToLoad:)]) {
                            [weakSelf.delegate sgsWMTSInfo:weakSelf didFailToLoad:error];
                        }
                    } else {
                        [weakSelf p_cacheTheXMLData:data];
                        
                        [weakSelf p_configWithXMLData:data];
                    }
                });
                
            }];
            
            [_task resume];
        }
        
    }
    
    return self;
}

- (void)dealloc {
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
    });
    
    if (_task) {
        [_task cancel];
        _task = nil;
    }
}

// 初始化方法
- (instancetype)initWithXMLData:(NSData *)xmlData delegate:(id<SGSWMTSInfoDelegate>)delegate {
    return [self initWithXMLData:xmlData tileDPI:SGSWMTSDefaultDPI delegate:delegate];
}


// 初始化方法
- (instancetype)initWithXMLData:(NSData *)xmlData
                        tileDPI:(NSUInteger)dpi
                       delegate:(id<SGSWMTSInfoDelegate>)delegate
{
    self = [super init];
    if (self) {
        _dpi = dpi;
        _delegate = delegate;
        
        [self p_configWithXMLData:xmlData];
    }
    
    return self;
}

// 通过 LayerInfo 获取切片图层
- (SGSWMTSLayer *)wmtsLayerWithLayerInfo:(SGSWMTSLayerInfo *)layerInfo {
    if (layerInfo == nil) {
        return nil;
    }
    
    
    NSString *tileMatrixId = layerInfo.tileMatrixIdentifier;
    AGSTileInfo *tileInfo = _tileInfos[tileMatrixId];
    
    if (layerInfo.initialXMin < 0.01 && layerInfo.initialYMin < 0.01 && layerInfo.initialXMax < 0.01 && layerInfo.initialYMax < 0.01) {
        if (tileInfo.spatialReference.isAnyWebMercator) {
            layerInfo.initialXMin = kMinXByMercator;
            layerInfo.initialYMin = kMinYByMercator;
            layerInfo.initialXMax = kMaxXByMercator;
            layerInfo.initialYMax = kMaxYByMercator;
        } else {
            layerInfo.initialXMin = kMinXByGeoCoordinate;
            layerInfo.initialYMin = kMinYByGeoCoordinate;
            layerInfo.initialXMax = kMaxXByGeoCoordinate;
            layerInfo.initialYMax = kMaxYByGeoCoordinate;
        }
    }
    
    SGSWMTSLayer *wmtsLayer = [[SGSWMTSLayer alloc] init];
        
    wmtsLayer.tileURLString = layerInfo.tileURL.absoluteString;
    wmtsLayer.version = _version;
    wmtsLayer.layerIdentifier = layerInfo.layerIdentifier;
    wmtsLayer.layerName = layerInfo.layerName;
    wmtsLayer.styleIdentifier = layerInfo.styleIdentifier;
    wmtsLayer.format = layerInfo.format;
    wmtsLayer.tileMatrixSet = tileMatrixId;
    wmtsLayer.tileMatrixIds = _tileMatrixSets[tileMatrixId];
    wmtsLayer.restQuery = self.isRest;
    wmtsLayer.wmtsTileInfo = tileInfo;
    wmtsLayer.wmtsFullEnvelope = _fullEnvelopes[tileMatrixId];
    
    AGSEnvelope *initialEnvelope = [[AGSEnvelope alloc] initWithXmin:layerInfo.initialXMin ymin:layerInfo.initialYMin xmax:layerInfo.initialXMax ymax:layerInfo.initialYMax spatialReference:tileInfo.spatialReference];
    wmtsLayer.wmtsInitialEnvelope = initialEnvelope;
        
    return wmtsLayer;
}

- (NSString *)cacheDocPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"WMTS_Info"];
    
    BOOL docExist = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&docExist];
    
    if (!docExist) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:path withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            return nil;
        }
    }
    
    return path;
}

#pragma mark - Private Methods

- (NSData *)p_localXMLData {
    NSString *cachePath = [self cacheDocPath];
    
    NSString *xmlCacheName = [self p_md5String:_URL.absoluteString];
    
    if (xmlCacheName) {
        cachePath = [cachePath stringByAppendingPathComponent:xmlCacheName];
        
        return [NSData dataWithContentsOfFile:cachePath];
    }
    
    return nil;
}

- (BOOL)p_cacheTheXMLData:(NSData *)xmlData {
    if (xmlData.length == 0) {
        return NO;
    }
    
    NSString *cachePath = [self cacheDocPath];
    NSString *xmlCacheName = [self p_md5String:_URL.absoluteString];
    cachePath = [cachePath stringByAppendingPathComponent:xmlCacheName];
    
    return [xmlData writeToFile:cachePath atomically:YES];
}

// 计算MD5值
- (NSString *)p_md5String:(NSString *)str {
    if (str == nil) {
        return nil;
    }
    
    unsigned char buffer[CC_MD5_DIGEST_LENGTH];
    NSData *strData = [str dataUsingEncoding:NSUTF8StringEncoding];
    CC_MD5(strData.bytes, (CC_LONG)strData.length, buffer);
    
    NSMutableString *result = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for (int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) {
        [result appendFormat:@"%02x", buffer[i]];
    }
    return result;
}



// 根据 XML 数据设置属性
- (void)p_configWithXMLData:(NSData *)xmlData {
    NSDictionary *xmlDict = [NSDictionary dictionaryWithXML:xmlData];

    // 获取请求地址
    NSDictionary *tileMetadataDict = [self p_tileMetadataWithXMLDictionary:xmlDict];
    
    id capabilities = tileMetadataDict[@"GetCapabilities"][@"ows:HTTP"][@"ows:Get"];
    if ([capabilities isKindOfClass:[NSArray class]]) {
        capabilities = [self p_capabilitiesConstraintByMetadatas:capabilities];
    }
    
    id tiles = tileMetadataDict[@"GetTile"][@"ows:HTTP"][@"ows:Get"];
    if ([tiles isKindOfClass:[NSArray class]]) {
        tiles = [self p_capabilitiesConstraintByMetadatas:tiles];
    }
    
    id featureInfos = tileMetadataDict[@"GetFeatureInfo"][@"ows:HTTP"][@"ows:Get"];
    if ([featureInfos isKindOfClass:[NSArray class]]) {
        featureInfos = [self p_capabilitiesConstraintByMetadatas:featureInfos];
    }
    
    NSString *capabilitiesURLStr = [self p_urlStringByXLinkDictionary:capabilities];
    NSString *tileURLStr         = [self p_urlStringByXLinkDictionary:tiles];
    NSString *featureInfoURLStr  = [self p_urlStringByXLinkDictionary:featureInfos];


    _URL = [NSURL URLWithString:capabilitiesURLStr];
    
    // 获取切片服务版本号
    _version = xmlDict[@"version"];
    
    _imageFormats = [NSMutableDictionary dictionary];
    _fullEnvelopes = [NSMutableDictionary dictionary];

    // 设置图层信息
    [self p_configLayerInfosWithXMLDictionary:xmlDict tileURLString:tileURLStr];
    
    // 设置切片信息
    [self p_configTileInfosWithXMLDictionary:xmlDict];
    
    if (self.delegate != nil && [self.delegate respondsToSelector:@selector(sgsWMTSInfoDidLoad:)]) {
        [self.delegate sgsWMTSInfoDidLoad:self];
    }
}


// 根据XML数据设置图层信息
- (void)p_configLayerInfosWithXMLDictionary:(NSDictionary *)xmlDict
                              tileURLString:(NSString *)tileURLStr
{
    NSArray *tileLayers = [self p_tileLayerWithXMLDictionary:xmlDict];
    
    NSMutableArray<SGSWMTSLayerInfo *> *layerInfosMut = [NSMutableArray arrayWithCapacity:tileLayers.count];
    
    for (NSDictionary *layerInfoDict in tileLayers) {
        // 图层样式
        id style = layerInfoDict[@"Style"];
        if ([style isKindOfClass:[NSArray class]]) {
            style = [style firstObject];
        }
        
        style = [style valueForKey:@"ows:Identifier"];
        
        if (![style isKindOfClass:[NSString class]]) {
            style = @"";
        }
        
        // 图层切片格式
        id format = layerInfoDict[@"Format"];
        if ([format isKindOfClass:[NSArray class]]) {
            format = [self p_tileImageFormatWithArray:format];
        }
        
        // 图层矩阵集标识
        id tileMatrixSet = layerInfoDict[@"TileMatrixSetLink"];
        if ([tileMatrixSet isKindOfClass:[NSArray class]]) {
            tileMatrixSet = [tileMatrixSet firstObject];
        }
        
        tileMatrixSet = [tileMatrixSet valueForKey:@"TileMatrixSet"];
        
        if (![tileMatrixSet isKindOfClass:[NSString class]]) {
            tileMatrixSet = nil;
        }
        
        
        
        // 设置图层信息
        SGSWMTSLayerInfo *layerInfo = [[SGSWMTSLayerInfo alloc] init];
        layerInfo.tileURL = [NSURL URLWithString:tileURLStr];
        layerInfo.layerIdentifier = layerInfoDict[@"ows:Identifier"];
        layerInfo.layerName = layerInfoDict[@"ows:Title"];
        layerInfo.styleIdentifier = style;
        layerInfo.format = format;
        layerInfo.tileMatrixIdentifier = tileMatrixSet;
        
        
        
        NSDictionary *boundingBox = layerInfoDict[@"ows:BoundingBox"];
        
        if (boundingBox != nil) {
            NSString *lowerCorner = boundingBox[@"ows:LowerCorner"];
            NSString *upperCorner = boundingBox[@"ows:UpperCorner"];
            
            NSCharacterSet *separatedSet = [NSCharacterSet characterSetWithCharactersInString:@" ,"];
            
            NSMutableArray *lowers = [lowerCorner componentsSeparatedByCharactersInSet:separatedSet].mutableCopy;
            NSMutableArray *uppers = [upperCorner componentsSeparatedByCharactersInSet:separatedSet].mutableCopy;
            
            if (lowers.count == 2 && uppers.count == 2) {
                layerInfo.initialXMin = [lowers[0] doubleValue];
                layerInfo.initialYMin = [lowers[1] doubleValue];
                
                layerInfo.initialXMax = [uppers[0] doubleValue];
                layerInfo.initialYMax = [uppers[1] doubleValue];
            }
        } else {
            layerInfo.initialXMin = 0.0;
            layerInfo.initialYMin = 0.0;
            layerInfo.initialXMax = 0.0;
            layerInfo.initialYMax = 0.0;
        }
        
        if (tileMatrixSet) {
            
            // 保存图片格式
            _imageFormats[tileMatrixSet] = format;
        }
        
        [layerInfosMut addObject:layerInfo];
        
    }

    _layerInfos = layerInfosMut.copy;
}

// 根据XML数据设置切片信息
- (void)p_configTileInfosWithXMLDictionary:(NSDictionary *)xmlDict {
    // 矩阵集
    NSArray *tileMatrixsArray = [self p_tileMatrixSetWithXMLDictionary:xmlDict];
    
    NSMutableDictionary *tileMatrixsMutDict = [NSMutableDictionary dictionaryWithCapacity:tileMatrixsArray.count];
    NSMutableDictionary *tileInfosMutDict = [NSMutableDictionary dictionaryWithCapacity:tileMatrixsArray.count];
    
    // 遍历矩阵集
    for (NSDictionary *tileMatrixDict in tileMatrixsArray) {
        
        NSString *identifier = tileMatrixDict[@"ows:Identifier"];
        if (identifier == nil) {
            continue ;
        }
        
        NSInteger wkid = [tileMatrixDict[@"ows:SupportedCRS"] componentsSeparatedByString:@":"].lastObject.integerValue;
        wkid = [self p_matchWKID:wkid];
        AGSSpatialReference *sr = [[AGSSpatialReference alloc] initWithWKID:wkid];
        
//        double xMin = [[_originCoordinates[identifier] valueForKey:@"xMin"] doubleValue];
//        double yMax = [[_originCoordinates[identifier] valueForKey:@"yMax"] doubleValue];
//        AGSPoint *origin = [AGSPoint pointWithX:xMin y:yMax spatialReference:sr];
        
        AGSEnvelope *fullEnvelope = nil;
        AGSPoint *origin = nil;
        
        if (sr.isAnyWebMercator) {
            origin = [AGSPoint pointWithX:kMinXByMercator y:kMaxYByMercator spatialReference:sr];
            fullEnvelope = [AGSEnvelope envelopeWithXmin:kMinXByMercator ymin:kMinYByMercator xmax:kMaxXByMercator ymax:kMaxYByMercator spatialReference:sr];
        } else {
            origin = [AGSPoint pointWithX:kMinXByGeoCoordinate y:kMaxYByGeoCoordinate spatialReference:sr];
            fullEnvelope = [AGSEnvelope envelopeWithXmin:kMinXByGeoCoordinate ymin:kMinYByGeoCoordinate xmax:kMaxXByGeoCoordinate ymax:kMaxYByGeoCoordinate spatialReference:sr];
        }
        
        NSArray *matrixs = tileMatrixDict[@"TileMatrix"];
        
        // 矩阵集标识符数组
        NSMutableArray<NSString *> *matrixIdsMutArr = [NSMutableArray arrayWithCapacity:matrixs.count];
        
        // 切片等级信息数组
        NSMutableArray<AGSLOD *> *lodsMutArr = [NSMutableArray arrayWithCapacity:matrixs.count];
        
        double tileHeight = 0.0;
        double tileWidth = 0.0;

        for (NSDictionary *matrix in matrixs) {
            
            tileHeight = [matrix[@"TileHeight"] doubleValue];
            tileWidth = [matrix[@"TileWidth"] doubleValue];
            
            NSString *matrixId = matrix[@"ows:Identifier"];
            if (matrixId == nil) {
                continue ;
            }
            
            [matrixIdsMutArr addObject:matrixId];
            
            NSInteger matrixLevel = [matrixId componentsSeparatedByString:@":"].lastObject.integerValue;
            
            double scale = [matrix[@"ScaleDenominator"] doubleValue];
            double resolution = 0.0;
            
            if (sr.isAnyWebMercator) {
                resolution = scale * kInchToMetreConst / _dpi;
            } else {
                resolution = scale * kInchToMetreConst / _dpi / kGeoCoordinateConst;
            }
            
            AGSLOD *lod = [[AGSLOD alloc] initWithLevel:matrixLevel resolution:resolution scale: scale];
            
            [lodsMutArr addObject:lod];
        }
        
        // 将矩阵集标识符数组添加到字典中
        tileMatrixsMutDict[identifier] = matrixIdsMutArr.copy;
        
        NSString *imageFormat = [self p_tileImageFormat:_imageFormats[identifier]];
        
        // 实例化一个 AGSTileInfo
        AGSTileInfo *tileInfo = [[AGSTileInfo alloc] initWithDpi:_dpi
                                                          format:imageFormat
                                                            lods:lodsMutArr
                                                          origin:origin
                                                spatialReference:sr
                                                        tileSize:CGSizeMake(tileWidth, tileHeight)];
        

        [tileInfo computeTileBounds:fullEnvelope];
        
        _fullEnvelopes[identifier] = fullEnvelope;
        
        // 将 AGSTileInfo 添加到字典中
        tileInfosMutDict[identifier] = tileInfo;
    }
    
    _tileMatrixSets = tileMatrixsMutDict.copy;
    _tileInfos = tileInfosMutDict.copy;
}

// 优先使用KVP地址拼接方式
- (NSDictionary *)p_capabilitiesConstraintByMetadatas:(NSArray *)metadatas {
    if (metadatas.count <= 1) {
        return metadatas.firstObject;
    }
    
    NSMutableDictionary *tempDict = [NSMutableDictionary dictionaryWithCapacity:metadatas.count];
    for (NSMutableDictionary *constraint in metadatas) {
        NSString *queryType = constraint[@"ows:Constraint"][@"ows:AllowedValues"][@"ows:Value"];
        if (queryType != nil) {
            tempDict[queryType] = constraint;
        }
    }
    
    // 优先使用KVP方式拼接地址
    if (tempDict[@"KVP"] != nil) {
        return tempDict[@"KVP"];
    }
    
//    return tempDict[@"RESTful"];
    return metadatas.firstObject;
}

// 匹配WKID
- (NSInteger)p_matchWKID:(NSInteger)wkid {
    if (wkid == 900913) {
        return WKID_WGS_1984_WEB_MERCATOR_AUXILIARY_SPHERE;
    }
    
    return wkid;
}

// 匹配元数据地址
- (NSString *)p_urlStringByXLinkDictionary:(NSDictionary *)dict {
    if (![dict isKindOfClass:[NSDictionary class]]) {
        return @"";
    }
    
    NSString *queryType = dict[@"ows:AllowedValues"][@"ows:Value"];
    if ([queryType isEqualToString:@"RESTful"]) {
        self.restful = YES;
    }
    
    return dict[@"xlink:href"];
}

// 匹配切片的格式
- (NSString *)p_tileImageFormatWithArray:(NSArray *)formats {
    if (formats == nil) {
        return @"image/png";
    }
    
    NSSet *set = [NSSet setWithArray:formats];
    
    // 优先选择png格式
    if ([set containsObject:@"image/png"]) {
        return @"image/png";
    }
    
    if ([set containsObject:@"image/jpeg"]) {
        return @"image/jpeg";
    }

    return formats.firstObject;
}

// 获取切片的格式
- (NSString *)p_tileImageFormat:(NSString *)format {
    if ([format isEqualToString:@"image/png"]) {
        return @"png";
    }
    
    if ([format isEqualToString:@"image/jpeg"]) {
        return @"jpg";
    }
    
    if ([format isEqualToString:@"image/bmp"]) {
        return @"bmp";
    }
    
    if ([format isEqualToString:@"image/tiff"]) {
        return @"tiff";
    }
    
    if ([format isEqualToString:@"image/gif"]) {
        return @"gif";
    }
    
    return @"png";
}


// 从XML数据中获取元数据
- (NSDictionary *)p_tileMetadataWithXMLDictionary:(NSDictionary *)xmlDict {
    NSArray *operations = xmlDict[@"ows:OperationsMetadata"][@"ows:Operation"];
    
    if (operations == nil || ![operations isKindOfClass:[NSArray class]]) {
        return nil;
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionaryWithCapacity:operations.count];
    
    for (NSDictionary *op in operations) {
        NSString *opName = op[@"name"];
        NSDictionary *dcp = op[@"ows:DCP"];
        
        if ([opName isEqualToString:@"GetCapabilities"]) {
            result[@"GetCapabilities"] = dcp;
        }
        
        if ([opName isEqualToString:@"GetTile"]) {
            result[@"GetTile"] = dcp;
        }
        
        if ([opName isEqualToString:@"GetFeatureInfo"]) {
            result[@"GetFeatureInfo"] = dcp;
        }
    }
    
    return result.copy;
}


// 从XML数据中获取图层信息
- (NSArray *)p_tileLayerWithXMLDictionary:(NSDictionary *)xmlDict {
    id layer = xmlDict[@"Contents"][@"Layer"];
    
    if ([layer isKindOfClass:[NSArray class]]) {
        return layer;
    }
    
    return layer == nil ? nil : @[layer];
}


// 从XML数据中获取切片矩阵集
- (NSArray *)p_tileMatrixSetWithXMLDictionary:(NSDictionary *)xmlDict {
    id layer = xmlDict[@"Contents"][@"TileMatrixSet"];
    
    if ([layer isKindOfClass:[NSArray class]]) {
        return layer;
    }
    
    return layer == nil ? nil : @[layer];
}

@end
