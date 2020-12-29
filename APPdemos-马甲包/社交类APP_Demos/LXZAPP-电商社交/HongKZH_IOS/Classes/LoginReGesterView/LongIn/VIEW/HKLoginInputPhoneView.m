//
//  HKLoginInputPhoneView.m
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/21.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKLoginInputPhoneView.h"
#import "HK_BaseRequest.h"
#import "HKLogInUserModel.h"

@interface HKLoginInputPhoneView ()
@property (weak, nonatomic) IBOutlet UITextField *IDTextField;

@property (weak, nonatomic) IBOutlet UITextField *passWord;


@property (weak, nonatomic) IBOutlet UIButton *forgetBtn;

@property (weak, nonatomic) IBOutlet UIButton *PhoneLoginBtn;



@end

@implementation HKLoginInputPhoneView

- (instancetype)init
{
    self = [super init];
    if (self) {
        self = [[NSBundle mainBundle]loadNibNamed:@"HKLoginInputPhoneView" owner:self options:nil].lastObject;
        [self.passWord addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
        self.PhoneLoginBtn.layer.cornerRadius = 5;
        self.PhoneLoginBtn.clipsToBounds =YES;
        self.PhoneLoginBtn.backgroundColor =[UIColor colorFromHexString:@"cccccc"];
        [self.PhoneLoginBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        self.IDTextField.borderStyle=UIKeyboardTypeNumberPad;
        [self.IDTextField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
        self.passWord.secureTextEntry =YES;
    }
    return self;
}
-(void)passConTextChange:(UITextField*)textField{
    if (self.passWord.text.length>0&&self.IDTextField.text.length>0) {
        [self.PhoneLoginBtn setBackgroundColor:[UIColor colorFromHexString:@"4a91df"]];
        self.PhoneLoginBtn.userInteractionEnabled = YES;
    }else{
        [self.PhoneLoginBtn setBackgroundColor:[UIColor colorFromHexString:@"cccccc"]];
        self.PhoneLoginBtn.userInteractionEnabled = NO;
    }
}

- (IBAction)shortMessageLogin:(UIButton *)sender {
     [self.passWord resignFirstResponder];
    if ([self.delegate respondsToSelector:@selector(shortMessage:)]) {
        [self.delegate shortMessage:self.IDTextField.text];
    }
}

- (IBAction)forgetBtnClick:(id)sender {
     [self.passWord resignFirstResponder];
    if (self.delegate && [self.delegate respondsToSelector:@selector(gotoForgetCode)]) {
        [self.delegate gotoForgetCode];
    }
}
- (IBAction)PhoneLogin:(id)sender {
    [self.passWord resignFirstResponder];
    
    NSDictionary *dict = @{@"mobile":self.IDTextField.text,@"registrationID":kUUID,@"password":self.passWord.text};
    
    if ([self.delegate respondsToSelector:@selector(phoneAndPassword:)]) {
        
        [self.delegate phoneAndPassword:dict];
        
    }
}

- (IBAction)logIn:(UIButton *)sender {

   
}

@end
