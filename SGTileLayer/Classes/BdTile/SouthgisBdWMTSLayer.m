//
//  SouthgisBdWMTSLayer.m
//  TianDituFramework
//
//  Created by 吴小星 on 16/3/31.
//  Copyright © 2016年 crash. All rights reserved.
//

#import "SouthgisBdWMTSLayer.h"
#import "Southgis_BdWMTSLayerInfoDelegate.h"
#import "Southgis_BdWMTSLayerOperation.h"

@implementation SouthgisBdWMTSLayer


- (instancetype)initWithCachePath:(NSString *)cachePath{
    
    if (self = [super initWithCachePath:cachePath]) {
        
    }
    return self;
}

/**
 *  @author crash         crash_wu@163.com   , 16-04-27 09:04:06
 *
 *  @brief  初始化百度地图
 *
 *  @param wmtsLayerType 百度地图类型
 *  @param outError      错误状态
 *
 *  @return 返回百度地图图层
 */
-(instancetype)initWithLayerType:(BDLayerTypes)wmtsLayerType  error:(NSError *__autoreleasing *)outError{
    
    if (self = [super initWithCachePath:[self retFilePath]]) {
        
        /*get the currect layer info
         */
        _layerInfo = [[Southgis_BdWMTSLayerInfoDelegate alloc]getLayerInfo:wmtsLayerType];
        
//        if (![url isEqual:[NSNull null]]) {
//            _layerInfo.url = url;
//        }
        
        AGSSpatialReference* sr = [AGSSpatialReference spatialReferenceWithWKID:_layerInfo.srid];
        
        _fullEnvelope = [[AGSEnvelope alloc] initWithXmin:_layerInfo.xMin
                                                     ymin:_layerInfo.yMin
                                                     xmax:_layerInfo.xMax
                                                     ymax:_layerInfo.yMax
                                         spatialReference:sr];
        
        _tileInfo = [[AGSTileInfo alloc]initWithDpi:_layerInfo.dpi
                                             format:@"PNG" lods:_layerInfo.lods origin:_layerInfo.origin spatialReference:self.spatialReference tileSize:CGSizeMake(_layerInfo.tileWidth,_layerInfo.tileHeight)];
        
        [_tileInfo computeTileBounds:self.fullEnvelope];
        
        [super layerDidLoad];
    }
    
    return self;
    

    
}




- (void)requestTileForKey:(AGSTileKey *)key{
    
    
    __weak typeof(self) weakSelf = self;
    
    [self loadTileDataFromCacheWithTileKey:key loadCompleteBlock:^(NSData *data) {
        
        if (data) {
            
            [weakSelf setTileData:data forKey:key];
            
        }
        else{
            Southgis_BdWMTSLayerOperation *operation = [[Southgis_BdWMTSLayerOperation alloc]initWithTileKey:key TiledLayerInfo:_layerInfo target:weakSelf action:@selector(didFinishOperation:)];
            
            [_requestQueue addOperation:operation];
        }
    }];
    
    
    
}

- (void)cancelRequestForKey:(AGSTileKey *)key{
    //Find the Southigs_TiledServiceLayerOperation object for this key and cancel it
    for(NSOperation* op in [AGSRequestOperation sharedOperationQueue].operations){
        if( [op isKindOfClass:[Southgis_BdWMTSLayerOperation class]]){
            Southgis_BdWMTSLayerOperation* offOp = (Southgis_BdWMTSLayerOperation*)op;
            if([offOp.tileKey isEqualToTileKey:key]){
                [offOp cancel];
            }
        }
    }
}

- (void) didFinishOperation:(Southgis_BdWMTSLayerOperation*)op{
    
    [super setTileData:op.imageData forKey:op.tileKey];
    
    
}



/**
 * @author Jeremy, 16-03-10 11:03:44
 *
 * 返回缓存路径
 *
 * @param tileKey
 *
 * @return 路径
 */
- (NSString *)retFilePath{
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    
    NSString *docPath = [documentPaths objectAtIndex:0];
    
    NSString *createPath = [NSString stringWithFormat:@"%@/bd_wmts_tiles", docPath];
    
    
    return createPath;
}




@end
