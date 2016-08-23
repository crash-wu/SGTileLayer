//
//  SouthgisTianDiTuWMTSLayerInfoDelegate.m
//  RTLibrary-ios
//
//  Created by Jeremy on 16/3/29.
//  Copyright © 2016年 zlycare. All rights reserved.
//

#import "SouthgisTianDiTuWMTSLayerInfoDelegate.h"

//mecator
#define kURL_VECTOR_MERCATOR @"http://t0.tianditu.com/vec_w/wmts"
#define kURL_VECTOR_ANNOTATION_CHINESE_MERCATOR @"http://t0.tianditu.com/cva_w/wmts"
#define kURL_VECTOR_ANNOTATION_ENGLISH_MERCATOR @"http://t0.tianditu.com/eva_w/wmts"
#define kURL_IMAGE_MERCATOR @"http://t0.tianditu.com/img_w/wmts"
#define kURL_IMAGE_ANNOTATION_CHINESE_MERCATOR @"http://t0.tianditu.com/cia_w/wmts"
#define kURL_IMAGE_ANNOTATION_ENGLISH_MERCATOR @"http://t0.tianditu.com/cia_w/wmts"
#define kURL_TERRAIN_MERCATOR @"http://t0.tianditu.com/ter_w/wmts"
#define kURL_TERRAIN_ANNOTATION_CHINESE_MERCATOR @"http://t0.tianditu.com/cta_w/wmts"
//cgcs2000
#define kURL_VECTOR_2000 @"http://t0.tianditu.com/vec_c/wmts"
#define kURL_VECTOR_ANNOTATION_CHINESE_2000 @"http://t0.tianditu.com/cva_c/wmts"
#define kURL_VECTOR_ANNOTATION_ENGLISH_2000 @"http://t0.tianditu.com/eva_c/wmts"
#define kURL_IMAGE_2000 @"http://t0.tianditu.com/img_c/wmts"
#define kURL_IMAGE_ANNOTATION_CHINESE_2000 @"http://t0.tianditu.com/cia_c/wmts"
#define kURL_IMAGE_ANNOTATION_ENGLISH_2000 @"http://t0.tianditu.com/cia_c/wmts"
#define kURL_TERRAIN_2000 @"http://t0.tianditu.com/ter_c/wmts"
#define kURL_TERRAIN_ANNOTATION_CHINESE_2000 @"http://t0.tianditu.com/cta_c/wmts"

//services
#define kLAYER_NAME_VECTOR @"vec"
#define kLAYER_NAME_VECTOR_ANNOTATION_CHINESE @"cva"
#define kLAYER_NAME_VECTOR_ANNOTATION_ENGLISH @"eva"
#define kLAYER_NAME_IMAGE @"img"
#define kLAYER_NAME_IMAGE_ANNOTATION_CHINESE @"cia"
#define kLAYER_NAME_IMAGE_ANNOTATION_ENGLISH @"eia"
#define kLAYER_NAME_TERRAIN @"ter"
#define kLAYER_NAME_TERRAIN_ANNOTATION_CHINESE @"cta"

//sr
#define kTILE_MATRIX_SET_MERCATOR @"w"
#define kTILE_MATRIX_SET_2000 @"c"

//
#define SRID_2000 4490
#define SRID_MERCATOR 102100

#define X_MIN_2000 -180.0
#define Y_MIN_2000 -90.0
#define X_MAX_2000 180.0
#define Y_MAX_2000 90.0

#define X_MIN_MERCATOR -20037508.3427892
#define Y_MIN_MERCATOR -20037508.3427892
#define X_MAX_MERCATOR 20037508.3427892
#define Y_MAX_MERCATOR 20037508.3427892

#define _minZoomLevel 0
#define _maxZoomLevel 16
#define _tileWidth 256
#define _tileHeight 256
#define _dpi 96


@implementation SouthgisTianDiTuWMTSLayerInfoDelegate

