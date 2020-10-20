//
//  TopSearchView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/5/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#define SearchToTop 30
#define SearchView_Height 25
#define SearchImage_Size 15

#define MenusBtn_size 22

@class TopSearchView;

@protocol TopSearchViewDelegate <NSObject>
@optional
-(void)TopSearchViewDidTapView:(TopSearchView *)topSearchView;
-(void)TopSearchView:(TopSearchView *)topSearchView didRespondsToMenusBtn:(UIButton *)sender;
@end

@interface TopSearchView : UIView

@property (nonatomic,strong) UIImageView *backView; /*黑色背景*/
@property (nonatomic,strong) UIView *searchView; /*搜索框*/
@property (nonatomic,strong) UITextField *searchLabel; /*输入关键词*/
@property (nonatomic,strong) UIImageView *searchImage; /*搜索图片*/
/** 我的互助*/
@property (nonatomic,strong) UIButton *menuBtn;

@property (nonatomic,weak) id<TopSearchViewDelegate> delegate; /*代理人*/

@end
