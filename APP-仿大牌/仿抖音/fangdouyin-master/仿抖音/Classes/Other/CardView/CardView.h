//
//  CardView.h
//  仿抖音
//
//  Created by ireliad on 2018/3/15.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CardView,CardModel,CardCell;

@protocol CardViewDataSource <NSObject>
-(NSInteger)numberOfSectionsInCardView:(CardView *)cardView;
- (CardModel *)cardView:(CardView *)cardView cellForRowAtIndexPath:(NSInteger)row;
@end

@protocol CardViewDelegate <NSObject>
//结束拖拽
-(void)cardView:(CardView*)cardView didEndscrollIndex:(NSInteger)index cell:(CardCell*)view;
//即将拖拽
-(void)cardView:(CardView*)cardView willBeginScrollIndex:(NSInteger)index cell:(CardCell*)view;
@end

@interface CardView : UIView
@property(nonatomic,weak)id<CardViewDataSource> dataSource;
@property(nonatomic,weak)id<CardViewDelegate> delegate;
-(void)reloadData;

-(instancetype)initWithCellCls:(Class)cellCls;
@end
