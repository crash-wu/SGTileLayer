//
//  SGWMTSViewController.h
//  SGTileLayer
//
//  Created by 吴小星 on 16/8/30.
//  Copyright © 2016年 吴小星. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <ArcGIS/ArcGIS.h>
#import <SGTileLayer/SGTileLayerHeader.h>

@interface SGWMTSViewController : UIViewController

@property(nonatomic,strong,nullable) UIButton *wmtsBtn;
@property(nonatomic,strong,nullable) UIButton *getScale;
@property(nonatomic,strong,nullable) UIButton *zoonOut;
@property(nonatomic,strong,nullable) UIButton *zoomIn;
@property(nonnull,strong,nonatomic) UIButton *layerChangBtn;

@end
