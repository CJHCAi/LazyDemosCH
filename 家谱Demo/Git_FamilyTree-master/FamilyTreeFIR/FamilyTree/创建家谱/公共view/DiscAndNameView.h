//
//  DiscAndNameView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/3.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class DiscAndNameView;

@protocol DiscAndNameViewDelegate <NSObject>

-(void)DiscAndNameView:(DiscAndNameView *)view didFinishEditDetailLabel:(UITextField *)detailLabel;

@end

@interface DiscAndNameView : UIView
@property (nonatomic,strong) UILabel *titleLabel; /*标题*/
@property (nonatomic,strong) UITextField *detailLabel; /*内容*/
@property (nonatomic,weak) id<DiscAndNameViewDelegate> delegate; /*代理人*/



- (instancetype)initWithFrame:(CGRect)frame title:(NSString *)title detailCont:(NSString *)detailcont isStar:(BOOL)star;



@end
