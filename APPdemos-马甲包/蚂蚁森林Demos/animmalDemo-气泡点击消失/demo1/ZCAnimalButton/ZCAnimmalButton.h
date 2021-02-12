//
//  ZCAnimmalButton.h
//  demo1
//
//  Created by apple2 on 2018/6/20.
//  Copyright © 2018年 Guoao. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol HeadImgViewBtnDelegate <NSObject>
- (void)buttonClickBut;
@end
@class ZCAnimmalButtonSetting;

@interface ZCAnimmalButton : UIButton
@property (weak ,nonatomic) id<HeadImgViewBtnDelegate>headImgViewBtnDelegate;
@property (nonatomic,strong) ZCAnimmalButtonSetting *setting;
-(instancetype)initWithFrame:(CGRect)frame andEndPoint:(CGPoint)point;
@end
typedef NS_OPTIONS(NSUInteger, AnimmalButtonType) {
    AnimmalButtonYypeLine = 0,//直线
    AnimmalButtonTypeCurve = 1, //曲线
};
@interface ZCAnimmalButtonSetting :NSObject

@property (nonatomic,assign) int  totalCount;//动画产生imagView的个数 默认10个
@property (nonatomic,assign) CGFloat timeSpace;//产生imageVIew的时间间隔， 默认 2s
@property (nonatomic,assign) CGFloat duration;//动画时长 默认1s
@property (nonatomic ,strong)UIImage *iconImage;//默认button自身图片
@property (nonatomic,assign) AnimmalButtonType animationType;//动画的类型


+(ZCAnimmalButtonSetting *)defaultSetting;
@end
