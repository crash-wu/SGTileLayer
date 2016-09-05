//
//  SGWMTSViewController.m
//  SGTileLayer
//
//  Created by 吴小星 on 16/8/30.
//  Copyright © 2016年 吴小星. All rights reserved.
//

#import "SGWMTSViewController.h"

@interface SGWMTSViewController ()<AGSMapViewLayerDelegate, SGSWMTSInfoDelegate,AGSLayerDelegate>

@property(strong,nonatomic) AGSMapView *mapView;
@property (strong) SGSWMTSInfo *info;
@property(strong) SGSWMTSInfo *cav;
@property(strong) AGSDynamicMapServiceLayer * dynamic;
@property(strong)SGSWMTSInfo *cev;

@property(assign) BOOL vecFlage ;

@end

@implementation SGWMTSViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mapView = [[AGSMapView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:self.mapView];
    
    self.wmtsBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.wmtsBtn.frame = CGRectMake(0, 0, 60, 30);
    [self.wmtsBtn setTitle:@"wmts" forState:UIControlStateNormal];
    [self.wmtsBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.wmtsBtn.backgroundColor = [UIColor blueColor];
    [self.wmtsBtn addTarget:self action:@selector(wmtLoad:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.wmtsBtn];
    
    self.getScale = [UIButton buttonWithType:UIButtonTypeCustom];
    self.getScale.frame = CGRectMake(60, 0, 60, 30);
    [self.getScale setTitle:@"scale" forState:UIControlStateNormal];
    [self.getScale setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.getScale.backgroundColor = [UIColor blueColor];
    [self.getScale addTarget:self action:@selector(getScaleTouch:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.getScale];
    
    self.zoomIn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zoomIn.frame = CGRectMake(120, 0, 60, 30);
    [self.zoomIn setTitle:@"+" forState:UIControlStateNormal];
    [self.zoomIn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.zoomIn.backgroundColor = [UIColor blueColor];
    [self.zoomIn addTarget:self action:@selector(zooIn:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.zoomIn];
    
    self.zoonOut = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zoonOut.frame = CGRectMake(180, 0, 60, 30);
    [self.zoonOut setTitle:@"-" forState:UIControlStateNormal];
    [self.zoonOut setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.zoonOut.backgroundColor = [UIColor blueColor];
    [self.zoonOut addTarget:self action:@selector(zoomOut:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.zoonOut];
    
    self.layerChangBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.layerChangBtn.frame = CGRectMake(240, 0, 60, 30);
    [self.layerChangBtn setTitle:@"切换" forState:UIControlStateNormal];
    [self.layerChangBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    self.layerChangBtn.backgroundColor = [UIColor blueColor];
    [self.layerChangBtn addTarget:self action:@selector(changeLayer:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.layerChangBtn];
    
    self.vecFlage = NO;
    self.mapView.layerDelegate = self;
    
    
}

-(void)changeLayer:(UIButton *)button{
    
    if(!self.vecFlage ){
        
        [[SGTileLayerUtil sharedInstance] loadTdtImageCGCS2000:self.mapView];
    }else{
        [[SGTileLayerUtil sharedInstance]loadTdtCGCS2000:self.mapView];
    }

    self.vecFlage = !self.vecFlage;
}

-(void)zooIn:(UIButton *)button{
    
    [self.mapView zoomIn:true];
}

-(void) zoomOut:(UIButton *)button{
    [self.mapView zoomOut:true];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
//    _info = [[SGSWMTSInfo alloc] initWithURLString:@"http://t0.tianditu.com/vec_c/wmts" delegate:self];
//
//    _cav = [[SGSWMTSInfo alloc] initWithURLString:@"http://t0.tianditu.com/cva_c/wmts" delegate:self];
    
    //加载天地图国标2000图层
    [[SGTileLayerUtil sharedInstance]loadTdtCGCS2000:self.mapView];
}

-(void)getScaleTouch:(UIButton *)button{
    
    AGSEnvelope *envelope = self.mapView.visibleAreaEnvelope;
    NSLog(@"mapEnvelope:%@",envelope);
    
    self.cev = [[SGTileLayerUtil sharedInstance] cev];
    NSLog(@"cev:%@",self.cev);
    
    NSLog(@"mapScal:%lf",self.mapView.mapScale);

}

-(void)wmtLoad:(UIButton *)button{
    
    [self.mapView removeMapLayerWithName:@"wmts"];
    
    self.dynamic = [[AGSDynamicMapServiceLayer alloc]initWithURL:[[NSURL alloc]initWithString:@"http://222.247.40.206:6080/arcgis/rest/services/WorkMap/gh_jingzhunfupin_minzheng/MapServer"]];
    self.dynamic.delegate = self;
    [self.mapView addMapLayer:self.dynamic withName:@"wmts"];

}

-(void) zoomToChineseEnvelopeCGCS2000{
    
    [self.mapView zoomToEnvelope:[[AGSEnvelope alloc] initWithXmin:80.76016586869 ymin:8.37639403682149 xmax:145.522396132932 ymax:52.9004273434877 spatialReference:self.mapView.spatialReference] animated:true];
}

#pragma mark -
- (void)mapViewDidLoad:(AGSMapView *)mapView {
    


}

#pragma mark - SGSWMTSInfoDelegate
- (void)sgsWMTSInfoDidLoad:(SGSWMTSInfo *)wmtsInfo {
    
    
    SGSWMTSLayerInfo *layerInfo = wmtsInfo.layerInfos.firstObject;
    if (layerInfo) {
        SGSWMTSLayer *layer = [wmtsInfo wmtsLayerWithLayerInfo:layerInfo];

        [self.mapView addMapLayer:layer];

        [layer loadWMTSTileAndUsingCache:true];
    } else {
        NSLog(@"tuceng wei kong");
    }
}

- (void)sgsWMTSInfo:(SGSWMTSInfo *)wmtsInfo didFailToLoad:(NSError *)error {
    NSLog(@"failure: %@", error);
}

-(void)layerDidLoad:(AGSLayer *)layer{
    
    NSLog(@"fullEnvelope:%@",layer.fullEnvelope);
    [self.mapView zoomToEnvelope:layer.fullEnvelope animated:true];
    [self.mapView zoomToScale:layer.minScale animated:true];

    NSLog(@"initalEnvelope:%@",layer.initialEnvelope);
    NSLog(@"minScale:%lf",layer.minScale);
}


@end
