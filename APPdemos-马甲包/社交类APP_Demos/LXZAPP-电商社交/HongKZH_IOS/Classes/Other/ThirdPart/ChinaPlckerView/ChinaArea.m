//
//  ChinaArea.m
//  地址选择器
//
//  Created by zhuming on 16/2/15.
//  Copyright © 2016年 zhuming. All rights reserved.
//

#import "ChinaArea.h"
#import "HKChinaModel.h"
#import "HKWHUrl.h"
#import "HKProvinceModel.h"
#import "HKCityModel.h"
#import "getChinaList.h"
@interface ChinaArea ()

@property (nonatomic,strong)FMDatabaseQueue *fmdbQueue;
@property (nonatomic,strong)FMDatabase *dataBase;
@property (nonatomic,copy)NSString *dbPath;
@end

@implementation ChinaArea

- (instancetype)init{
    if (self = [super init]) {
        [self initDataBase];
//        [self creatProvinceTabel];
//        [self creatCityTabel];
//        [self creatAreaTabel];
    }
    return self;
}

/**
 *  初始化数据库
 */
- (void)initDataBase{
    self.dbPath=[[NSBundle mainBundle]pathForResource:@"china.db" ofType:nil];
    self.fmdbQueue = [[FMDatabaseQueue alloc] initWithPath:self.dbPath];
    self.dataBase = [[FMDatabase alloc] initWithPath:self.dbPath];
}
/**
 *  创建省份表单
 */
- (void)creatProvinceTabel{
    [self.dataBase open];
    [self.dataBase executeUpdate:@"CREATE TABLE IF  NOT EXISTS Province (rowid INTEGER PRIMARY KEY AUTOINCREMENT, GRADE text,ID text,NAME text,PARENT_AREA_ID text)"];
    [self.dataBase close];
}
/**
 *  创建城市表单
 */
- (void)creatCityTabel{
    [self.dataBase open];
    [self.dataBase executeUpdate:@"CREATE TABLE IF  NOT EXISTS City (rowid INTEGER PRIMARY KEY AUTOINCREMENT, GRADE text,ID text,NAME text,PARENT_AREA_ID text)"];
    [self.dataBase close];
}
/**
 *  创建区域表单
 */
- (void)creatAreaTabel{
    [self.dataBase open];
    [self.dataBase executeUpdate:@"CREATE TABLE IF  NOT EXISTS Area (rowid INTEGER PRIMARY KEY AUTOINCREMENT, GRADE text,ID text,NAME text,PARENT_AREA_ID text)"];
    [self.dataBase close];
}
/**
 *  插入省份数据
 *
 *  @param province 省份模型
 */
- (void)insterProvince:(ProvinceModel *)province{
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        [db executeUpdate:@"INSERT INTO Province (GRADE,ID,NAME,PARENT_AREA_ID) VALUES (?,?,?,?)",province.GRADE,province.ID,province.NAME,province.PARENT_AREA_ID];
        [db close];
    }];
}
/**
 *  插入城市数据
 *
 *  @param city 城市模型
 */
- (void)insterCity:(CityModel *)city{
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        [db executeUpdate:@"INSERT INTO City (GRADE,ID,NAME,PARENT_AREA_ID) VALUES (?,?,?,?)",city.GRADE,city.ID,city.NAME,city.PARENT_AREA_ID];
        [db close];
    }];
}
/**
 *  插入区域数据
 *
 *  @param area 区域模型
 */
- (void)insterArea:(AreaModel *)area{
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        [db open];
        [db executeUpdate:@"INSERT INTO Area (GRADE,ID,NAME,PARENT_AREA_ID) VALUES (?,?,?,?)",area.GRADE,area.ID,area.NAME,area.PARENT_AREA_ID];
        [db close];
    }];
}
/**
 *  获取所有省份模型的集合数组
 *
 *  @return 返回所有省份数据模型的集合
 */
