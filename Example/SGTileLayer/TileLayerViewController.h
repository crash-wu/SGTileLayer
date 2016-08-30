//
//  TileLayerViewController.h
//  SGTileLayer
//
//  Created by 吴小星 on 16/8/30.
//  Copyright © 2016年 吴小星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <SGTileLayer/SGTileLayerHeader.h>
@interface TileLayerViewController : UIViewController

@property(strong,nonatomic) AGSMapView *mapView;

@end
