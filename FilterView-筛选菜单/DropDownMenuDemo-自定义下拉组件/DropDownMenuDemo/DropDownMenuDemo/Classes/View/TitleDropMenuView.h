//
//  TitleDropMenuView.h
//  TextColorRamp
//
//  Created by admin on 2017/6/22.
//  Copyright © 2017年 王晓丹. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol TitleDropMenuViewDelegate <NSObject>

- (void)titleButtonClick:(NSInteger)btnTag buttonSelect:(BOOL)isSelect;

@end


@interface TitleDropMenuView : UIView
//标题栏数组
@property (nonatomic, strong) NSArray *titleArray;
//标题栏带图标（没有可忽略，但如果部分标题有图片，则需要中间有占位空字段，即数组个数应一致）
@property (nonatomic, strong) NSArray *imageArray;
//标题栏选中状态图标（同上）
@property (nonatomic, strong) NSArray *imageSelectArray;
//默认标题颜色
@property (nonatomic, strong) NSString *titleColor;
//选中标题颜色
@property (nonatomic, strong) NSString *titleSelectColor;

@property (nonatomic, weak) id<TitleDropMenuViewDelegate> delegate;

+ (instancetype)TitleDropMenuViewInitWithFrame:(CGRect)frame otherSetting:(void (^)(TitleDropMenuView *titleMenuView))otherSetting;

@end
