//
//  SouthgisTdtType.h
//  TianDituFramework
//
//  Created by 吴小星 on 16/5/5.
//  Copyright © 2016年 crash. All rights reserved.
//

#import <Foundation/Foundation.h>


/**
 天地图服务图层类型
 */
typedef enum {
    WMTS_VECTOR_MERCATOR = 0,	/*!< WMTS矢量墨卡托投影地图服务 */
    WMTS_VECTOR_ANNOTATION_CHINESE_MERCATOR=1,	/*!< WMTS矢量墨卡托中文标注 */
    WMTS_VECTOR_ANNOTATION_ENGLISH_MERCATOR=2,     /*!< WMTS矢量墨卡托英文标注 */
    WMTS_IMAGE_MERCATOR=3,     /*!< WMTS影像墨卡托投影地图服务 */
    WMTS_IMAGE_ANNOTATION_CHINESE_MERCATOR=4,     /*!< WMTS影像墨卡托投影中文标注 */
    WMTS_IMAGE_ANNOTATION_ENGLISH_MERCATOR=5,     /*!< WMTS影像墨卡托投影英文标注 */
    WMTS_TERRAIN_MERCATOR=6,     /*!< WMTS地形墨卡托投影地图服务 */
    WMTS_TERRAIN_ANNOTATION_CHINESE_MERCATOR=7,     /*!< WMTS地形墨卡托投影中文标注 */
    WMTS_VECTOR_2000 = 8,     /*!< WMTS矢量国家2000坐标系地图服务 */
    WMTS_VECTOR_ANNOTATION_CHINESE_2000=9,     /*!< WMTS矢量国家2000坐标系中文标注 */
    WMTS_VECTOR_ANNOTATION_ENGLISH_2000=10,     /*!< WMTS矢量国家2000坐标系英文标注 */
    WMTS_IMAGE_2000=11,     /*!< WMTS影像国家2000坐标系地图服务 */
    WMTS_IMAGE_ANNOTATION_CHINESE_2000=12,     /*!< WMTS影像国家2000坐标系中文标注 */
    WMTS_IMAGE_ANNOTATION_ENGLISH_2000=13,     /*!< WMTS影像国家2000坐标系中文标注 */
    WMTS_TERRAIN_2000=14,     /*!< WMTS地形国家2000坐标系地图服务 */
    WMTS_TERRAIN_ANNOTATION_CHINESE_2000=15,     /*!< WMTS地形国家2000坐标系中文标注 */
} WMTSLayerTypes;

@interface SouthgisTdtType : NSObject

@end
