//
//  ChinaArea.h
//  地址选择器
//
//  Created by zhuming on 16/2/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FMDB.h"
#include "ProvinceModel.h" // 省份数据模型
#import "CityModel.h" // 城市数据模型
#import "AreaModel.h" // 区域数据模型
@interface ChinaArea : NSObject

// 公开省-市-区三个模型属性
/**
 *  省份模型
 */
@property (nonatomic,strong)ProvinceModel *provinceModel;
/**
 *  城市模型
 */
@property (nonatomic,strong)CityModel *cityModel;
/**
 *  地区模型
 */
@property (nonatomic,strong)AreaModel *areaModel;


/**
 *  插入省份数据
 *
 *  @param province 省份模型
 */
- (void)insterProvince:(ProvinceModel *)province;
/**
 *  插入城市数据
 *
 *  @param city 城市模型
 */
- (void)insterCity:(CityModel *)city;
/**
 *  插入区域数据
 *
 *  @param area 区域模型
 */
- (void)insterArea:(AreaModel *)area;




/**
 *  获取所有省份模型的集合数组
 *
 *  @return 返回所有省份数据模型的集合
 */
- (NSMutableArray *)getAllProvinceData;
/**
 *  根据省份ID获取对应的省份数据模型
 *
 *  @param provinceID 省份ID
 *
 *  @return 省份数据模型
 */
- (ProvinceModel *)getProvinceDataByID:(NSString *)provinceID;
/**
 *  根据省份ID获取该省份的所有城市数据模型的集合
 *
 *  @param parentID 省份ID
 *
 *  @return 一个省份的城市数据模型集合
 */
- (NSMutableArray *)getCityDataByParentID:(NSString *)parentID;
/**
 *  根据城市ID获取对应的城市数据模型
 *
 *  @param cityID 城市ID
 *
 *  @return 城市数据模型
 */
- (CityModel *)getCityDataByID:(NSString *)cityID;
/**
 *  根据城市ID获取该城市的所有区域数据模型的集合
 *
 *  @param parentID 城市ID
 *
 *  @return 一个城市的区域数据模型集合
 */
- (NSMutableArray *)getAreaDataByParentID:(NSString *)parentID;
/**
 *  根据地区ID获取对应的地区数据模型
 *
 *  @param areaID 地区ID
 *
 *  @return 地区数据模型
 */
- (AreaModel *)getAreaDataByID:(NSString *)areaID;
/**
 *  制作省份数据模型
 *
 *  @param GRADE          GRADE
 *  @param ID             省份ID
 *  @param NAME           省份名称
 *  @param PARENT_AREA_ID 上一级ID
 *
 *  @return 省份数据模型
 */
- (ProvinceModel *)makeProvinceModel:(NSNumber *)GRADE provinceID:(NSNumber *)ID name:(NSString *)NAME parentId:(NSNumber *)PARENT_AREA_ID;
/**
 *  制作城市数据模型
 *
 *  @param GRADE          GRADE
 *  @param ID             城市ID
 *  @param NAME           城市名称
 *  @param PARENT_AREA_ID 上一级省份ID
 *
 *  @return 城市数据模型
 */
- (CityModel *)makeCityModel:(NSNumber *)GRADE cityID:(NSNumber *)ID name:(NSString *)NAME parentId:(NSNumber *)PARENT_AREA_ID;
/**
 *  制作区域数据模型
 *
 *  @param GRADE          GRADE
 *  @param ID             区域ID
 *  @param NAME           区域名称
 *  @param PARENT_AREA_ID 上一级城市D
 *
 *  @return 区域数据模型
 */
- (AreaModel *)makeAreaModel:(NSNumber *)GRADE areaID:(NSNumber *)ID name:(NSString *)NAME parentId:(NSNumber *)PARENT_AREA_ID;
+(NSString*)getAddress:(NSString*)proCode city:(NSString*)cityCode area:(NSString*)areaCode;
@end
