//
//  Southgis_TiledServiceLayer.m
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/1.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import "Southgis_TiledServiceLayer.h"
#import "Southigs_TiledServiceLayerOperation.h"
#import "Southgis_TiledServiceLayerInfoOperation.h"


@interface Southgis_TiledServiceLayer()<LayerInfoOperationDelegate>

@property(nonatomic,strong)Southgis_TiledServiceLayerInfoOperation *infoOperation;

@end

@implementation Southgis_TiledServiceLayer

- (instancetype)initTiledServiceLayerURL:(NSString *)url{
    
    if(self = [super initWithCachePath:[self retFilePath]]){
    
        [self requestTileInfoUrl:url];
        
    }
    
    return self;
}

/**
 * @author Jeremy, 16-03-03 11:03:59
 *
 * 获取切片信息
 *
 * @param url 切片图层地址
 */
- (void)requestTileInfoUrl:(NSString *)url{
    
    self.infoOperation = [[Southgis_TiledServiceLayerInfoOperation alloc]initLayerInfoOperationUrl:url];
    
    self.infoOperation.delegate = self;
    
    [_requestQueue addOperation:self.infoOperation];
}

#pragma mark - LayerInfoOperationDelegate
- (void)retLayerInfo:(Southgis_TiledServiceLayerInfo *)layerInfo{
    
    _layerInfo = layerInfo;
    
    _tileInfo = layerInfo.tileInfo;
    
    _fullEnvelope = layerInfo.fullExtent;
   
    [super layerDidLoad];
}

- (void)requestTileForKey:(AGSTileKey *)key{
    
    _layerInfo = self.infoOperation.layerInfo;
    
    __weak typeof(self) weakSelf = self;
    
    //先从本地获取切片缓存，再从网络获取
    [self loadTileDataFromCacheWithTileKey:key loadCompleteBlock:^(NSData *data) {
        
        if (data) {
            [weakSelf setTileData:data forKey:key];
        }
        else{
            //切片请求
            Southigs_TiledServiceLayerOperation *operation = [[Southigs_TiledServiceLayerOperation alloc]initOperationKey:key layerInfo:_layerInfo target:weakSelf action:@selector(didFinishOperation:)];
            
            [_requestQueue addOperation:operation];
        }
        
    }];

}

- (void)cancelRequestForKey:(AGSTileKey *)key{
    //Find the Southigs_TiledServiceLayerOperation object for this key and cancel it
    for(NSOperation* op in [AGSRequestOperation sharedOperationQueue].operations){
        if( [op isKindOfClass:[Southigs_TiledServiceLayerOperation class]]){
            Southigs_TiledServiceLayerOperation* offOp = (Southigs_TiledServiceLayerOperation*)op;
            if([offOp.tileKey isEqualToTileKey:key]){
                [offOp cancel];
            }
        }
    }
}

- (void) didFinishOperation:(Southigs_TiledServiceLayerOperation*)op{
   
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
    
    NSString *createPath = [NSString stringWithFormat:@"%@/custom_tiles", docPath];
    
    
    return createPath;
}

@end