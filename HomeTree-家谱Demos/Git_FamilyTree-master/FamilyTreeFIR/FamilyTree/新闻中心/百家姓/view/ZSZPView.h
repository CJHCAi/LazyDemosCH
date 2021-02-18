//
//  ZSZPView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/11.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZSZPView : UIView
-(instancetype)initWithFrame:(CGRect)frame Title:(NSString *)title Text:(NSString *)text;
/** 详情标签*/
@property (nonatomic, strong) UILabel *textLB;
@end
