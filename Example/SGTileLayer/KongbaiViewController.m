//
//  KongbaiViewController.m
//  SGTileLayer
//
//  Created by 吴小星 on 16/8/30.
//  Copyright © 2016年 吴小星. All rights reserved.
//

#import "KongbaiViewController.h"

@interface KongbaiViewController ()

@end

@implementation KongbaiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.mapView = [[AGSMapView alloc]initWithFrame:self.view.frame];
    [self.view addSubview:self.mapView];
    self.edgesForExtendedLayout = UIRectEdgeNone;
    self.automaticallyAdjustsScrollViewInsets = false;
    
    [[SGTileLayerUtil sharedInstance] loadGDLayer:self.mapView];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



@end
