//
//  SGSWMTSInfo.h
//  WMSDemoOC
//
//  Created by Lee on 16/5/27.
//  Copyright © 2016年 ArK. All rights reserved.
//

//#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@class SGSWMTSLayerInfo;
@class SGSWMTSLayer;
@class AGSTileInfo;
@protocol SGSWMTSInfoDelegate;

extern const NSUInteger SGSWMTSDefaultDPI;



NS_ASSUME_NONNULL_BEGIN

///================================================================
///  MARK: - WMTS 服务信息
///================================================================

@interface SGSWMTSInfo : NSObject

/** WMTS GetCapabilities URL */
@property (nullable, nonatomic, copy, readonly) NSURL *URL;

/** WMTS 服务版本号 */
@property (nullable, nonatomic, copy, readonly) NSString *version;

/** 代理 */
@property (nullable, nonatomic, weak, readonly) id<SGSWMTSInfoDelegate> delegate;

/** 切片信息数组 */
@property (nullable, nonatomic, copy, readonly) NSArray<SGSWMTSLayerInfo *> *layerInfos;


/**
 *  矩阵集字典
 *  - key: 矩阵集标识符
 *  - value: 矩阵标识符数组
 *  如：{"EPSG:4326": ["EPSG:4326:0", "EPSG:4326:1", "EPSG:4326:2"...]}
 */
@property (nullable, nonatomic, copy, readonly) NSDictionary<NSString *, NSArray<NSString *> *> *tileMatrixSets;


/**
 *  切片信息字典
 *  - key: 矩阵集标识符
 *  - value: AGSTileInfo
  *  如：{"EPSG:4326": aTileInfo}
 */
@property (nullable, nonatomic, copy, readonly) NSDictionary<NSString *, AGSTileInfo *> *tileInfos;


/**
 *  当网络请求或解析 XML 数据失败时有值
 *  可通过 KVO 监听该属性获取失败的状况
 */
@property (nullable, nonatomic, strong, readonly) NSError *error;



/**
 *  根据 GetCapabilities URL 实例化
 *
 *  如果实例化成功则自动开始进行 GetCapabilities，可以通过代理方法获取请求结果
 *  DPI 默认使用 96 dots/inch
 *
 *  @param url GetCapabilities 请求地址
 *
 *  @return SGSWMTSInfo or nil
 */
- (instancetype)initWithURLString:(NSString *)url delegate:(id<SGSWMTSInfoDelegate>)delegate;

/**
 *  根据 GetCapabilities URL 实例化
 *
 *  如果实例化成功则自动开始进行 GetCapabilities，可以通过代理方法获取请求结果
 *
 *  @param url GetCapabilities 请求地址
 *  @param dpi 切片 DPI
 *
 *  @return SGSWMTSInfo or nil
 */
- (instancetype)initWithURLString:(NSString *)url tileDPI:(NSUInteger)dpi delegate:(id<SGSWMTSInfoDelegate>)delegate;


/**
 *  根据 XML 数据实例化
 *
 *  切片 DPI 默认使用 96 dots/inch
 *
 *  @param xmlData xml文本数据
 *
 *  @return SGSWMTSInfo or nil
 */
- (instancetype)initWithXMLData:(NSData *)xmlData delegate:(id<SGSWMTSInfoDelegate>)delegate;

/**
 *  根据 XML 数据实例化
 *
 *  @param xmlData xml文本数据
 *  @param dpi     切片 DPI
 *
 *  @return SGSWMTSInfo or nil
 */
- (instancetype)initWithXMLData:(NSData *)xmlData tileDPI:(NSUInteger)dpi delegate:(id<SGSWMTSInfoDelegate>)delegate;


/**
 *  根据 WMTSInfo 中的 LayerInfo 创建一个 WMTS 图层
 *
 *  @param layerInfo 切片图层信息
 *
 *  @return SGSWMTSLayer or nil
 */
- (nullable SGSWMTSLayer*)wmtsLayerWithLayerInfo:(SGSWMTSLayerInfo*)layerInfo;


/**
 *  WMTS的XML缓存数据路径
 *
 *  @return 缓存文件夹路径
 */
- (NSString *)cacheDocPath;

@end



///================================================================
///  MARK: - WMTS 服务信息代理
///================================================================

@protocol SGSWMTSInfoDelegate <NSObject>

@optional

/**
 *  当 WMTS 信息加载完毕后将调用该代理方法
 *
 *  @param wmtsInfo SGSWMTSInfo
 */
- (void)sgsWMTSInfoDidLoad:(SGSWMTSInfo*)wmtsInfo;

/**
 *  当 WMTS 信息加载失败后将调用该代理方法
 *
 *  @param wmtsInfo SGSWMTSInfo
 *  @param error    NSError
 */
- (void)sgsWMTSInfo:(SGSWMTSInfo*)wmtsInfo didFailToLoad:(NSError*)error;

@end

NS_ASSUME_NONNULL_END
