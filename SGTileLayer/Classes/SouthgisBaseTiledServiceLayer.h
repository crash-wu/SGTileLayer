//
//  SouthgisTiledServiceLayer.h
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/28.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>

/**
 * @author Jeremy, 16-03-29 15:03:37
 *
 * 切片基类
 */
@interface SouthgisBaseTiledServiceLayer : AGSTiledLayer
{
    //切片信息
    AGSTileInfo* _tileInfo;
    //地图范围
    AGSEnvelope* _fullEnvelope;
    //单位
    AGSUnits _units;
    //线程队列
    NSOperationQueue* _requestQueue;
}

/**缓存路径，nil不缓存，否则缓存到该路径下**/
@property(nonatomic,strong)NSString *cacheDocPath;


/**
 * @author Jeremy, 16-03-29 17:03:20
 *
 * 初始化方法
 *
 * @param cachePath 缓存路径
 *
 * @return 实体
 */
- (instancetype)initWithCachePath:(NSString *)cachePath;

/**
 * @author Jeremy, 16-03-29 12:03:27
 *
 * 加载本地切片缓存
 *
 * @param tilekey      切片信息
 * @param loadComplete 切片加载完成操作
 */
- (void)loadTileDataFromCacheWithTileKey:(AGSTileKey *)tilekey loadCompleteBlock:(void(^)(NSData *data))loadComplete;

/**
 *  清除缓存
 */
- (void)clearCache;

/**
 *  清除缓存，完成时将通过闭包回调
 *
 *  @param completed 完成回调闭包
 */
- (void)clearCacheWithCompletionHandler:(void(^)())completionHander;


/**
 *  切片缓存地址Key
 *
 *  如果需要本地缓存，那么子类需要实现该方法
 *
 *  @return Key
 */
- (NSString *)tiledCachePathKey;


/**
 * @author Jeremy, 16-03-28 17:03:13
 *
 * 获取当前图层级别
 *
 * @return 图层级别
 */
- (NSInteger)currentLevel;

/**
 *  设置切片数据
 *
 *  @param data      切片数据
 *  @param tilekey   切片矩阵Key
 *  @param cacheTile YES（缓存切片数据），NO（不缓存）
 */
- (void)setTileData:(NSData *)data forKey:(AGSTileKey *)tilekey cacheTile:(BOOL)cacheTile;
@end
