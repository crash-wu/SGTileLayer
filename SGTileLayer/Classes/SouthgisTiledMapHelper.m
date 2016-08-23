//
//  SouthgisTiledMapHelper.m
//  imapMobile
//
//  Created by Lee on 16/7/11.
//  Copyright © 2016年 crash. All rights reserved.
//

#import "SouthgisTiledMapHelper.h"

static NSString *const kComponentPath = @"/Documents/TiledCache.plist";

@implementation SouthgisTiledMapHelper

// 保存切片缓存路径
+ (BOOL)recordTiledCachePath:(NSString *)cachePath withKey:(NSString *)key {
    NSString *recordsFilePath = [NSHomeDirectory() stringByAppendingString:kComponentPath];

    NSMutableDictionary *records = [[NSMutableDictionary alloc] initWithContentsOfFile:recordsFilePath];
    if (records == nil) {
        records = [[NSMutableDictionary alloc] init];
    }
    
    // 将HOME目录替换为~字符
    NSString *path = [cachePath stringByReplacingOccurrencesOfString:NSHomeDirectory() withString:@"~"];
    records[key] = path;
    
    BOOL result = [records writeToFile:recordsFilePath atomically:YES];
    
    // 标记不自动备份到iCloud和iTunes中
    [[NSURL fileURLWithPath:recordsFilePath] setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    
    return result;
}

// 保存切片缓存路径
+ (BOOL)recordTiledCachePaths:(NSDictionary<NSString *,NSString *> *)cachePaths {
    NSString *homeDir = NSHomeDirectory();
    NSString *recordsFilePath = [homeDir stringByAppendingString:kComponentPath];
    
    NSMutableDictionary *records = [NSMutableDictionary dictionary];
    
    [cachePaths enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull cachePath, BOOL * _Nonnull stop) {
        // 将HOME目录替换为~字符
        NSString *path = [cachePath stringByReplacingOccurrencesOfString:homeDir withString:@"~"];
        records[key] = path;
    }];
    
    BOOL result = [records writeToFile:recordsFilePath atomically:YES];
    
    // 标记不自动备份到iCloud和iTunes中
    [[NSURL fileURLWithPath:recordsFilePath] setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
    
    return result;
}


// 根据键值获取切片缓存路径
+ (NSString *)fetchTiledCachePathByKey:(NSString *)key {
    NSString *homeDir = NSHomeDirectory();
    NSString *recordsFilePath = [homeDir stringByAppendingString:kComponentPath];
    
    NSMutableDictionary *records = [[NSMutableDictionary alloc] initWithContentsOfFile:recordsFilePath];
    if (records == nil) {
        return nil;
    }
    
    NSString *result = records[key];
    // 将~字符替换为HOME目录
    result = [result stringByReplacingOccurrencesOfString:@"~" withString:homeDir];
    
    return result;
}


// 获取所有切片缓存路径
+ (NSDictionary<NSString *,NSString *> *)fetchAllTiledCachePaths {
    NSString *recordsFilePath = [NSHomeDirectory() stringByAppendingString:kComponentPath];
    
    NSMutableDictionary *records = [[NSMutableDictionary alloc] initWithContentsOfFile:recordsFilePath];
    if (records == nil) {
        return nil;
    }
    
    NSMutableDictionary *result = [NSMutableDictionary dictionary];
    NSString *homeDir = NSHomeDirectory();
    
    [records enumerateKeysAndObjectsUsingBlock:^(NSString *  _Nonnull key, NSString *  _Nonnull cachePath, BOOL * _Nonnull stop) {
        // 将~字符替换为HOME目录
        NSString *path = [cachePath stringByReplacingOccurrencesOfString:@"~" withString:homeDir];
        result[key] = path;
    }];
    
    return result.copy;
}


// 清除所有切片缓存路径
+ (void)clearAllTiledCachePaths {
    NSString *recordsFilePath = [NSHomeDirectory() stringByAppendingString:kComponentPath];
    [@{} writeToFile:recordsFilePath atomically:YES];
    [[NSURL fileURLWithPath:recordsFilePath] setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:nil];
}
@end
