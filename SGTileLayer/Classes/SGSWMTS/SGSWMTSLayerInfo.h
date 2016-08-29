//
//  SGSWMTSLayerInfo.h
//  WMSDemoOC
//
//  Created by Lee on 16/5/27.
//  Copyright © 2016年 ArK. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 *  WMTS 图层信息，由 SGSWMTSInfo 获取
 */
@interface SGSWMTSLayerInfo : NSObject

/** GetTile 地址 */
@property (nullable, nonatomic, strong) NSURL *tileURL;

/** 图层标识符 */
@property (nullable, nonatomic, copy) NSString *layerIdentifier;

/** 图层名 */
@property (nullable, nonatomic, copy) NSString *layerName;

/** 图层样式 */
@property (nonatomic, copy) NSString *styleIdentifier;

/** 图层内容格式 */
@property (nonatomic, copy) NSString *format;

/** 切片矩阵集 */
@property (nullable, nonatomic, copy) NSString *tileMatrixIdentifier;

/** 初始四角坐标 */
@property (nonatomic, assign) double initialXMin;
@property (nonatomic, assign) double initialYMin;
@property (nonatomic, assign) double initialXMax;
@property (nonatomic, assign) double initialYMax;

@end

NS_ASSUME_NONNULL_END