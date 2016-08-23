//
//  Southgis_BdWMTSLayerInfoDelegate.h
//  TianDituFramework
//
//  Created by 吴小星 on 16/3/31.
//  Copyright © 2016年 crash. All rights reserved.
//

#import "SouthgisBaseTiledServiceLayer.h"
#import "SouthgisTdt_LayerInfo.h"
#import "SouthgisBdWMTSLayer.h"

@interface Southgis_BdWMTSLayerInfoDelegate : SouthgisBaseTiledServiceLayer


/**
 *  @author crash         crash_wu@163.com   , 16-03-31 10:03:04
 *
 *  @brief  获取图层信息
 *
 *  @param wmtsLayerType 图层类型
 *
 *  @return 返回图层信息
 */
- (SouthgisTdt_LayerInfo *)getLayerInfo:(BDLayerTypes)wmtsLayerType;

@end
