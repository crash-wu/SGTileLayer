//
//  Southgis_TiledServiceLayerInfo.m
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/1.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import "Southgis_TiledServiceLayerInfo.h"


@implementation Southgis_TiledServiceLayerInfo


- (instancetype)initLayerInfoDictionary:(NSDictionary *)data{

    if (self = [super init]) {
        self.lods = [NSMutableArray array];
        [self parseData:data];
    }
    
    return self;
}

/**
 * @author Jeremy, 16-03-03 11:03:19
 *
 * 数据解析方法
 *
 * @param data 待解析数据
 */
- (void)parseData:(NSDictionary *)data{
    
    NSDictionary *tileInfo = [data objectForKey:@"tileInfo"];
   
    NSArray *lods = [tileInfo objectForKey:@"lods"];
    
    for (NSDictionary *item in lods) {
        
        AGSLOD *lod = [[AGSLOD alloc]initWithJSON:item];
        
        [self.lods addObject:lod];
    }
    
    NSDictionary *initialExtentDic = [data objectForKey:@"initialExtent"];
    
    NSDictionary *fullExtentDic = [data objectForKey:@"fullExtent"];
    
    self.initialExtent = [[AGSEnvelope alloc]initWithJSON:initialExtentDic];
    
    self.fullExtent = [[AGSEnvelope alloc]initWithJSON:fullExtentDic];
    
    self.tileInfo = [[AGSTileInfo alloc]initWithJSON:tileInfo];
    
    self.units = AGSUnitsMeters;
}

@end
