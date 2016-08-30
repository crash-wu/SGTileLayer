
//
//  Southgis_WMTSLayerOperation.m
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/15.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import "Southgis_WMTSLayerOperation.h"

#define kURLGetTile @"%@?service=wmts&request=gettile&version=1.0.0&layer=%@&format=tiles&tilematrixset=%@&tilecol=%ld&tilerow=%ld&tilematrix=%ld"

@implementation Southgis_WMTSLayerOperation

@synthesize tileKey=_tileKey;
@synthesize target=_target;
@synthesize action=_action;
@synthesize imageData = _imageData;
@synthesize layerInfo = _layerInfo;


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
    
    if (self.cancelled || self.tileKey == nil) {
        return ;
    }
    
    //Fetch the tile for the requested Level, Row, Column
    @try {
        if (self.tileKey.level > self.layerInfo.maxZoomLevel ||self.tileKey.level < self.layerInfo.minZoomLevel) {
            return;
        }
        
        NSString *baseUrl= [NSString stringWithFormat:kURLGetTile,self.layerInfo.url,self.layerInfo.layerName,self.layerInfo.tileMatrixSet,self.tileKey.column,self.tileKey.row,(self.tileKey.level + 1)];
      //   NSLog(baseUrl);
        NSURL* aURL = [NSURL URLWithString:baseUrl];
        self.imageData = [[NSData alloc] initWithContentsOfURL:aURL];
    }
    @catch (NSException *exception) {
        NSLog(@"main: Caught Exception %@: %@", [exception name], [exception reason]);
    }
    @finally {
        
        //Invoke the layer's action method
#pragma clang diagnostic ignored "-Warc-performSelector-leaks"
        if (_target != nil) {
            [_target performSelectorOnMainThread:_action withObject:self waitUntilDone:YES];
//            [_target performSelector:_action withObject:self];
        }
    }
}


 



@end
