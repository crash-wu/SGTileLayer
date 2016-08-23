//
//  Southigs_TiledServiceLayerOperation.h
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/1.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "Southgis_TiledServiceLayerInfo.h"


/**
 * @author Jeremy, 16-03-01 16:03:05
 *
 * 切片请求操作
 */
@interface Southigs_TiledServiceLayerOperation : NSOperation

/**图层信息**/
@property(nonatomic,strong)Southgis_TiledServiceLayerInfo *layerInfo;
@property(nonatomic,strong)AGSTileKey *tileKey;
@property(nonatomic,assign)id target;
@property(nonatomic,assign)SEL action;
/**返回的数据信息**/
@property(nonatomic,strong)NSData *imageData;


/**
 * @author Jeremy, 16-03-01 16:03:13
 *
 * 初始化方法
 *
 * @param key       切片key
 * @param layerInfo 图层信息
 * @param target    目标方法
 * @param action    方法
 *
 * @return 实例对象
 */
- (instancetype)initOperationKey:(AGSTileKey *)key layerInfo:(Southgis_TiledServiceLayerInfo *)layerInfo target:(id)target action:(SEL)action;

@end
