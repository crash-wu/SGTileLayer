//
//  SGSWMTSLayer.h
//  WMSDemoOC
//
//  Created by Lee on 16/5/27.
//  Copyright © 2016年 ArK. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  自定义WMTS图层
 *  支持 KVP 格式和 RESTful 格式的WMTS切片
 */
@interface SGSWMTSLayer : AGSTiledLayer

/** GetTile 地址 */
@property (nonatomic, copy  ) NSString  *tileURLString;

/** WMTS 服务版本 */
@property (nonatomic, copy  ) NSString  *version;

/** 图层标识符 */
@property (nonatomic, copy  ) NSString  *layerIdentifier;

/** 图层名 */
@property (nonatomic, copy  ) NSString  *layerName;

/** 图层样式 */
@property (nonatomic, copy  ) NSString  *styleIdentifier;

/** 图层内容格式 */
@property (nonatomic, copy  ) NSString  *format;

/** 切片矩阵集 */
@property (nonatomic, copy  ) NSString  *tileMatrixSet;

/** 切片矩阵，由切片矩阵标识符进行标识 */
@property (nonatomic, copy  ) NSArray<NSString *> *tileMatrixIds;

/** 是否是 RESTful 请求方式 */
@property (nonatomic, assign, getter=isRestQuery) BOOL restQuery;

/** 切片信息 */
@property (nonatomic, strong) AGSTileInfo *wmtsTileInfo;

/** 全幅大小 */
@property (nonatomic, strong) AGSEnvelope *wmtsFullEnvelope;

/** 初始化大小 */
@property (nonatomic, strong) AGSEnvelope *wmtsInitialEnvelope;


/**
 *  加载切片
 *
 *  @param usingCache 是否使用缓存
 *         - YES：本地缓存中没有时才从网络上获取
 *         - NO：只从网络上获取
 */
- (void)loadWMTSTileAndUsingCache:(BOOL)usingCache;

/**
 *  WMTS的切片缓存数据路径
 *  路径：~/Library/Caches/com.southgis.iMobile.WMTS_Tile/（切片URL的MD5值）
 *
 *  @return 切片缓存路径，当缓存文件夹创建失败时返回nil
 */
- (nullable NSString *)cachePath;

/**
 *  WMTS的切片缓存目录
 *  默认为：~/Library/Caches/com.southgis.iMobile.WMTS_Tile
 *
 *  @return WMTS切片缓存目录，当缓存目录创建失败时返回nil
 */
+ (nullable NSString *)wmtsTileCacheDirectory;

@end

NS_ASSUME_NONNULL_END
