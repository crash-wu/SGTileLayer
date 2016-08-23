//
//  SouthgisTiledMapHelper.h
//  imapMobile
//
//  Created by Lee on 16/7/11.
//  Copyright © 2016年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>


NS_ASSUME_NONNULL_BEGIN

/**
 *  切片地图辅助类
 */
@interface SouthgisTiledMapHelper : NSObject

/**
 *  记录切片缓存路径
 *
 *  @param cachePath 缓存路径
 *  @param key       键
 *
 *  @return 保存成功返回YES，保存失败返回NO
 */
+ (BOOL)recordTiledCachePath:(NSString *)cachePath withKey:(NSString *)key;


/**
 *  保存切片缓存路径
 *
 *  @param cachePaths 缓存路径
 *
 *  @return 保存成功返回YES，保存失败返回NO
 */
+ (BOOL)recordTiledCachePaths:(NSDictionary<NSString *, NSString *> *)cachePaths;


/**
 *  获取切片缓存路径
 *
 *  @param key 键
 *
 *  @return NSString or nil
 */
+ (nullable NSString *)fetchTiledCachePathByKey:(NSString *)key;


/**
 *  获取所有的切片缓存路径
 *
 *  @return NSDictionary or nil
 */
+ (nullable NSDictionary<NSString *, NSString *> *)fetchAllTiledCachePaths;

/**
 *  清除切片缓存路径
 */
+ (void)clearAllTiledCachePaths;

@end

NS_ASSUME_NONNULL_END