//
//  Southgis_TiledServiceLayerInfoOperation.h
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/2.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Southgis_TiledServiceLayerInfo.h"


/**
 * @author Jeremy, 16-03-03 11:03:55
 *
 * 对外通信代理
 */
@protocol LayerInfoOperationDelegate <NSObject>


/*回传切片信息*/
- (void)retLayerInfo:(Southgis_TiledServiceLayerInfo *)layerInfo;

@end

/**
 * @author Jeremy, 16-03-03 11:03:16
 *
 * 获取切片信息
 */
@interface Southgis_TiledServiceLayerInfoOperation : NSOperation

@property(nonatomic,strong)NSString *url;

/**切片信息实体**/
@property(nonatomic,strong)Southgis_TiledServiceLayerInfo *layerInfo;
//代理
@property(nonatomic,weak)id<LayerInfoOperationDelegate> delegate;

/**
 * @author Jeremy, 16-03-03 11:03:49
 *
 * 初始化方法
 *
 * @param murl 图层地址url
 *
 * @return 返回实例
 */
- (instancetype)initLayerInfoOperationUrl:(NSString *)murl;

 
@end
