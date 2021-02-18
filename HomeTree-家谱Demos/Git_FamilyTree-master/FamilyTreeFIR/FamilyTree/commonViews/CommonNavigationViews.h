//
//  CommonNavigationViews.h
//  FamilyTree
//
//  Created by 王子豪 on 16/5/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WMenuBtn.h"

@class CommonNavigationViews;
@protocol CommandNavigationViewsDelegate <NSObject>
@optional
-(void)CommonNavigationViews:(CommonNavigationViews *)comView respondsToRightBtn:(UIButton *)sender;
//点击我的家谱，选择了某个家谱后的协议方法
-(void)CommonNavigationViews:(CommonNavigationViews *)comView selectedFamilyId:(NSString *)famId;
@end
@interface CommonNavigationViews : UIView

@property (nonatomic,strong) UIImageView *backView; /*头部*/
@property (nonatomic,strong) UILabel *titleLabel; /*标题*/
@property (nonatomic,strong) UIButton *rightBtn; /*右边按钮*/
@property (nonatomic,strong) UIButton *MyFamilyRightBtn;
@property (nonatomic,strong) UIButton *leftBtn;
/**右上角图标*/
@property (nonatomic,strong) WMenuBtn *rightMenuBtn;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title image:(UIImage *)imageName;

- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title;

//返回按钮
-(void)respondsToReturnBtn;

//右边按钮
-(void)respondsToRightBtn:(UIButton *)sender;

@property (nonatomic,weak) id<CommandNavigationViewsDelegate> delegate; /*代理人*/

@end
