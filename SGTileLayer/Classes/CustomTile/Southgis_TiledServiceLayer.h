//
//  Southgis_TiledServiceLayer.h
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/1.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import <ArcGIS/ArcGIS.h>
#import "Southgis_TiledServiceLayerInfo.h"
#import "SouthgisBaseTiledServiceLayer.h"
/**
 自定义切片服务图层实体
 */
@interface Southgis_TiledServiceLayer : SouthgisBaseTiledServiceLayer
{
@protected
    Southgis_TiledServiceLayerInfo *_layerInfo;
   
}


/**
 * @author Jeremy, 16-03-01 14:03:04
 *
 * 初始化
 *
 * @param url   图层地址
 *
 * @return 服务图层
 */
- (instancetype)initTiledServiceLayerURL:(NSString *)url;

@end
