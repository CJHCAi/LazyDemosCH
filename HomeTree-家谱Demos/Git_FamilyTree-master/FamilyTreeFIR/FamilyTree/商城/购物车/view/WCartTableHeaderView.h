//
//  WCartTableHeaderView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WCartTableHeaderView;
@protocol WCartTableHeaderDelegate <NSObject>

-(void)WcartTableHeaderView:(WCartTableHeaderView *)headerView didSeletedButtion:(UIButton *)sender;

@end
@interface WCartTableHeaderView : UIView
/**全选按钮*/
@property (nonatomic,strong) UIButton *headSelectBtn;
/**编辑按钮*/
@property (nonatomic,strong) UIButton *editBtn;

@property (nonatomic,weak) id<WCartTableHeaderDelegate> delegate; /*代理人*/

@end
