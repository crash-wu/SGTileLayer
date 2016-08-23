//
//  TdtMapViewController.m
//  SGTileLayer
//
//  Created by 吴小星 on 16/8/23.
//  Copyright © 2016年 吴小星. All rights reserved.
//

#import "TdtMapViewController.h"
#import <SGTileLayer/SGTileLayerHead.h>

@interface TdtMapViewController ()


@end

@implementation TdtMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[AGSMapView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.mapView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[SGTileLayerUtil sharedInstance] loadTdtTileLayer:WMTS_VECTOR_2000 andMapView:self.mapView];
}



@end
