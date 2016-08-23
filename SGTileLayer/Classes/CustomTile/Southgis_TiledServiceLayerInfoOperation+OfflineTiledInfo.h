//
//  Southgis_TiledServiceLayerInfoOperation+OfflineTiledInfo.h
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/10.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import "Southgis_TiledServiceLayerInfoOperation.h"

/**
 * @author Jeremy, 16-03-10 17:03:42
 *
 * 切片信息缓存
 */
@interface Southgis_TiledServiceLayerInfoOperation (OfflineTiledInfo)

/**
 * @author Jeremy, 16-03-10 14:03:41
 *
 * 保存切片信息
 *
 * @param data     切片信息
 * @param fileName 文件名
 */
- (void)cacheTiledInfoInLocalFile:(NSData *)data fileName:(NSString *)fileName;

/**
 * @author Jeremy, 16-03-10 14:03:09
 *
 * 获取切片信息
 *
 * @param fileName 文件名
 *
 * @return 切片信息
 */
- (NSData *)getTiledDataFromeLocalFile:(NSString *)fileName;

@end
