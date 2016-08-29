//
//  TdtMapViewController.m
//  SGTileLayer
//
//  Created by 吴小星 on 16/8/23.
//  Copyright © 2016年 吴小星. All rights reserved.
//

#import "TdtMapViewController.h"
#import <SGTileLayer/SGTileLayerHeader.h>
//#import <SGTileLayer/Southgis_TiledServiceLayer.h>

//#import "SGTileLayerHeader.h"

@interface TdtMapViewController () <AGSMapViewLayerDelegate, SGSWMTSInfoDelegate>
//@property (weak, nonatomic) IBOutlet AGSMapView *mapView;

@property (strong) SGSWMTSInfo *info;
@end

@implementation TdtMapViewController

- (void)dealloc {
    NSLog(@"xiaohui");
}



- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    
    _mapView = [[AGSMapView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:_mapView];
    
    _mapView.layerDelegate = self;
    _info = [[SGSWMTSInfo alloc] initWithURLString:@"http://t0.tianditu.com/vec_c/wmts" delegate:self];
//    [[SGTileLayerUtil sharedInstance] loadTdtTileLayer:WMTS_VECTOR_2000 andMapView:self.mapView];
//    [self zoomToChineseEnvelopeCGCS2000];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];

}

-(void) zoomToChineseEnvelopeCGCS2000{
    
    [self.mapView zoomToEnvelope:[[AGSEnvelope alloc] initWithXmin:80.76016586869 ymin:8.37639403682149 xmax:145.522396132932 ymax:52.9004273434877 spatialReference:self.mapView.spatialReference] animated:true];
}

#pragma mark - 
- (void)mapViewDidLoad:(AGSMapView *)mapView {
    [self zoomToChineseEnvelopeCGCS2000];
}

#pragma mark - SGSWMTSInfoDelegate
- (void)sgsWMTSInfoDidLoad:(SGSWMTSInfo *)wmtsInfo {
    SGSWMTSLayerInfo *layerInfo = wmtsInfo.layerInfos.firstObject;
    if (layerInfo) {
        SGSWMTSLayer *layer = [wmtsInfo wmtsLayerWithLayerInfo:layerInfo];
        [_mapView addMapLayer:layer];
        
        [layer loadWMTSTileAndUsingCache:YES];
    } else {
        NSLog(@"tuceng wei kong");
    }
}

- (void)sgsWMTSInfo:(SGSWMTSInfo *)wmtsInfo didFailToLoad:(NSError *)error {
    NSLog(@"failure: %@", error);
}
@end
