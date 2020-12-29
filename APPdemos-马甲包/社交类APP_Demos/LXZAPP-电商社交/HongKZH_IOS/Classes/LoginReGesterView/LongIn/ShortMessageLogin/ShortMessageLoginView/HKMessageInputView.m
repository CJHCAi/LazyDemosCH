//
//  HKMessageInputView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/8/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMessageInputView.h"
#import "MQVerCodeInputView.h"
@interface HKMessageInputView()
@property (weak, nonatomic) IBOutlet UILabel *titleLabel;
@property (weak, nonatomic) IBOutlet MQVerCodeInputView *passwordTextField;

@end

@implementation HKMessageInputView

- (instancetype)init
{
    self = [super init];
    if (self) {
       self = [[NSBundle mainBundle]loadNibNamed:@"HKMessageInputView" owner:self options:nil].lastObject;
        //[self.passwordTextField initDefaultValue];
      //  self.passwordTextField.maxLenght = 6;//最大长度
        self.passwordTextField.keyBoardType = UIKeyboardTypeNumberPad;
        [self.passwordTextField mq_verCodeViewWithMaxLenght];
        self.passwordTextField.block = ^(NSString *text){
            DLog(@"text = %@",text);
        };
    }
    return self;
}

@end
