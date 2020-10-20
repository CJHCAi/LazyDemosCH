//
//  MMSideslipDrawer.h
//  MMSideslipDrawer
//
//  Created by LEA on 2017/2/17.
//  Copyright © 2017年 LEA. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "UIView+Category.h"

//## 宏定义

// 设备物理宽度
#define kWidth                      [UIScreen mainScreen].bounds.size.width
// 设备物理高度
#define kHeight                     [UIScreen mainScreen].bounds.size.height
// 抽屉宽度
#define kMMSideslipWidth            240.0*kWidth/320
// 用户信息展示高度
#define kMMSideslipTopHeight        180
// 行高
#define kMMSideslipCellHeight       50
// 文字颜色
#define kMMSideslipMainColor        [UIColor colorWithRed:74.0/255.0 green:75.0/255.0 blue:90.0/255.0 alpha:1.0]

//View
@class MMSideslipItem;
@protocol MMSideslipDrawerDelegate;
@interface MMSideslipDrawer : UIView

//## 以下属性方便及时更新UI
// 头像[便于网络路径赋值 | 若为本地路径，可使用MMSideslipItem中的thumbnailPath]
@property (nonatomic, strong) UIImageView *portraitImageView;
// 用户名称
@property (nonatomic,copy) NSString *userName;
// 用户等级
@property (nonatomic,copy) NSString *userLevel;
// 等级图片名称
@property (nonatomic,copy) NSString *levelImageName;

//## 初始化的原始数据
// 展示的数据Model
@property (nonatomic, strong) MMSideslipItem *item;
// 代理
@property (nonatomic, assign) id<MMSideslipDrawerDelegate> delegate;

//## 外部接口
- (instancetype)initWithDelegate:(id<MMSideslipDrawerDelegate>)delegate slipItem:(MMSideslipItem *)item;
- (void)openLeftDrawerSide;
- (void)colseLeftDrawerSide;

@end

@protocol MMSideslipDrawerDelegate <NSObject>
@optional
// 查看列表项信息
- (void)slipDrawer:(MMSideslipDrawer *)slipDrawer didSelectAtIndex:(NSInteger)index;
// 查看用户信息
- (void)didViewUserInformation:(MMSideslipDrawer *)slipDrawer;
// 查看用户等级信息
- (void)didViewUserLevelInformation:(MMSideslipDrawer *)slipDrawer;
@end


//Model
@interface MMSideslipItem : NSObject

// 头像缩略图路径[本地路径，网络路径可直接对portraitImageView赋值]
@property (nonatomic,copy) NSString *thumbnailPath;
// 用户名称
@property (nonatomic,copy) NSString *userName;
// 用户等级
@property (nonatomic,copy) NSString *userLevel;
// 等级图片名称
@property (nonatomic,copy) NSString *levelImageName;
// 列表项名称数组（用于cell.textLabel.text）
@property (nonatomic,copy) NSArray *textArray;
// 列表项图片名称数组 (用于cell.imageView.image）
@property (nonatomic,copy) NSArray *imageNameArray;

@end


//Cell
@interface MMSideslipDrawerCell : UITableViewCell

@end

