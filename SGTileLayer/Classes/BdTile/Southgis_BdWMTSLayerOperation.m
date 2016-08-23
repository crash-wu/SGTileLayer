//
//  Southgis_BdWMTSLayerOperation.m
//  TianDituFramework
//
//  Created by 吴小星 on 16/3/31.
//  Copyright © 2016年 crash. All rights reserved.
//

#import "Southgis_BdWMTSLayerOperation.h"

@implementation Southgis_BdWMTSLayerOperation



- (instancetype)initWithTileKey:(AGSTileKey *)tileKey TiledLayerInfo:(SouthgisTdt_LayerInfo *)layerInfo target:(id)target action:(SEL)action{
    
    if (self = [super init]) {
        self.target = target;
        self.action = action;
        self.tileKey = tileKey;
        self.layerInfo = layerInfo;
        
    }
    return self;
}

-(void)main {
    //Fetch the tile for the requested Level, Row, Column
    @try {
        if (self.tileKey.level > self.layerInfo.maxZoomLevel ||self.tileKey.level < self.layerInfo.minZoomLevel) {
            return;
        }


        
        NSInteger zoom=self.tileKey.level-1;
        NSInteger offsetX=pow(2, zoom);
        NSInteger offsetY=offsetX-1;
        NSInteger numx=self.tileKey.column-offsetX;
        NSInteger numy=offsetY-self.tileKey.row;
        zoom=self.tileKey.level+1;
        
        NSInteger num = (self.tileKey.column + self.tileKey.row)% 8 + 1;
        
        NSString *baseUrl=[NSString stringWithFormat:@"http://online%ld.%map.bdimg.com/tile/?qt=tile&x=%ld&y=%ld&z=%ld",num,numx,numy,zoom];
        NSLog(@"baseUrl=%@",baseUrl );
        
        NSURL* aURL = [NSURL URLWithString:baseUrl];
        self.imageData = [[NSData alloc] initWithContentsOfURL:aURL];
    }
    @catch (NSException *exception) {
        NSLog(@"main: Caught Exception %@: %@", [exception name], [exception reason]);
    }
    @finally {
        //Invoke the layer's action method
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        [_target performSelector:_action withObject:self];
    }
    
}





@end
