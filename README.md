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
    例如：
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
    

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements
    ArcGIS-Runtime-SDK-iOS for version 10.2.5

## Installation

SGTileLayer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "SGTileLayer"
```

## Author

吴小星, xiaoxing.wu@southgis.com

## License

SGTileLayer is available under the MIT license. See the LICENSE file for more info.
