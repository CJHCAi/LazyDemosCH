//
//  ChooseCommentView.h
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ChooseCommentViewDelegate <NSObject>

- (void)selcetComment:(UIButton*)sender;


@end

@interface ChooseCommentView : UIView
/**
 *  全部评价
 */
@property (strong,nonatomic) UIButton *AllcommentBtn;
/**
 *  好评
 */
@property (strong,nonatomic) UIButton *goodCommentBtn;
/**
 *  中评
 */
@property (strong,nonatomic) UIButton *middleCommentBtn;
/**
 *  差评
 */
@property (strong,nonatomic) UIButton *badCommentBtn;
/**
 *  有图
 */
@property (strong,nonatomic) UIButton *imgBtn;

@property (weak,nonatomic) id<ChooseCommentViewDelegate>delegate;

- (void)updateFrame;
@end
