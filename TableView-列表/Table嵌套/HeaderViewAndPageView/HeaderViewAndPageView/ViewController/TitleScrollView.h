//
//  TitleScrollView.h
//  CanPlay
//
//  Created by yangpan on 2016/12/15.
//  Copyright © 2016年 ZJW. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TitleScrollView;
@protocol  TitleScrollViewDelegate<NSObject>

-(void)TitleScrollView:(TitleScrollView *)scrollView buttonIndex:(NSInteger)index;
@end
@interface TitleScrollView : UIView<UIScrollViewDelegate>

@property(nonatomic,weak) id<TitleScrollViewDelegate>delegate;

-(void)setButtonIndex:(CGPoint)point;
@end
