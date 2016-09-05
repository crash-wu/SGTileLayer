//
//  SGTileLayerUtil.m
//  Pods
//
//  Created by 吴小星 on 16/8/23.
//
//

#import "SGTileLayerUtil.h"

@implementation SGTileLayerUtil


/**
 *  @author crash         crash_wu@163.com   , 16-08-23 10:08:01
 *
 *  @brief  单列
 *
 *  @return 类的对象
 */
+(nonnull instancetype)sharedInstance
{
    static SGTileLayerUtil *instance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        instance = [[self alloc] init];
    });
    return instance;
}

/**
 *  @author crash         crash_wu@163.com   , 16-09-01 17:09:01
 *
 *  @brief  加载天地图适量底图(CGCS2000 坐标系)
 *
 *  @param mapView 地图
 */
-(void)loadTdtCGCS2000:(nonnull AGSMapView *)mapView{
    

    self.mapView = mapView;
    [self clearCGCS2000:mapView];
    self.cev = [[SGSWMTSInfo alloc] initWithURLString:@"http://t0.tianditu.com/vec_c/wmts" delegate:self];
    
    self.cav = [[SGSWMTSInfo alloc] initWithURLString:@"http://t0.tianditu.com/cva_c/wmts" delegate:self];
}

/**
 *  @author crash         crash_wu@163.com   , 16-09-05 15:09:14
 *
 *  @brief  加载天地图影像底图
 *
 *  @param mapView 当前地图
 */
-(void) loadTdtImageCGCS2000:(nonnull AGSMapView *) mapView{
    self.mapView = mapView;
    [self clearCGCS2000:mapView];
    
    self.cev = [[SGSWMTSInfo alloc]initWithURLString:@"http://t0.tianditu.com/img_c/wmts" delegate:self];
    self.cav = [[SGSWMTSInfo alloc] initWithURLString:@"http://t0.tianditu.com/cva_c/wmts" delegate:self];
}

/**
 *  @author crash         crash_wu@163.com   , 16-09-05 15:09:05
 *
 *  @brief  清除天地图CGCS2000图层
 *
 *  @param mapView 当前地图
 */
-(void)clearCGCS2000:(nonnull AGSMapView *)mapView{
    
    //清除地图
    if(self.cev != nil){
        
        SGSWMTSLayerInfo *layerInfo = self.cev.layerInfos.firstObject;
        if(layerInfo != nil){
            
            [self.mapView removeMapLayerWithName:[NSString stringWithFormat:@"%@",layerInfo.tileURL]];
        }
        
    }
    
    //清除标识
    
    if(self.cav != nil){
        
        SGSWMTSLayerInfo *cavlayerInfo = self.cav.layerInfos.firstObject;
        if(cavlayerInfo != nil){
            
            [self.mapView removeMapLayerWithName:[NSString stringWithFormat:@"%@",cavlayerInfo.tileURL]];
        }
    }
    
}

#pragma mark - SGSWMTSInfoDelegate
- (void)sgsWMTSInfoDidLoad:(SGSWMTSInfo *)wmtsInfo {
    
    
    SGSWMTSLayerInfo *layerInfo = wmtsInfo.layerInfos.firstObject;
    if (layerInfo) {
        SGSWMTSLayer *layer = [wmtsInfo wmtsLayerWithLayerInfo:layerInfo];
        
        [self.mapView addMapLayer:layer withName:[NSString stringWithFormat:@"%@",layerInfo.tileURL]];
        
        [layer loadWMTSTileAndUsingCache:true];
    } else {
        NSLog(@"tuceng wei kong");
    }
}

- (void)sgsWMTSInfo:(SGSWMTSInfo *)wmtsInfo didFailToLoad:(NSError *)error {
    NSLog(@"failure: %@", error);
}


/**
 *  @author crash         crash_wu@163.com   , 16-08-23 10:08:49
 *
 *  @brief  加载天地图
 *
 *  @param tdtLayerType 天地图瓦片类型
 
 *  @param mapView      地图容器
 */
