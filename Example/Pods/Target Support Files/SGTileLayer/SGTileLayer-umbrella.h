#ifdef __OBJC__
#import <UIKit/UIKit.h>
#else
#ifndef FOUNDATION_EXPORT
#if defined(__cplusplus)
#define FOUNDATION_EXPORT extern "C"
#else
#define FOUNDATION_EXPORT extern
#endif
#endif
#endif

#import "SouthgisBdWMTSLayer.h"
#import "Southgis_BdWMTSLayerInfoDelegate.h"
#import "Southgis_BdWMTSLayerOperation.h"
#import "Southgis_TiledServiceLayer.h"
#import "Southgis_TiledServiceLayerInfo.h"
#import "Southgis_TiledServiceLayerInfoOperation+OfflineTiledInfo.h"
#import "Southgis_TiledServiceLayerInfoOperation.h"
#import "Southigs_TiledServiceLayerOperation.h"
#import "SGGDLayer.h"
#import "SGGDLayerInfoDelegate.h"
#import "SGGDLayerOperation.h"
#import "NSDictionary+YYAdd.h"
#import "SGSWMTSInfo.h"
#import "SGSWMTSLayer.h"
#import "SGSWMTSLayerInfo.h"
#import "SGTileLayerHeader.h"
#import "SGTileLayerUtil.h"
#import "SouthgisBaseTiledServiceLayer.h"
#import "SouthgisTiledMapHelper.h"
#import "SouthgisTdtType.h"
#import "SouthgisTdt_LayerInfo.h"
#import "SouthgisTdt_TileLayer.h"
#import "SouthgisTianDiTuWMTSLayerInfoDelegate.h"
#import "Southgis_WMTSLayerOperation.h"

FOUNDATION_EXPORT double SGTileLayerVersionNumber;
FOUNDATION_EXPORT const unsigned char SGTileLayerVersionString[];

