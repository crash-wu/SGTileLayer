//
//  TdtMapViewController.m
//  SGTileLayer
//
//  Created by 吴小星 on 16/8/23.
//  Copyright © 2016年 吴小星. All rights reserved.
//

#import "TdtMapViewController.h"
#import <SGTileLayer/SGTileLayerHeader.h>


@interface TdtMapViewController () <AGSMapViewLayerDelegate>

@property(strong,nonatomic) AGSMapView *mapView;

@end

@implementation TdtMapViewController



- (void)viewDidLoad {
    [super viewDidLoad];

    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = NO;
    self.mapView = [[AGSMapView alloc]initWithFrame:self.view.frame];
    
    [self.view addSubview:self.mapView];
    
    self.mapView.layerDelegate = self;


}

- (void)viewWillAppear:(BOOL)animated {


}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];


//        AGSTiledMapServiceLayer * tileLayer = [[AGSTiledMapServiceLayer alloc]initWithURL:[[NSURL alloc]initWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"]];
//        [self.mapView addMapLayer:tileLayer];
    
        [[SGTileLayerUtil sharedInstance] loadTdtTileLayer:WMTS_VECTOR_2000 andMapView:self.mapView];

}


-(void) zoomToChineseEnvelopeCGCS2000{
    
    [self.mapView zoomToEnvelope:[[AGSEnvelope alloc] initWithXmin:80.76016586869 ymin:8.37639403682149 xmax:145.522396132932 ymax:52.9004273434877 spatialReference:self.mapView.spatialReference] animated:true];
}

#pragma mark - 
- (void)mapViewDidLoad:(AGSMapView *)mapView {
    
    [self zoomToChineseEnvelopeCGCS2000];
}

@end