-(SouthgisTdt_LayerInfo*)getLayerInfo:(WMTSLayerTypes) tiandituType{
    
    SouthgisTdt_LayerInfo *layerInfo = [[SouthgisTdt_LayerInfo alloc]init];
    //normal parameters
    layerInfo.dpi = _dpi;
    layerInfo.tileHeight = _tileHeight;
    layerInfo.tileWidth = _tileWidth;
    layerInfo.minZoomLevel =_minZoomLevel;
    layerInfo.maxZoomLevel =_maxZoomLevel;
    //sr
    if (tiandituType < 8) {//sr:webmecator
        layerInfo.srid = SRID_MERCATOR;
        layerInfo.xMax = X_MAX_MERCATOR;
        layerInfo.xMin = X_MIN_MERCATOR;
        layerInfo.yMax = Y_MAX_MERCATOR;
        layerInfo.yMin = Y_MIN_MERCATOR;
        layerInfo.tileMatrixSet = kTILE_MATRIX_SET_MERCATOR;
        layerInfo.origin = [AGSPoint pointWithX:X_MIN_MERCATOR y:Y_MAX_MERCATOR spatialReference:[[AGSSpatialReference alloc]initWithWKID:SRID_MERCATOR]];
        
        //wgs84:*(0.0254000508/96)/111194.872221777
        //mecator:*(0.0254000508/96)
        layerInfo.lods = [NSMutableArray arrayWithObjects:
                          [[AGSLOD alloc] initWithLevel:1 resolution:78271.51696402048 scale: 2.958293554545656E8],
                          [[AGSLOD alloc] initWithLevel:2 resolution:39135.75848201024 scale: 1.479146777272828E8],
                          [[AGSLOD alloc] initWithLevel:3 resolution:19567.87924100512 scale: 7.39573388636414E7],
                          [[AGSLOD alloc] initWithLevel:4 resolution:9783.93962050256 scale: 3.69786694318207E7],
                          [[AGSLOD alloc] initWithLevel:5 resolution:4891.96981025128 scale: 1.848933471591035E7],
                          [[AGSLOD alloc] initWithLevel:6 resolution:2445.98490512564 scale: 9244667.357955175],
                          [[AGSLOD alloc] initWithLevel:7 resolution:1222.9948985750834 scale: 4622333.678977588],
                          [[AGSLOD alloc] initWithLevel:8 resolution:611.49622628141 scale: 2311166.839488794],
                          [[AGSLOD alloc] initWithLevel:9 resolution:305.748113140705 scale: 1155583.419744397],
                          [[AGSLOD alloc] initWithLevel:10 resolution:152.8740565703525 scale: 577791.7098721985],
                          [[AGSLOD alloc] initWithLevel:11 resolution:76.43702828517625 scale: 288895.85493609926],
                          [[AGSLOD alloc] initWithLevel:12 resolution:38.21851414258813 scale: 144447.92746804963],
                          [[AGSLOD alloc] initWithLevel:13 resolution:19.109257071294063 scale: 72223.96373402482],
                          [[AGSLOD alloc] initWithLevel:14 resolution:9.554628535647032 scale: 36111.98186701241],
                          [[AGSLOD alloc] initWithLevel:15 resolution:4.777314267823516 scale: 18055.990933506204],
                          [[AGSLOD alloc] initWithLevel:16 resolution:2.388657133911758 scale:9027.995466753102],
                          [[AGSLOD alloc] initWithLevel:17 resolution:1.194328566955879 scale: 4513.997733376551],
                          [[AGSLOD alloc] initWithLevel:18 resolution:0.5971642834779395 scale: 2256.998866688275],
                          nil ];
        
    }else{//sr:cgcs2000
        layerInfo.srid = SRID_2000;
        layerInfo.xMax = X_MAX_2000;
        layerInfo.xMin = X_MIN_2000;
        layerInfo.yMax = Y_MAX_2000;
        layerInfo.yMin = Y_MIN_2000;
        layerInfo.tileMatrixSet = kTILE_MATRIX_SET_2000;
        layerInfo.origin = [AGSPoint pointWithX:X_MIN_2000 y:Y_MAX_2000 spatialReference:[[AGSSpatialReference alloc]initWithWKID:SRID_2000]];
        
        layerInfo.lods = [NSMutableArray arrayWithObjects:
                          [[AGSLOD alloc] initWithLevel:1 resolution:0.7031249999891485 scale: 2.958293554545656E8],
                          [[AGSLOD alloc] initWithLevel:2 resolution:0.35156249999999994 scale: 1.479146777272828E8],
                          [[AGSLOD alloc] initWithLevel:3 resolution:0.17578124999999997 scale: 7.39573388636414E7],
                          [[AGSLOD alloc] initWithLevel:4 resolution:0.08789062500000014 scale: 3.69786694318207E7],
                          [[AGSLOD alloc] initWithLevel:5 resolution:0.04394531250000007 scale: 1.848933471591035E7],
                          [[AGSLOD alloc] initWithLevel:6 resolution:0.021972656250000007 scale: 9244667.357955175],
                          [[AGSLOD alloc] initWithLevel:7 resolution:0.01098632812500002 scale: 4622333.678977588],
                          [[AGSLOD alloc] initWithLevel:8 resolution:0.00549316406250001 scale: 2311166.839488794],
                          [[AGSLOD alloc] initWithLevel:9 resolution:0.0027465820312500017 scale: 1155583.419744397],
                          [[AGSLOD alloc] initWithLevel:10 resolution:0.0013732910156250009 scale: 577791.7098721985],
                          [[AGSLOD alloc] initWithLevel:11 resolution:0.000686645507812499 scale: 288895.85493609926],
                          [[AGSLOD alloc] initWithLevel:12 resolution:0.0003433227539062495 scale: 144447.92746804963],
                          [[AGSLOD alloc] initWithLevel:13 resolution:0.00017166137695312503 scale: 72223.96373402482],
                          [[AGSLOD alloc] initWithLevel:14 resolution:0.00008583068847656251 scale: 36111.98186701241],
                          [[AGSLOD alloc] initWithLevel:15 resolution:0.000042915344238281406 scale: 18055.990933506204],
                          [[AGSLOD alloc] initWithLevel:16 resolution:0.000021457672119140645 scale:9027.995466753102],
                          [[AGSLOD alloc] initWithLevel:17 resolution:0.000010728836059570307 scale: 4513.997733376551],
                          [[AGSLOD alloc] initWithLevel:18 resolution:0.000005364418029785169 scale: 2256.998866688275],
                          nil ];
    }
    
    
    //other parameters
    switch (tiandituType) {
        case WMTS_VECTOR_MERCATOR:
            layerInfo.url = kURL_VECTOR_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_VECTOR;
            break;
        case WMTS_VECTOR_ANNOTATION_CHINESE_MERCATOR:
            layerInfo.url = kURL_VECTOR_ANNOTATION_CHINESE_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_VECTOR_ANNOTATION_CHINESE;
            break;
        case WMTS_VECTOR_ANNOTATION_ENGLISH_MERCATOR:
            layerInfo.url = kURL_VECTOR_ANNOTATION_ENGLISH_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_VECTOR_ANNOTATION_ENGLISH;
            break;
        case WMTS_IMAGE_MERCATOR:
            layerInfo.url = kURL_IMAGE_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_IMAGE;
            break;
        case WMTS_IMAGE_ANNOTATION_CHINESE_MERCATOR:
            layerInfo.url = kURL_IMAGE_ANNOTATION_CHINESE_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_IMAGE_ANNOTATION_CHINESE;
            break;
        case WMTS_IMAGE_ANNOTATION_ENGLISH_MERCATOR:
            layerInfo.url = kURL_IMAGE_ANNOTATION_ENGLISH_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_IMAGE_ANNOTATION_ENGLISH;
            break;
        case WMTS_TERRAIN_MERCATOR:
            layerInfo.url = kURL_TERRAIN_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_TERRAIN;
            break;
        case WMTS_TERRAIN_ANNOTATION_CHINESE_MERCATOR:
            layerInfo.url = kURL_TERRAIN_ANNOTATION_CHINESE_MERCATOR;
            layerInfo.layerName = kLAYER_NAME_TERRAIN_ANNOTATION_CHINESE;
            break;
        case WMTS_VECTOR_2000:
            layerInfo.url = kURL_VECTOR_2000;
            layerInfo.layerName = kLAYER_NAME_VECTOR;
            break;
        case WMTS_VECTOR_ANNOTATION_CHINESE_2000:
            layerInfo.url = kURL_VECTOR_ANNOTATION_CHINESE_2000;
            layerInfo.layerName = kLAYER_NAME_VECTOR_ANNOTATION_CHINESE;
            break;
        case WMTS_VECTOR_ANNOTATION_ENGLISH_2000:
            layerInfo.url = kURL_VECTOR_ANNOTATION_ENGLISH_2000;
            layerInfo.layerName = kLAYER_NAME_VECTOR_ANNOTATION_ENGLISH;
            break;
        case WMTS_IMAGE_2000:
            layerInfo.url = kURL_IMAGE_2000;
            layerInfo.layerName = kLAYER_NAME_IMAGE;
            break;
        case WMTS_IMAGE_ANNOTATION_CHINESE_2000:
            layerInfo.url = kURL_IMAGE_ANNOTATION_CHINESE_2000;
            layerInfo.layerName = kLAYER_NAME_IMAGE_ANNOTATION_CHINESE;
            break;
        case WMTS_IMAGE_ANNOTATION_ENGLISH_2000:
            layerInfo.url = kURL_IMAGE_ANNOTATION_ENGLISH_2000;
            layerInfo.layerName = kLAYER_NAME_IMAGE_ANNOTATION_ENGLISH;
            break;
        case WMTS_TERRAIN_2000:
            layerInfo.url = kURL_TERRAIN_2000;
            layerInfo.layerName = kLAYER_NAME_TERRAIN;
            break;
        case WMTS_TERRAIN_ANNOTATION_CHINESE_2000:
            layerInfo.url = kURL_TERRAIN_ANNOTATION_CHINESE_2000;
            layerInfo.layerName = kLAYER_NAME_TERRAIN_ANNOTATION_CHINESE;
            break;
        default:
            break;
    }
    
    return layerInfo;
}
@end
