//
//  ShoppingCartSectionHeaderView.h
//  ShoppingCartDemo
//
//  Created by dry on 2017/12/6.
//  Copyright © 2017年 MorrisMeng. All rights reserved.
//

#import <UIKit/UIKit.h>
@class ShopModel;
@class ShoppingCartSectionHeaderView;

@protocol ShoppingCartSectionHeaderViewDelegate <NSObject>

/**
 选中sectionHearder上的按钮时的代理事件

 @param headerView self
 @param isSelected 是否选中，YES：是；NO：取消选中/未选中
 @param section 当前的section
 */
- (void)hearderView:(ShoppingCartSectionHeaderView *)headerView isSelected:(BOOL)isSelected section:(NSInteger)section;

@end

@interface ShoppingCartSectionHeaderView : UITableViewHeaderFooterView

@property (nonatomic, weak) id <ShoppingCartSectionHeaderViewDelegate> delegate;
@property (nonatomic) NSInteger section;//SectionHeader对应的section的index

- (void)setInfo:(ShopModel *)shopModel;

@end
