//
//  Southgis_TiledServiceLayerInfoOperation.m
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/2.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import "Southgis_TiledServiceLayerInfoOperation.h"
#import "Southgis_TiledServiceLayerInfoOperation+OfflineTiledInfo.h"


@interface Southgis_TiledServiceLayerInfoOperation()


@end

#define CACHE_FILE_NAME @"tileinfo.txt"

@implementation Southgis_TiledServiceLayerInfoOperation


- (instancetype)initLayerInfoOperationUrl:(NSString *)murl{
    
    if (self = [super init]) {
        self.url = murl;
    }
    
    return self;
}

 
/**
 * @author Jeremy, 16-03-03 11:03:31
 *
 * 子线程运行主函数
 */
- (void)main{
    
    @autoreleasepool {
        
        if (self.url == nil ) {
            return;
        }
        
        
        NSURL *aUrl = [self getUrl:self.url];
        
        NSData *retData = [self getTiledDataFromeLocalFile:CACHE_FILE_NAME];
        
        if (retData == nil) {
            retData = [[NSData alloc] initWithContentsOfURL:aUrl];
        }
        
        
        if (retData != nil) {
            
            NSDictionary *data = [NSJSONSerialization JSONObjectWithData:retData options:NSJSONReadingMutableContainers error:nil];
            
            self.layerInfo = [[Southgis_TiledServiceLayerInfo alloc]initLayerInfoDictionary:data];
            
            [self cacheTiledInfoInLocalFile:retData fileName:CACHE_FILE_NAME];
        }
        
        self.layerInfo.url = self.url;
        
        __weak typeof(self) weakSelf = self;
        /*主线程执行代码*/
        dispatch_async(dispatch_get_main_queue(), ^{
            
            if (weakSelf.delegate) {
                [weakSelf.delegate retLayerInfo:weakSelf.layerInfo];
            }
        });
    }
}

/**
 * @author Jeremy, 16-03-01 16:03:17
 *
 * 返回请求地址
 *
 * @param mUrl 图层地址
 *
 * @return 返回图层服务信息地址
 */
- (NSURL *)getUrl:(NSString *)mUrl{
    
    NSString *requestUrl = [NSString stringWithFormat:@"%@?f=json",mUrl];
    
    return [NSURL URLWithString:requestUrl];
    
}

@end
