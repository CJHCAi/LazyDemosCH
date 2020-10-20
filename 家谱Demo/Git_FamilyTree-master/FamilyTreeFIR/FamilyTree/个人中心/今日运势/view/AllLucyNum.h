//
//  AllLucyNum.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AllLucyNum : UIView

@property (nonatomic,strong) UIImageView *titleImage; /*图标*/
@property (nonatomic,strong) UILabel *titleLabel; /*标题*/

@property (nonatomic,strong) UIView *lineView; /*灰线*/

@property (nonatomic,strong) UILabel *detailText; /*内容*/
- (instancetype)initWithFrame:(CGRect)frame TitleImage:(UIImage *)titleImage title:(NSString *)title lucyIconImage:(UIImage *)image nullImage:(UIImage *)nullImage iconAmount:(NSInteger)number detailDsc:(NSString *)detailDesc;
@end
