//
//  FamilyTreeTopView.h
//  FamilyTree
//
//  Created by 姚珉 on 16/5/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class FamilyTreeTopView;

@protocol FamilyTreeTopViewDelegate <NSObject>

-(void)TopSearchViewDidTapView:(FamilyTreeTopView *)topSearchView;
-(void)TopSearchView:(FamilyTreeTopView *)topSearchView didRespondsToMenusBtn:(UIButton *)sender;
@end

@interface FamilyTreeTopView : UIView
@property (nonatomic,strong) UIButton *menuBtn;
@property (nonatomic,strong) UITextField *searchLabel; /*输入关键词*/
@property (nonatomic,weak) id<FamilyTreeTopViewDelegate> delegate; /*代理人*/

@end
