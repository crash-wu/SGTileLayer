//
//  SGSWMTSLayer.m
//  WMSDemoOC
//
//  Created by Lee on 16/5/27.
//  Copyright © 2016年 ArK. All rights reserved.
//

#import "SGSWMTSLayer.h"
#include <CommonCrypto/CommonCrypto.h>



/** WMTS KVP 请求格式 */
static NSString *kKVPURLStringFormat = @"%@SERVICE=WMTS&REQUEST=GetTile&VERSION=%@&LAYER=%@&STYLE=%@&FORMAT=%@&TILEMATRIXSET=%@&TILEMATRIX=%@&TILEROW=%d&TILECOL=%d";

/** WMTS RESTful 请求格式 */
static NSString *kRESTfulURLStringFormat = @"%@%@/%@/%@/%ld/%ld/.%@";



///================================================================
///  MARK: - 加载切片Operation，仅内部使用
///================================================================

@interface SGSWMTSOperation : NSOperation
@property (nonatomic, strong) AGSTileKey *tileKey;
@property (nonatomic, strong) NSData *imageData;
- (instancetype)initWithURLString:(NSString *)urlStr tileKey:(AGSTileKey *)tileKey target:(id)target action:(SEL)action;
@end



@implementation SGSWMTSOperation {
    NSString *_urlString;
    id _target;
    SEL _action;
}

- (instancetype)initWithURLString:(NSString *)urlStr tileKey:(AGSTileKey *)tileKey target:(id)target action:(SEL)action {
    self = [super init];
    if (self) {
        _urlString = urlStr.copy;
        _tileKey = tileKey;
        _target = target;
        _action = action;
    }
    return self;
}

-(void)main {
    @try {
        NSURL *imageURL = [NSURL URLWithString:_urlString];
        self.imageData = [[NSData alloc] initWithContentsOfURL:imageURL];
    }
    @catch (NSException *exception) {
        //        NSLog(@"main: Caught Exception %@: %@", [exception name], [exception reason]);
    }
    @finally {
#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
#pragma clang diagnostic pop
    }
    
}

@end


///================================================================
///  MARK: - 自定义WMTS图层
///================================================================

@interface SGSWMTSLayer ()
@property (nonatomic, copy) NSString *cacheDocName;
@property (nonatomic, strong) dispatch_queue_t cacheQueue;
@property (nonatomic, strong) NSOperationQueue *loadTileQueue;
@property (nonatomic, assign) BOOL useCache;
@end


@implementation SGSWMTSLayer


- (instancetype)init {
    self = [super init];
    if (self) {
        _cacheQueue = dispatch_queue_create("com.southgis.wmts.cache", DISPATCH_QUEUE_SERIAL);
        
        _loadTileQueue = [[NSOperationQueue alloc] init];
        _loadTileQueue.maxConcurrentOperationCount = 10;
    }
    return self;
}

- (void)loadWMTSTileAndUsingCache:(BOOL)usingCache {
    _useCache = usingCache;
    
    [self layerDidLoad];
}

- (NSString *)cacheDocPath {
    NSString *path = [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES).firstObject stringByAppendingPathComponent:@"WMTS_Tile"];
    
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

#pragma mark - Override

- (AGSSpatialReference *)spatialReference {
    return _wmtsFullEnvelope.spatialReference;
}

- (AGSEnvelope *)fullEnvelope {
    return _wmtsFullEnvelope;
}

- (AGSEnvelope *)initialEnvelope {
    return _wmtsInitialEnvelope;
}

- (AGSTileInfo *)tileInfo {
    return _wmtsTileInfo;
}

- (void)requestTileForKey:(AGSTileKey *)key {
    __weak typeof(&*self) weakSelf = self;
    
    [self p_localTileDataWithTileKey:key callBack:^(NSData *tileData) {
        
        if (tileData == nil) {
            
            // 本地没有切片图片，需要从网络上加载
            NSString *urlString = nil;
            
            if (self.isRestQuery) {
                
                urlString = [NSString stringWithFormat:kRESTfulURLStringFormat,
                             self.tileURLString,
                             self.styleIdentifier,
                             self.tileMatrixSet,
                             self.tileMatrixIds[key.level],
                             key.row,
                             key.column,
                             self.tileInfo.format];
            } else {
                urlString = [NSString stringWithFormat:kKVPURLStringFormat,
                             self.tileURLString,
                             self.version,
                             self.layerIdentifier,
                             self.styleIdentifier,
                             self.format,
                             self.tileMatrixSet,
                             self.tileMatrixIds[key.level],
                             key.row,
                             key.column];
            }
            
            SGSWMTSOperation *op = [[SGSWMTSOperation alloc] initWithURLString:urlString tileKey:key target:self action:@selector(p_didFinishOperation:)];
            [weakSelf.loadTileQueue addOperation:op];
            
        } else {
            // 加载本地切片图片
            [super setTileData:tileData forKey:key];
        }
    }];
    
    
}

