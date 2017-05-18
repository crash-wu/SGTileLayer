//
//  SouthgisBdWMTSLayer.h
//  TianDituFramework
//
//  Created by 吴小星 on 16/3/31.
//  Copyright © 2016年 crash. All rights reserved.
//



#import "SouthgisBaseTiledServiceLayer.h"


@class SouthgisTdt_LayerInfo;



/**
 加载高德地图瓦片
 */
@interface SGGDLayer : SouthgisBaseTiledServiceLayer{
    
@protected
    //图层信息
    SouthgisTdt_LayerInfo* _layerInfo;
}



/**
 *  @author crash         crash_wu@163.com   , 16-03-31 09:03:55
 *
 *  @brief  初始化高德瓦片
 *
 *  @param outError     错误信息
 *
 *  @return 高德瓦片
 */
-(id)initWithLayerType:(NSError**) outError;



@end
