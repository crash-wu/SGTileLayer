//
//  Southgis_TiledServiceLayerInfo.h
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/1.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <ArcGIS/ArcGIS.h>

/**
 * @author Jeremy, 16-03-03 11:03:55
 *
 * 切片信息实体类
 */

@interface Southgis_TiledServiceLayerInfo : NSObject

/*图层服务地址*/
@property (nonatomic,strong) NSString *url;

//切片信息参数
@property (nonatomic,strong) NSMutableArray *lods;
@property (nonatomic,strong) AGSEnvelope *initialExtent;
@property (nonatomic,strong) AGSEnvelope *fullExtent;
@property (nonatomic,strong) AGSTileInfo *tileInfo;
@property (nonatomic,assign) AGSUnits units;

/**
 * @author Jeremy, 16-03-03 11:03:48
 *
 * 初始化方法
 *
 * @param data 初始化数据
 *
 * @return 返回实例
 */
- (instancetype)initLayerInfoDictionary:(NSDictionary *)data;


@end
