//
//  HKIconAndTitleCenterView.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/3.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HKIconAndTitleCenterView;
typedef void(^BtnClick)(HKIconAndTitleCenterView*sender);
@interface HKIconAndTitleCenterView : UIView
@property (nonatomic, copy)BtnClick click;
+(instancetype)iconAndTitleCenterViewWithTitle:(NSString*)title imageName:(NSString*)name backColor:(UIColor*)color click:(BtnClick)click;
-(void)setTitleColor:(UIColor*)color titleFont:(UIFont*)font imageName:(NSString*)imageName backColor:(UIColor*)backColor title:(NSString*)title;
@property (nonatomic, copy)NSString *imageName;
@property (nonatomic, copy)NSString *titleString;
@property (nonatomic, strong)UIFont *font;
@property (nonatomic, strong)UIColor *backColor;
@property (nonatomic, strong)UIColor *color;
@end
