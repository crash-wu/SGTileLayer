//
//  Southigs_TiledServiceLayerOperation.m
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/1.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import "Southigs_TiledServiceLayerOperation.h"

 
@implementation Southigs_TiledServiceLayerOperation

#define kURLGetTile @"%@/tile/%ld/%ld/%ld"

- (instancetype)initOperationKey:(AGSTileKey *)key layerInfo:(Southgis_TiledServiceLayerInfo *)layerInfo target:(id)target action:(SEL)action{
    if (self = [super init]) {
        self.layerInfo = layerInfo;
        self.tileKey = key;
        _target = target;
        _action = action;
    }
    
    return self;
}

/**
 * @author Jeremy, 16-03-01 16:03:18
 *
 * 主函数
 */
-(void)main{
    
    @autoreleasepool {
        
        if ( !self.layerInfo.url ) {
            
            return;
        }
        
        
        NSString *baseUrl = [NSString stringWithFormat:kURLGetTile,self.layerInfo.url,self.tileKey.level,self.tileKey.row,self.tileKey.column];
        
        self.imageData = [[NSData alloc] initWithContentsOfURL:[NSURL URLWithString:baseUrl]];
        
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        
        [_target performSelector:_action withObject:self];
        
    }
}



@end
