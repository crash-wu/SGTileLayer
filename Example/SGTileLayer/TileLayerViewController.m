//
//  TileLayerViewController.m
//  SGTileLayer
//
//  Created by 吴小星 on 16/8/30.
//  Copyright © 2016年 吴小星. All rights reserved.
//

#import "TileLayerViewController.h"

@interface TileLayerViewController ()<AGSMapViewLayerDelegate>

@end

@implementation TileLayerViewController

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
    
    
     AGSTiledMapServiceLayer* tileLayer = [[AGSTiledMapServiceLayer alloc]initWithURL:[[NSURL alloc]initWithString:@"http://services.arcgisonline.com/ArcGIS/rest/services/World_Topo_Map/MapServer"]];
    [self.mapView addMapLayer:tileLayer];

    
}

-(void)mapViewDidLoad:(AGSMapView *)mapView{
    
    
}

@end
