//
//  CHCommentView.h
//  仿抖音
//
//  Created by 七啸网络 on 2018/5/18.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import <UIKit/UIKit.h>
@protocol CHCommentViewDelegate<NSObject>
@optional
-(void)CommentViewTouchBegin:(NSSet<UITouch *> *)touches;
-(void)CommentViewTouchMove:(NSSet<UITouch *> *)touches;
-(void)CommentViewTouchEnd:(NSSet<UITouch *> *)touches;


@end
@interface CHCommentView : UIView
@property(nonatomic,weak)id<CHCommentViewDelegate> delegate;
@end
