//
//  BDMapViewController.m
//  SGTileLayer
//
//  Created by 吴小星 on 16/8/23.
//  Copyright © 2016年 吴小星. All rights reserved.
//

#import "BDMapViewController.h"
#import <SGTileLayer/SGTileLayerHeader.h>

@interface BDMapViewController ()

@end

@implementation BDMapViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[AGSMapView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.mapView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [[SGTileLayerUtil sharedInstance] loadBdTileLayer:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
