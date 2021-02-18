//
//  TotalCommentView.h
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"

@protocol TotalCommentViewDelegate <NSObject>

- (void)selectCommentType:(UIButton *)sender;

@end

@interface TotalCommentView : UIView
/**
 *  好评百分比显示
 */
@property (strong,nonatomic) UILabel *commentNumberLb;

@property (strong,nonatomic) StarView *starV;

@property (weak,nonatomic) id<TotalCommentViewDelegate>delegate;



@end