-(void)loadTdtTileLayer:(WMTSLayerTypes) tdtLayerType  andMapView :(nonnull AGSMapView * ) mapView{
    
    
    [mapView removeMapLayerWithName:@"tiandity_layer"];
    [mapView removeMapLayerWithName:@"tiandity_layer_annotation"];
    NSError *error;
    
    SouthgisTdt_TileLayer *layer = [[SouthgisTdt_TileLayer alloc]initWithLayerType:tdtLayerType error:&error];
    
    if(layer != nil){
        
        [mapView addMapLayer:layer withName:@"tiandity_layer"];

    }

    WMTSLayerTypes  annotation = WMTS_VECTOR_ANNOTATION_CHINESE_2000 ;

    switch (tdtLayerType) {
        case WMTS_VECTOR_MERCATOR://天地图矢量墨卡托投影地图服务
            annotation=WMTS_VECTOR_ANNOTATION_CHINESE_MERCATOR; /*!< 天地图矢量墨卡托中文标注 */
                break;

        case WMTS_IMAGE_MERCATOR://天地图影像墨卡托投影地图服务
                annotation=WMTS_IMAGE_ANNOTATION_CHINESE_MERCATOR; /*!< 天地图影像墨卡托投影中文标注 */
                break;

        case WMTS_TERRAIN_MERCATOR://天地图地形墨卡托投影地图服务
                annotation=WMTS_TERRAIN_ANNOTATION_CHINESE_MERCATOR; /*!< 天地图地形墨卡托投影中文标注 */
                break;

        case WMTS_VECTOR_2000://天地图矢量国家2000坐标系地图服务
                /*!< 天地图矢量国家2000坐标系中文标注 */
                annotation=WMTS_VECTOR_ANNOTATION_CHINESE_2000;

                break;

        case WMTS_IMAGE_2000://天地图影像国家2000坐标系地图服务
                /*!< 天地图影像国家2000坐标系中文标注 */
                annotation=WMTS_IMAGE_ANNOTATION_CHINESE_2000;

                break;

        case WMTS_TERRAIN_2000:
                /*!< 天地图地形国家2000坐标系中文标注 */
                annotation=WMTS_TERRAIN_ANNOTATION_CHINESE_2000;

                break;
        default:
                break;
        
    }

    SouthgisTdt_TileLayer *annotationLayer = [[SouthgisTdt_TileLayer alloc]initWithLayerType:annotation error:&error];
    if (annotationLayer != nil){

        [mapView addMapLayer:annotationLayer withName:@"tiandity_layer_annotation"];
    }
    
    //设置地图环绕
    [mapView enableWrapAround];
    
}


/**
 *  @author crash         crash_wu@163.com   , 16-08-23 10:08:31
 *
 *  @brief  清除天地图图层
 *
 *  @param mapView 地图容器
 */
-(void)clearTdtLayer:(nonnull AGSMapView * ) mapView{
    
    [mapView removeMapLayerWithName:@"tiandity_layer"];
    [mapView removeMapLayerWithName:@"tiandity_layer_annotation"];
}

/**
 *  @author crash         crash_wu@163.com   , 16-08-23 10:08:54
 *
 *  @brief  加载百度地图切片
 *
 *  @param mapView 地图
 */
-(void)loadBdTileLayer:(nonnull AGSMapView *)mapView{
    
    NSError *error;
    SouthgisBdWMTSLayer *bdLayer = [[SouthgisBdWMTSLayer alloc]initWithLayerType:BDVecLayerType error:&error];
    if (bdLayer != nil){
        
        [mapView addMapLayer:bdLayer withName:@"baidu_layer"];
    }
}

/**
 *  @author crash         crash_wu@163.com   , 16-08-23 10:08:00
 *
 *  @brief  清除百度瓦片图层
 *
 *  @param mapView 地图容器
 */
-(void)clearBdLayer:(nonnull AGSMapView *)mapView{
    [mapView removeMapLayerWithName:@"baidu_layer"];
}

/**
 *  @author crash         crash_wu@163.com   , 16-08-23 10:08:35
 *
 *  @brief  获取天地图当前图层级别
 *
 *  @param tdtLayer 天地图图层
 *
 *  @return 天地图当前图层级别
 */
-(NSInteger)currentLevel:(nonnull SouthgisTdt_TileLayer *)tdtLayer{
    
    return [tdtLayer currentLevel];
}






/**
 *  @author crash         crash_wu@163.com   , 16-08-26 16:08:49
 *
 *  @brief  将地图移到中国视图范围(天地图 墨卡托坐标系)
 *
 *  @param mapView 地图
 */
-(void) zoomToChineseWebspatialReference:(nonnull AGSMapView *) mapView{
    
    [mapView zoomToEnvelope:[[AGSEnvelope alloc] initWithXmin:7800000.0 ymin:44000.0 xmax:15600000.0 ymax:7500000.0 spatialReference:mapView.spatialReference ] animated: true];
}

/**
 *  @author crash         crash_wu@163.com   , 16-08-26 16:08:28
 *
 *  @brief 将地图移到中国视图范围(天地图国家坐标系)
 *
 *  @param mapView 地图
 */
-(void) zoomToChineseEnvelopeCGCS2000:(nonnull AGSMapView *)mapView{
    
    [mapView zoomToEnvelope:[[AGSEnvelope alloc] initWithXmin:80.76016586869 ymin:8.37639403682149 xmax:145.522396132932 ymax:52.9004273434877 spatialReference:mapView.spatialReference] animated:true];
}

@end
