//
//  SDInputTagContentView.h
//  NestHouse
//
//  Created by shansander on 2017/5/8.
//  Copyright © 2017年 黄建国. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^DOAction)(NSString * object);

@interface SDInputTagContentView : UIView

@property (nonatomic, weak) UITextField * inputTextField;

@property (nonatomic, weak) UIButton * cancel_button;

@property (nonatomic, weak) UIButton * ok_button;

@property (nonatomic, weak) UIView * inputText_bg_view;


@property (nonatomic, copy) DOAction doneBlock;

@end
