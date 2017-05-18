#
# Be sure to run `pod lib lint SGTileLayer.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'SGTileLayer'
  s.version          = '0.0.4'
  s.summary          = '天地图瓦片图层加载，百度地图瓦片图层加载等相关功能.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = '提供天地图瓦片图层加载，百度地图瓦片图层加载，高德瓦片加载，以及其他TileLayer类型图层加载等功能。在图层加载的时，提供缓存图层功能'


  s.homepage         = 'https://github.com/crash-wu/SGTileLayer'

  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { '吴小星' => 'crash_wu@163.com' }
  s.source           = { :git => 'https://github.com/crash-wu/SGTileLayer.git', :tag => s.version.to_s }


  s.ios.deployment_target = '8.0'

  s.source_files = 'SGTileLayer/Classes/**/*.{h,m}','SGTileLayer/Classes/*.{h,m}'

#s.public_header_files = 'SGTileLayer/Classes/SGTileLayerHeader.h'
   # s.public_header_files = 'Pod/Classes/**/*.h'

    s.xcconfig = {

    "FRAMEWORK_SEARCH_PATHS" => "$(HOME)/Library/SDKs/ArcGIS/iOS",

    "OTHER_LDFLAGS"  => '-ObjC -framework ArcGIS -l c++',
#$(inherited)

    'ENABLE_BITCODE' => 'NO',

    'CLANG_ENABLE_MODULES' => 'YES'
#'MACH_O_TYPE' => 'staticlib'
#'MACH_O_TYPE' => 'mh_execute'
#'MACH_O_TYPE' => 'mh_dylib'

    }


end
