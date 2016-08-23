//
//  SouthgisBdWMTSLayer.h
//  TianDituFramework
//
//  Created by 吴小星 on 16/3/31.
//  Copyright © 2016年 crash. All rights reserved.
//

#import "SouthgisBaseTiledServiceLayer.h"
//#import "Southgis_WMTSLayerInfo.h"

@class SouthgisTdt_LayerInfo;

/**
 *  @author crash         crash_wu@163.com   , 16-03-31 09:03:14
 *
 *  @brief  百度地图图层类型
 */
typedef NS_ENUM(NSInteger,BDLayerTypes){
    /**
     *  @author crash         crash_wu@163.com   , 16-03-31 09:03:14
     *
     *  @brief  矢量图层
     */
    BDVecLayerType=44,
    /**
     *  @author crash         crash_wu@163.com   , 16-03-31 09:03:14
     *
     *  @brief  影像图层
     */
    BDIMageLayerType=46,
    /**
     *  @author crash         crash_wu@163.com   , 16-03-31 09:03:14
     *
     *  @brief  POI搜索图层
     */
    BDPOILayerType=47
};

@interface SouthgisBdWMTSLayer : SouthgisBaseTiledServiceLayer{
    
@protected
    //图层信息
    SouthgisTdt_LayerInfo* _layerInfo;
}



/**
 *  @author crash         crash_wu@163.com   , 16-03-31 09:03:55
 *
 *  @brief  初始化百度WMTS图层
 *
 *  @param wmtsLayerType 切片类型
 *  @param outError     错误信息
 *
 *  @return 百度WMTS图层
 */
-(id)initWithLayerType:(BDLayerTypes) wmtsLayerType error:(NSError**) outError;


/**
 * @author Jeremy, 16-03-29 17:03:29
 *
 * 子类继承父类后，调用此初始化方法
 *
 * @param cachePath 缓存本地地址，为空则不缓存
 *
 * @return WMTS图层对象
 */
- (instancetype)initWithCachePath:(NSString *)cachePath;

@end
