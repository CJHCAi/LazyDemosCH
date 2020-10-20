//
//  wjFirstFoldView.h
//  foldCellTest
//
//  Created by gouzi on 2016/12/2.
//  Copyright © 2016年 wangjun. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface wjFirstFoldView : UIView

/* 显示的图片*/
@property (nonatomic, strong) UIImageView *indicateImageView;

/* 显示的文字*/
@property (nonatomic, strong) UILabel *dateLabel;

/* 分割线*/
@property (nonatomic, strong) UIView *separatorLine;

- (instancetype)init;
@end