- (void)cancelRequestForKey:(AGSTileKey *)key {
    for (NSOperation *op in _loadTileQueue.operations) {
        if( [op isKindOfClass:[SGSWMTSOperation class]]){
            SGSWMTSOperation *loadTileOp = (SGSWMTSOperation *)op;
            if([loadTileOp.tileKey isEqualToTileKey:key]){
                [loadTileOp cancel];
            }
        }
    }
}


#pragma mark - Private Methods

- (void)p_didFinishOperation:(SGSWMTSOperation *)op{
    if (op.imageData != nil) {
        [super setTileData:op.imageData forKey:op.tileKey];
        [self p_cacheTheTileData:op.imageData withTileKey:op.tileKey];
    }
}

// 获取本地切片数据
- (void)p_localTileDataWithTileKey:(AGSTileKey *)tileKey callBack:(void(^)(NSData *tileData))handler {
    NSString *cacheDocPath = [self p_cachePath];
    
    if (self.useCache && cacheDocPath != nil) {
        // 使用队列确保线程安全
        dispatch_async(_cacheQueue, ^{
            
            NSString *cacheDataPath = [NSString stringWithFormat:@"%@/L%02lx/R%08lx/C%08lx", cacheDocPath, (long)tileKey.level, (long)tileKey.row, (long)tileKey.column];
            NSData *cacheData = [NSData dataWithContentsOfFile:cacheDataPath];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                if (handler != nil) {
                    handler(cacheData);
                }
            });
        });
    } else {
        if (handler != nil) {
            handler(nil);
        }
    }
}

// 缓存切片数据
- (void)p_cacheTheTileData:(NSData *)tileData withTileKey:(AGSTileKey *)tileKey {
    if (tileData.length == 0 || !self.useCache) {
        return ;
    }
    
    __weak typeof(&*self) weakSelf = self;
    
    // 异步串行执行缓存切片任务
    dispatch_async(_cacheQueue, ^{
        NSString *cacheDocPath = [NSString stringWithFormat:@"%@/L%02lx/R%08lx", [weakSelf p_cachePath], (long)tileKey.level, (long)tileKey.row];
        
        BOOL docExist = NO;
        [[NSFileManager defaultManager] fileExistsAtPath:cacheDocPath isDirectory:&docExist];
        
        if (!docExist) {
            NSError *error = nil;
            [[NSFileManager defaultManager] createDirectoryAtPath:cacheDocPath withIntermediateDirectories:YES attributes:nil error:&error];
            
            if (error) {
                return ;
            }
        }
        
        NSString *cachePath = [NSString stringWithFormat:@"%@/C%08lx", cacheDocPath, (long)tileKey.column];
        [tileData writeToFile:cachePath atomically:YES];
    });
}

// 本地缓存路径
- (NSString *)p_cachePath {
    NSString *cachePath = [self cacheDocPath];
    cachePath = [cachePath stringByAppendingPathComponent:self.cacheDocName];
    
    BOOL docExist = NO;
    [[NSFileManager defaultManager] fileExistsAtPath:cachePath isDirectory:&docExist];
    
    if (!docExist) {
        NSError *error = nil;
        [[NSFileManager defaultManager] createDirectoryAtPath:cachePath withIntermediateDirectories:YES attributes:nil error:&error];
        
        if (error) {
            return nil;
        }
    }
    
    return cachePath;
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

#pragma mark - Setter & Getter
- (void)setTileURLString:(NSString *)tileURLString {
    _tileURLString = tileURLString.copy;
    
    if (_tileURLString.length > 0 && ![_tileURLString hasSuffix:@"?"]) {
        _tileURLString = [_tileURLString stringByAppendingString:@"?"];
    }
}

- (NSString *)version {
    if (_version == nil) {
        _version = @"1.0.0";
    }
    return _version;
}

- (NSString *)layerIdentifier {
    if (_layerIdentifier == nil) {
        _layerIdentifier = self.isRestQuery ? @"(null)" : @"";
    }
    return _layerIdentifier;
}

- (NSString *)styleIdentifier {
    if (_styleIdentifier == nil) {
        _styleIdentifier = self.isRestQuery ? @"(null)" : @"";
    }
    return _styleIdentifier;
}

- (NSString *)format {
    if (_format == nil) {
        _format = @"";
    }
    return _format;
}

- (NSString *)tileMatrixSet {
    if (_tileMatrixSet == nil) {
        _tileMatrixSet = self.isRestQuery ? @"(null)" : @"";
    }
    return _tileMatrixSet;
}

- (NSArray *)tileMatrixIds {
    if (_tileMatrixIds == nil) {
        _tileMatrixIds = @[];
    }
    return _tileMatrixIds;
}

- (NSString *)cacheDocName {
    if (!_cacheDocName) {
        _cacheDocName = [self p_md5String:_tileURLString];
    }
    return _cacheDocName;
}

@end
