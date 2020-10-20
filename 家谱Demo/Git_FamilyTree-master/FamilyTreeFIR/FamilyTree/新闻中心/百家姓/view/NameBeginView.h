//
//  NameBeginView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/11.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NameBeginView : UIView
-(instancetype)initWithFrame:(CGRect)frame Index:(int)index text:(NSString *)text;
/** 详情标签*/
@property (nonatomic, strong) UILabel *infoLB;
/** 线视图*/
@property (nonatomic, strong) UIView *lineView;
@end
