//
//  SGSWMTSLayer.h
//  WMSDemoOC
//
//  Created by Lee on 16/5/27.
//  Copyright © 2016年 ArK. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>

@interface SGSWMTSLayer : AGSTiledLayer

/** GetTile 地址 */
@property (nonatomic, copy  ) NSString  *tileURLString;

/** WMTS 服务版本 */
@property (nonatomic, copy  ) NSString  *version;

/** 图层标识符 */
@property (nonatomic, copy  ) NSString  *layerIdentifier;

/** 图层名 */
@property (nonatomic, copy  ) NSString *layerName;

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
 *  @param usingCache 是否使用缓存）
 *         - YES：本地缓存中没有时才从网络上获取
 *         - NO：只从网络上获取
 */
- (void)loadWMTSTileAndUsingCache:(BOOL)usingCache;


/**
 *  WMTS的切片缓存数据路径
 *
 *  @return 缓存文件夹路径
 */
- (NSString *)cacheDocPath;

@end
