# SGTileLayer

[![CI Status](http://img.shields.io/travis/crash_wu/SGTileLayer.svg?style=flat)](https://travis-ci.org/crash-wu/SGTileLayer)
[![Version](https://img.shields.io/cocoapods/v/SGTileLayer.svg?style=flat)](http://cocoapods.org/pods/SGTileLayer)
[![License](https://img.shields.io/cocoapods/l/SGTileLayer.svg?style=flat)](http://cocoapods.org/pods/SGTileLayer)
[![Platform](https://img.shields.io/cocoapods/p/SGTileLayer.svg?style=flat)](http://cocoapods.org/pods/SGTileLayer)

## Author

吴小星, crash_wu@163.com

## Decribe
提供天地图瓦片图层加载，百度地图瓦片图层加载，以及其他TileLayer类型图层加载等功能。在图层加载的时，提供缓存图层功能。 

## Class

![](http://images.cnblogs.com/cnblogs_com/crash-wu/875488/o_501B451D-EFE6-4673-BFF1-7E3223570854.png)

## Usage

    '#import <SGTileLayer/SGTileLayerHeader.h>'
    //引入头文件到项目中

### 加载天地图，百度地图瓦片
#### SGTileLayerUtil
    /**
    *  @author crash         crash_wu@163.com   , 16-08-23 10:08:01
    *
    *  @brief  单列
    *
    *  @return 类的对象
    */
    +(nonnull instancetype)sharedInstance;

    /**
    *  @author crash         crash_wu@163.com   , 16-08-23 10:08:31
    *
    *  @brief  清除天地图图层
    *
    *  @param mapView 地图容器
    */
    -(void)clearTdtLayer:(nonnull AGSMapView * ) mapView;


    /**
    *  @author crash         crash_wu@163.com   , 16-08-23 10:08:49
    *
    *  @brief  加载天地图
    *
    *  @param tdtLayerType 天地图瓦片类型

    *  @param mapView      地图容器
    */
    -(void)loadTdtTileLayer:(WMTSLayerTypes) tdtLayerType  andMapView :(nonnull AGSMapView * ) mapView;

    /**
    *  @author crash         crash_wu@163.com   , 16-08-23 10:08:54
    *
    *  @brief  加载百度地图切片
    *
    *  @param mapView 地图
    */
    -(void)loadBdTileLayer:(nonnull AGSMapView *)mapView;

    /**
    *  @author crash         crash_wu@163.com   , 16-08-23 10:08:00
    *
    *  @brief  清除百度瓦片图层
    *
    *  @param mapView 地图容器
    */
    -(void)clearBdLayer:(nonnull AGSMapView *)mapView;


    /**
    *  @author crash         crash_wu@163.com   , 16-08-23 10:08:35
    *
    *  @brief  获取天地图当前图层级别
    *
    *  @param tdtLayer 天地图图层
    *
    *  @return 天地图当前图层级别
    */
    -(NSInteger)currentLevel:(nonnull SouthgisTdt_TileLayer *)tdtLayer;
    
     /**
     *  @author crash         crash_wu@163.com   , 16-09-01 17:09:01
     *
     *  @brief  加载天地图底图(CGCS2000 坐标系)
     *
     *  @param mapView 地图
     */
    -(void)loadTdtCGCS2000:(nonnull AGSMapView *)mapView;
    
    /**
     *  @author crash         crash_wu@163.com   , 16-09-05 15:09:14
     *
     *  @brief  加载天地图影像底图
     *
     *  @param mapView 当前地图
     */
    -(void) loadTdtImageCGCS2000:(nonnull AGSMapView *) mapView;


    /**
     *  @author crash         crash_wu@163.com   , 16-09-05 15:09:05
     *
     *  @brief  清除天地图CGCS2000图层
     *
     *  @param mapView 当前地图
     */
    -(void)clearCGCS2000:(nonnull AGSMapView *)mapView;

**例如：**

```
加载天地图
[[SGTileLayerUtil sharedInstance] loadTdtTileLayer:WMTS_VECTOR_2000 andMapView:self.mapView];

//加载天地图国标2000图层
[[SGTileLayerUtil sharedInstance]loadTdtCGCS2000:self.mapView];

加载百度地图
[[SGTileLayerUtil sharedInstance] loadBdTileLayer:self.mapView];
```

### 加载其他 TileLayer图层服务
#### Southgis_TiledServiceLayer
    /**
    * @author Jeremy, 16-03-01 14:03:04
    *
    * 初始化
    *
    * @param url   图层地址
    *
    * @return 服务图层
    */
    - (instancetype)initTiledServiceLayerURL:(NSString *)url;

### 加载 WMTS服务图层
#### SGSWMTSInfo
    /**
    *  根据 GetCapabilities URL 实例化
    *
    *  如果实例化成功则自动开始进行 GetCapabilities，可以通过代理方法获取请求结果
    *  DPI 默认使用 96 dots/inch
    *
    *  @param url GetCapabilities 请求地址
    *
    *  @return SGSWMTSInfo or nil
    */
    - (instancetype)initWithURLString:(NSString *)url delegate:(id<SGSWMTSInfoDelegate>)delegate;

    /**
    *  根据 GetCapabilities URL 实例化
    *
    *  如果实例化成功则自动开始进行 GetCapabilities，可以通过代理方法获取请求结果
    *
    *  @param url GetCapabilities 请求地址
    *  @param dpi 切片 DPI
    *
    *  @return SGSWMTSInfo or nil
    */
    - (instancetype)initWithURLString:(NSString *)url tileDPI:(NSUInteger)dpi delegate:(id<SGSWMTSInfoDelegate>)delegate;


**例如：**

```
-(void)viewDidAppear:(BOOL)animated{
     [super viewDidAppear:animated];

   SGSWMTSInfo  * _info = [[SGSWMTSInfo alloc] initWithURLString:@"http://t0.tianditu.com/vec_c/wmts" delegate:self];
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
```

## Setting

**设置Framework search Patchs  以及 Other Links**
*	
    1.选择项目工程文档；
    2.选择Build Setting 菜单；
    3.选择 Frame work search Patchs ,并且添加 '$(inherited)'
    4.选择Others Links ，并且添加 ‘$(inherited)’*
    
**如图：**

![](http://images.cnblogs.com/cnblogs_com/crash-wu/875488/o_460B5749-015D-418F-BEB8-34F01623FC9C.png)

![](http://images.cnblogs.com/cnblogs_com/crash-wu/875488/o_3D6C9B5E-618C-4F0E-A3D2-D1F046A0810D.png)
    

**修改 SGTileLayer.framework编译属性**

*    由于ArcgisSDK是静态库的原因,所有pod Install ,或者pod update 后，要更改SGTileLayer.framework编译属性.
    1.点击打开Pods项目
    2.选择SGTileLayer.framework 
    3.选择Build Settings菜单栏;
    4.搜索Mach-o 编译库选项；
    5.修改Mach-o 为Static Library
    6.每次pod install 或者pod update 后，都要更改上述的编译配置信息；
    
**如下图所示：**


![](http://images.cnblogs.com/cnblogs_com/crash-wu/875488/o_AAFAA780-2095-467B-B442-F5A3159C2777.png)

     

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

加载天地图

![](http://images.cnblogs.com/cnblogs_com/crash-wu/875488/o_Tdt.gif)

加载百度地图
![](http://images.cnblogs.com/cnblogs_com/crash-wu/875488/o_百度地图.gif)

加载WMTS

![](http://images.cnblogs.com/cnblogs_com/crash-wu/875488/o_SGWTMTS.gif)

## Requirements

    ArcGIS-Runtime-SDK-iOS for version 10.2.5

## Installation

SGTileLayer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```
pod "SGTileLayer"
```

## License

SGTileLayer is available under the MIT license. See the LICENSE file for more info.
