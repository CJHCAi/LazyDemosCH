//
//  MuneItem.h
//  WKMuneController
//
//  Created by macairwkcao on 16/1/25.
//  Copyright © 2016年 CWK. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_OPTIONS(NSUInteger, GBButtonItemShowType){
    GBButtonItemShowTypeRadRight = 0,
    GBButtonItemShowTypeRadLeft,
    GBButtonItemShowTypeLine,
    GBButtonItemShowTypeRound,
};

@interface GBPopMenuButtonItem : UIButton

@property(nonatomic,assign)GBButtonItemShowType type;

/**
 *  MuneItem 初始化方法
 *
 *  @param size        尺寸
 *  @param image       图片
 *  @param heightImage 高亮图片
 *  @param target      target
 *  @param action      action
 */
-(instancetype)initWithSize:(CGSize)size image:(UIImage *)image heightImage:(UIImage *)heightImage target:(id)target action:(SEL)action;

/**
 *  MuneItem工厂方法
 *
 *  @param size        尺寸
 *  @param image       图片
 *  @param heightImage 高亮图片
 *  @param target      target
 *  @param action      action
 */
+(GBPopMenuButtonItem *)muneItemWithSize:(CGSize)size image:(UIImage *)image heightImage:(UIImage *)heightImage target:(id)target action:(SEL)action;

/**
 *  展开item,以kMuneItemShowTypeRadRight、kMuneItemShowTypeRadLeft以及kMuneItemShowTypeLine方式打开的item，其中kMuneItemShowTypeLine会调用itemShowWithTargetPoint方法
 *
 *  @param type  展开类型
 *  @param angle 角度
 */
-(void)itemShowWithType:(GBButtonItemShowType)type angle:(CGFloat)angle;

/**
 *  展开item,以kMuneItemShowTypeLine方式打开的item
 *
 *  @param targetPoint targetPoint 展开item目标点
 */
-(void)itemShowWithTargetPoint:(CGPoint)targetPoint type:(GBButtonItemShowType)type;

/**
 *  关闭时的平移方法
 */
-(void)itemHide;

@end
