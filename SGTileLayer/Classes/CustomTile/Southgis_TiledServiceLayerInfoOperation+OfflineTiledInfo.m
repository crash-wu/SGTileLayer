//
//  Southgis_TiledServiceLayerInfoOperation+OfflineTiledInfo.m
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/10.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import "Southgis_TiledServiceLayerInfoOperation+OfflineTiledInfo.h"

@implementation Southgis_TiledServiceLayerInfoOperation (OfflineTiledInfo)

- (void)cacheTiledInfoInLocalFile:(NSData *)data fileName:(NSString *)fileName{
    
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        
        NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
        
        NSString *docPath = [documentPaths objectAtIndex:0];
        
        NSString *tileInfoFilePath = [docPath stringByAppendingPathComponent:fileName];
        
        [data writeToFile:tileInfoFilePath atomically:YES];
        
    });
    
    
}


- (NSData *)getTiledDataFromeLocalFile:(NSString *)fileName{
    
    NSArray *documentPaths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory,  NSUserDomainMask,YES);
    
    NSString *docPath = [documentPaths objectAtIndex:0];
    
    NSString *tileInfoFilePath = [docPath stringByAppendingPathComponent:fileName];
    
    return [NSData dataWithContentsOfFile:tileInfoFilePath options:NSDataReadingMappedIfSafe error:nil];
}


@end