- (NSMutableArray *)getAllProvinceData{
    NSMutableArray *provinceArray = [[NSMutableArray alloc] init];
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        [self openChinaAreaDB:db];
        FMResultSet *result = [db executeQuery:@"SELECT * FROM Province"];
        while ([result next]) {
            ProvinceModel *model = [[ProvinceModel alloc] init];
            model.GRADE = [result stringForColumn:@"GRADE"];
            model.ID = [result stringForColumn:@"ID"];
            model.NAME = [result stringForColumn:@"NAME"];
            model.PARENT_AREA_ID = [result stringForColumn:@"PARENT_AREA_ID"];
            [provinceArray addObject:model];
        }
        [db close];
    }];
    return provinceArray;
}
/**
 *  根据省份ID获取对应的省份数据模型
 *
 *  @param provinceID 省份ID
 *
 *  @return 省份数据模型
 */
- (ProvinceModel *)getProvinceDataByID:(NSString *)provinceID{
    ProvinceModel *pmodel = [[ProvinceModel alloc] init];
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        [self openChinaAreaDB:db];
        FMResultSet *result = [db executeQuery:@"SELECT * FROM Province WHERE ID = ?",provinceID];
        while ([result next]) {
            pmodel.GRADE = [result stringForColumn:@"GRADE"];
            pmodel.ID = [result stringForColumn:@"ID"];
            pmodel.NAME = [result stringForColumn:@"NAME"];
            pmodel.PARENT_AREA_ID = [result stringForColumn:@"PARENT_AREA_ID"];
        }
        [db close];
    }];
    return pmodel;
}
/**
 *  根据省份ID获取该省份的所有城市数据模型的集合
 *
 *  @param parentID 省份ID
 *
 *  @return 一个省份的城市数据模型集合
 */
- (NSMutableArray *)getCityDataByParentID:(NSString *)parentID{
    NSMutableArray *cityArray = [[NSMutableArray alloc] init];
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        [self openChinaAreaDB:db];
        FMResultSet *result = [db executeQuery:@"SELECT * FROM City WHERE PARENT_AREA_ID = ?",parentID];
        while ([result next]) {
            CityModel *model = [[CityModel alloc] init];
            model.GRADE = [result stringForColumn:@"GRADE"];
            model.ID = [result stringForColumn:@"ID"];
            model.NAME = [result stringForColumn:@"NAME"];
            model.PARENT_AREA_ID = [result stringForColumn:@"PARENT_AREA_ID"];
            [cityArray addObject:model];
        }
        [db close];
    }];
    return cityArray;
}
/**
 *  根据城市ID获取对应的城市数据模型
 *
 *  @param cityID 城市ID
 *
 *  @return 城市数据模型
 */
- (CityModel *)getCityDataByID:(NSString *)cityID{
    CityModel *pmodel = [[CityModel alloc] init];
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        [self openChinaAreaDB:db];
        FMResultSet *result = [db executeQuery:@"SELECT * FROM City WHERE ID = ?",cityID];
        while ([result next]) {
            pmodel.GRADE = [result stringForColumn:@"GRADE"];
            pmodel.ID = [result stringForColumn:@"ID"];
            pmodel.NAME = [result stringForColumn:@"NAME"];
            pmodel.PARENT_AREA_ID = [result stringForColumn:@"PARENT_AREA_ID"];
        }
        [db close];
    }];
    return pmodel;
}
/**
 *  根据城市ID获取该城市的所有区域数据模型的集合
 *
 *  @param parentID 城市ID
 *
 *  @return 一个城市的区域数据模型集合
 */
- (NSMutableArray *)getAreaDataByParentID:(NSString *)parentID{
    NSMutableArray *areaArray = [[NSMutableArray alloc] init];
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        [self openChinaAreaDB:db];
        FMResultSet *result = [db executeQuery:@"SELECT * FROM Area WHERE PARENT_AREA_ID = ?",parentID];
        while ([result next]) {
            AreaModel *model = [[AreaModel alloc] init];
            model.GRADE = [result stringForColumn:@"GRADE"];
            model.ID = [result stringForColumn:@"ID"];
            model.NAME = [result stringForColumn:@"NAME"];
            model.PARENT_AREA_ID = [result stringForColumn:@"PARENT_AREA_ID"];
            [areaArray addObject:model];
        }
        [db close];
    }];
    return areaArray;
}
/**
 *  根据地区ID获取对应的地区数据模型
 *
 *  @param areaID 地区ID
 *
 *  @return 地区数据模型
 */
