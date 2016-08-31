# SGTileLayer

[![CI Status](http://img.shields.io/travis/吴小星/SGTileLayer.svg?style=flat)](https://travis-ci.org/吴小星/SGTileLayer)
[![Version](https://img.shields.io/cocoapods/v/SGTileLayer.svg?style=flat)](http://cocoapods.org/pods/SGTileLayer)
[![License](https://img.shields.io/cocoapods/l/SGTileLayer.svg?style=flat)](http://cocoapods.org/pods/SGTileLayer)
[![Platform](https://img.shields.io/cocoapods/p/SGTileLayer.svg?style=flat)](http://cocoapods.org/pods/SGTileLayer)

## Decribe
提供天地图瓦片图层加载，百度地图瓦片图层加载，以及其他TileLayer类型图层加载等功能。在图层加载的时，提供缓存图层功能。 

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
    - 
例如：

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
## Setting
    由于ArcgisSDK是静态库的原因,所有pod Install ,或者pod update 后，要更改SGTileLayer.framework编译属性.
    1.点击打开Pods项目
    2.选择SGTileLayer.framework 
    3.选择Build Settings菜单栏;
    4.搜索Mach-o 编译库选项；
    5.修改Mach-o 为Static Library
    6.每次pod install 或者pod update 后，都要更改上述的编译配置信息；
    如下图所示：
    
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

```ruby
pod "SGTileLayer"
```

## Author

吴小星, crash_wu@163.com

## License

SGTileLayer is available under the MIT license. See the LICENSE file for more info.
