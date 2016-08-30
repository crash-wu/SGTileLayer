//
//  SGWMTSViewController.m
//  SGTileLayer
//
//  Created by 吴小星 on 16/8/30.
//  Copyright © 2016年 吴小星. All rights reserved.
//

#import "SGWMTSViewController.h"

@interface SGWMTSViewController ()<AGSMapViewLayerDelegate, SGSWMTSInfoDelegate>

@property(strong,nonatomic) AGSMapView *mapView;
@property (strong) SGSWMTSInfo *info;
@property(strong) SGSWMTSInfo *cav;

@end

@implementation SGWMTSViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mapView = [[AGSMapView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:self.mapView];
    
    self.mapView.layerDelegate = self;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    
    _info = [[SGSWMTSInfo alloc] initWithURLString:@"http://t0.tianditu.com/vec_c/wmts" delegate:self];
    
    _cav = [[SGSWMTSInfo alloc] initWithURLString:@"http://t0.tianditu.com/cva_c/wmts" delegate:self];
    

    
}


-(void) zoomToChineseEnvelopeCGCS2000{
    
    [self.mapView zoomToEnvelope:[[AGSEnvelope alloc] initWithXmin:80.76016586869 ymin:8.37639403682149 xmax:145.522396132932 ymax:52.9004273434877 spatialReference:self.mapView.spatialReference] animated:true];
}

#pragma mark -
- (void)mapViewDidLoad:(AGSMapView *)mapView {
    
    //[self zoomToChineseEnvelopeCGCS2000];
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


@end