- (AreaModel *)getAreaDataByID:(NSString *)areaID{
    AreaModel *pmodel = [[AreaModel alloc] init];
    [self.fmdbQueue inDatabase:^(FMDatabase *db) {
        [self openChinaAreaDB:db];
        FMResultSet *result = [db executeQuery:@"SELECT * FROM Area WHERE ID = ?",areaID];
        while ([result next]) {
            pmodel.GRADE = [result stringForColumn:@"GRADE"];
            pmodel.ID = [result stringForColumn:@"ID"];
            pmodel.NAME = [result stringForColumn:@"NAME"];
            pmodel.PARENT_AREA_ID = [result stringForColumn:@"PARENT_AREA_ID"];
        }
        [db close];
    }];
    return pmodel;
}
/**
 *  打开数据库
 *
 *  @param db db description
 */
- (void)openChinaAreaDB:(FMDatabase *)db{
    BOOL isOpen = [db open];
    if (isOpen == YES) {
//        ITLog(@"数据库ChinaArea.db 打开成功!\n路径 = %@",self.dbPath);
    }
    else{
//        ITLog(@"数据库ChinaArea.db 打开失败!\n路径 = %@",self.dbPath);
    }
}

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
- (ProvinceModel *)makeProvinceModel:(NSNumber *)GRADE provinceID:(NSNumber *)ID name:(NSString *)NAME parentId:(NSNumber *)PARENT_AREA_ID{
    ProvinceModel *model = [[ProvinceModel alloc] init];
    model.GRADE = [NSString stringWithFormat:@"%@",GRADE];
    model.ID = [NSString stringWithFormat:@"%@",ID];
    model.NAME = NAME;
    model.PARENT_AREA_ID = [NSString stringWithFormat:@"%@",PARENT_AREA_ID];
    return model;
}

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
- (CityModel *)makeCityModel:(NSNumber *)GRADE cityID:(NSNumber *)ID name:(NSString *)NAME parentId:(NSNumber *)PARENT_AREA_ID{
    CityModel *model = [[CityModel alloc] init];
    model.GRADE = [NSString stringWithFormat:@"%@",GRADE];
    model.ID = [NSString stringWithFormat:@"%@",ID];
    model.NAME = NAME;
    model.PARENT_AREA_ID = [NSString stringWithFormat:@"%@",PARENT_AREA_ID];
    return model;
}


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
- (AreaModel *)makeAreaModel:(NSNumber *)GRADE areaID:(NSNumber *)ID name:(NSString *)NAME parentId:(NSNumber *)PARENT_AREA_ID{
    AreaModel *model = [[AreaModel alloc] init];
    model.GRADE = [NSString stringWithFormat:@"%@",GRADE];
    model.ID = [NSString stringWithFormat:@"%@",ID];
    model.NAME = NAME;
    model.PARENT_AREA_ID = [NSString stringWithFormat:@"%@",PARENT_AREA_ID];
    return model;
}


+(NSString*)getAddress:(NSString*)proCode city:(NSString*)cityCode area:(NSString*)areaCode{
    NSString*pro = @"";;
    NSString*city = @"";
    NSString*areaStr = @"";
    HKChinaModel*chaina = [NSKeyedUnarchiver unarchiveObjectWithFile:KCityListData];
    for (HKProvinceModel*proM in chaina.provinces) {
        if (proM.code.intValue == proCode.intValue) {
            pro = proM.name;
            for (HKCityModel*cityM in proM.citys) {
                if (cityM.code.intValue == cityCode.intValue) {
                    city = cityM.name;
                    for (getChinaListAreas*areasM in cityM.areas) {
                        if (areasM.code.intValue == areaCode.intValue) {
                            areaStr = areasM.name;
                            break;
                        }
                    }
                    
                }
            }
        }
    }
    
    if (pro.length < 1) {
        pro = @"";
    }
    if (city.length < 1) {
        city = @"";
    }
    if (areaStr.length < 1) {
        areaStr = @"";
    }
    NSString*areaString =   [NSString stringWithFormat:@"%@%@%@",pro,city,areaStr];
    ;
    return areaString;
}


@end
