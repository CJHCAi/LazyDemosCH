//
//  HK_LeSeeAddProductClassifyMenu.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//
//  商品分类菜单 点击可选择

#import <UIKit/UIKit.h>

/**
 数据来源
 */
typedef enum {
    /*初始化数据*/
    DataSourceType_Data_RecruitCategorys = 0,    //职位类别
//    DataSourceType_Data_Dic,   //所有下拉数据 预留，无操作
    DataSourceType_Data_RecruitIndustrys, //行业
    DataSourceType_Data_AllCategorys,   //所有分类
//    DataSourceType_Data_AllMediaCategorys, //所有自媒体分类 无操作
    
    /*自媒体电商数据*/
    DataSourceType_ShopData_AllMediaShopCategorys,//自媒体电商分类
    DataSourceType_ShopData_MediaAreas,   //自媒体快递地区
    DataSourceType_ShopData_SystemShopCategorys //系统电商分类
} DataSourceType;

/**
 选择商品分类菜单 类似ActionSheet
 */
@interface HK_LeSeeAddProductClassifyMenu : UIView


/**
 rootId 根节点id
 childId 子节点id
 */
@property (nonatomic,copy) void (^selectedBlock)(NSArray *selectedItems);

/**
 弹出菜单

 @param view 要添加到的视图
 @param type 数据类型
 @param animation 是否动画 默认NO
 */
+ (void)showInView:(UIView *)view
withDataSourceType:(DataSourceType)type
         animation:(BOOL)animation
  selectedCallback:(void (^)(NSArray *items))block;

@end
