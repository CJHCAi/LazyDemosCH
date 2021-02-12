//
//  CQTopBarView.h
//  CQTopBar
//
//  Created by CQ on 2018/1/9.
//  Copyright © 2018年 CQ. All rights reserved.
//

#import <UIKit/UIKit.h>
@class CQTopBarView;
@protocol CQTopBarViewDelegate <NSObject>
@optional
- (void)topBarWithBarView:(CQTopBarView *)topBar indexPath:(NSIndexPath *)indexPath;
@end
@interface CQTopBarView : UIView
@property (nonatomic, weak) id <CQTopBarViewDelegate>delegate;
@property (nonatomic, strong) UICollectionView * topBarCollectionView;
@property (nonatomic, copy) NSArray * pageView;
@property (nonatomic, strong) NSMutableArray  * viewArray;
- (instancetype)initWithFrame:(CGRect)frame pageViews:(NSArray *)pageViews;
@end
