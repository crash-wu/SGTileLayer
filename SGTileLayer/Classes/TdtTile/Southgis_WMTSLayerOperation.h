//
//  Southgis_WMTSLayerOperation.h
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/15.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SouthgisTdt_LayerInfo.h"
#import <ArcGIS/ArcGIS.h>

/**
 * @author Jeremy, 16-03-17 14:03:45
 *
 * WMTS图层请求切片操作
 */
@interface Southgis_WMTSLayerOperation : NSOperation

@property (nonatomic,strong) AGSTileKey* tileKey;
@property (nonatomic,weak) id target;
@property (nonatomic,assign) SEL action;
@property (nonatomic,strong) NSData* imageData;
@property (nonatomic,weak) SouthgisTdt_LayerInfo* layerInfo;

- (instancetype)initWithTileKey:(AGSTileKey *)tileKey TiledLayerInfo:(SouthgisTdt_LayerInfo *)layerInfo target:(id)target action:(SEL)action;

@end
