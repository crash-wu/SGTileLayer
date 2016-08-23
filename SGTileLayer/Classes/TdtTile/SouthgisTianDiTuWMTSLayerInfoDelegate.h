//
//  SouthgisTianDiTuWMTSLayerInfoDelegate.h
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/29.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SouthgisTdt_LayerInfo.h"
#import "SouthgisTdtType.h"

@interface SouthgisTianDiTuWMTSLayerInfoDelegate : NSObject

-(SouthgisTdt_LayerInfo*)getLayerInfo:(WMTSLayerTypes) tiandituType;

@end
