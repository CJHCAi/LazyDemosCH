//
//  InputCherishView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class InputCherishView;

@protocol InputCherishViewDelegate  <NSObject>

-(void)inputCherishView:(InputCherishView *)inputCherishView withString:(NSString *)str;

@end

@interface InputCherishView : UIView
@property (nonatomic,strong) UITextView *textView; /*说的话*/
@property (nonatomic,strong) UIButton *commitBtn; /*提交*/
/** 代理人*/
@property (nonatomic, weak) id<InputCherishViewDelegate> delegate;
@end
