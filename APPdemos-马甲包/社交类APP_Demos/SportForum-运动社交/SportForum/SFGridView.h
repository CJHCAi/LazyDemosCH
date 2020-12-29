//
//  SFGridView.h
//  SportForum
//
//  Created by zhengying on 6/9/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "RefreshTableView.h"

@class SFGridView;
@class SFGridViewCell;

@protocol SFGridViewDelegate <NSObject>
@required
- (NSInteger) numberOfCells:(SFGridView *)gridView;
- (SFGridViewCell *) gridView:(SFGridView *)gridView Row:(NSInteger)rowIndex Column:(NSInteger)columnIndex;

@optional
- (void) gridView:(SFGridView *)grid didSelectRow:(NSInteger)rowIndex Column:(NSInteger)columnIndex;
- (CGFloat) gridHeaderViewHeight:(SFGridView *)grid heightForHeaderInSection:(NSInteger)section;
- (UIView*) gridHeaderView:(SFGridView *)grid viewForHeaderInSection:(NSInteger)section;
@end

@interface SFGridView : RefreshTableView
@property(nonatomic, assign) NSInteger colCount;
@property(nonatomic, assign) NSInteger cellWidth;
@property(nonatomic, assign) NSInteger cellHeight;
@property(nonatomic, assign) NSInteger cellGapSpace;
@property(nonatomic, assign) NSInteger leftSpace;
@property(nonatomic, assign) NSInteger rightSpace;

-(void)reComputerCellSize;

-(void)setColumnCount:(int)nCount;
-(void)setDirection:(int)nDirection;

- (SFGridViewCell *) dequeueReusableCell;
@property(nonatomic, weak) id <SFGridViewDelegate> gridViewDelegate;
@end
