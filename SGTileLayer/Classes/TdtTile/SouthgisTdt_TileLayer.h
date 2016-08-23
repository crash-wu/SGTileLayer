//
//  SouthgisTdt_TileLayer.h
//  TianDituFramework
//
//  Created by 吴小星 on 16/5/5.
//  Copyright © 2016年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Southgis_WMTSLayerOperation.h"
#import "SouthgisBaseTiledServiceLayer.h"
#import "SouthgisTdtType.h"

@interface SouthgisTdt_TileLayer : SouthgisBaseTiledServiceLayer{
    
@protected
    //图层信息
    SouthgisTdt_LayerInfo* _layerInfo;
    
}


/**
 *  @author crash         crash_wu@163.com   , 16-05-03 08:05:04
 *
 *  @brief  初始化天地图图层
 *
 *  @param wmtsLayerType 天地图图层类型
 *  @param outError      图层加载错误信息
 *
 *  @return 天地图图层
 */
- (instancetype)initWithLayerType:(WMTSLayerTypes) wmtsLayerType  error:(NSError**) outError;




@end
