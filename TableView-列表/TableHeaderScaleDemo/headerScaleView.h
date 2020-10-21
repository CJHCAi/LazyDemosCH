//
//  headerScaleView.h
//  TableHeaderScaleDemo
//
//  Created by nieyongsheng on 2018/12/3.
//  Copyright © 2018年 nieyongsheng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface headerScaleView : UIView

@property (nonatomic, weak) UIScrollView *scrollView;

- (id)initWithFrame:(CGRect)frame title:(NSString *)title subTitle:(NSString *)subTitle;

-(void)updateSubViewsWithScrollOffset:(CGPoint)newOffset;



@end
