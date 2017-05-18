//
//  Southgis_BdWMTSLayerInfoDelegate.m
//  TianDituFramework
//
//  Created by 吴小星 on 16/3/31.
//  Copyright © 2016年 crash. All rights reserved.
//

#import "SGGDLayerInfoDelegate.h"



//sr
#define kTILE_MATRIX_SET_MERCATOR @"w"
#define kTILE_MATRIX_SET_2000 @"c"



#define X_MIN_BD_MERCATOR -20037508.3427892
#define Y_MIN_BD_MERCATOR -20037508.3427892
#define X_MAX_BD_MERCATOR 20037508.3427892
#define Y_MAX_BD_MERCATOR 20037508.3427892



#define _minZoomLevel 0
#define _maxZoomLevel 19
#define _tileWidth 256
#define _tileHeight 256
#define _dpi 3857




@implementation SGGDLayerInfoDelegate


-(SouthgisTdt_LayerInfo*)getLayerInfo{
    
    SouthgisTdt_LayerInfo *layerInfo = [[SouthgisTdt_LayerInfo alloc]init];
    //normal parameters
    layerInfo.dpi = _dpi;
    layerInfo.tileHeight = _tileHeight;
    layerInfo.tileWidth = _tileWidth;
    layerInfo.minZoomLevel =_minZoomLevel;
    layerInfo.maxZoomLevel =_maxZoomLevel;

    layerInfo.srid = _dpi;
    layerInfo.xMax = X_MAX_BD_MERCATOR;
    layerInfo.xMin = X_MIN_BD_MERCATOR;
    layerInfo.yMax = Y_MAX_BD_MERCATOR;
    layerInfo.yMin = Y_MIN_BD_MERCATOR;
    layerInfo.tileMatrixSet = kTILE_MATRIX_SET_MERCATOR;
    layerInfo.origin = [AGSPoint pointWithX:X_MIN_BD_MERCATOR y:Y_MAX_BD_MERCATOR spatialReference:[[AGSSpatialReference alloc]initWithWKID:_dpi]];
    
    layerInfo.lods = [NSMutableArray arrayWithObjects:
                      [[AGSLOD alloc] initWithLevel:0 resolution:156543.033928 scale: 591657527.591555],
                      [[AGSLOD alloc] initWithLevel:1 resolution:78271.5169639999 scale: 295828763.795777],
                      [[AGSLOD alloc] initWithLevel:2 resolution:39135.7584820001 scale: 147914381.897889],
                      [[AGSLOD alloc] initWithLevel:3 resolution:19567.8792409999 scale: 73957190.948944],
                      [[AGSLOD alloc] initWithLevel:4 resolution:9783.93962049996 scale: 36978595.474472],
                      [[AGSLOD alloc] initWithLevel:5 resolution:4891.96981024998 scale: 18489297.737236],
                      [[AGSLOD alloc] initWithLevel:6 resolution:2445.98490512499 scale: 9244648.868618],
                      [[AGSLOD alloc] initWithLevel:7 resolution:1222.99245256249 scale: 4622324.434309],
                      [[AGSLOD alloc] initWithLevel:8 resolution:611.49622628138 scale: 2311162.217155],
                      [[AGSLOD alloc] initWithLevel:9 resolution:305.748113140558 scale: 1155581.108577],
                      [[AGSLOD alloc] initWithLevel:10 resolution:152.874056570411 scale: 577790.554289],
                      [[AGSLOD alloc] initWithLevel:11 resolution:76.4370282850732 scale: 288895.277144],
                      [[AGSLOD alloc] initWithLevel:12 resolution:38.2185141425366 scale: 144447.638572],
                      [[AGSLOD alloc] initWithLevel:13 resolution:19.1092570712683 scale: 72223.819286],
                      [[AGSLOD alloc] initWithLevel:14 resolution:9.55462853563415 scale: 36111.909643],
                      [[AGSLOD alloc] initWithLevel:15 resolution:4.77731426794937 scale:18055.954822],
                      [[AGSLOD alloc] initWithLevel:16 resolution:2.38865713397468 scale:  9027.977411],
                      [[AGSLOD alloc] initWithLevel:17 resolution:1.19432856685505 scale: 4513.988705],
                      [[AGSLOD alloc] initWithLevel:18 resolution:0.597164283559817 scale: 2256.9943525],
                      [[AGSLOD alloc] initWithLevel:19 resolution:0.298582141647617 scale: 1128.497176],
                      [[AGSLOD alloc]initWithLevel:20 resolution:0.14929107082 scale:564.248588],
                      [[AGSLOD alloc] initWithLevel:21 resolution:0.07464553541 scale: 282.124294],
//                      [[AGSLOD alloc] initWithLevel:22 resolution:0.0373227677 scale: 141.062147],
//                      [[AGSLOD alloc] initWithLevel:23 resolution:0.01866138385 scale: 70.5310735],
//                      [[AGSLOD alloc] initWithLevel:24 resolution:0.00933069192 scale: 35.26553675],
//                      [[AGSLOD alloc] initWithLevel:25 resolution:0.00466534596 scale: 17.632768375],
                      nil ];


    return layerInfo;
}


@end
