//
//  APXPopHeaderView.h
//  ZhongHeBao
//
//  Created by 云无心 on 2017/2/20.
//  Copyright © 2017年 zhbservice. All rights reserved.
//

#import <UIKit/UIKit.h>

@class APXPopHeaderView;
@protocol APXPopHeaderViewDelegate <NSObject>

- (void)popHeaderViewDidClickDissMissButtton:(APXPopHeaderView *)popHeaderView;

@end

@interface APXPopHeaderView : UIView

@property (nonatomic, copy) NSString *titleString;
@property (assign, nonatomic) id delegate;

@end
