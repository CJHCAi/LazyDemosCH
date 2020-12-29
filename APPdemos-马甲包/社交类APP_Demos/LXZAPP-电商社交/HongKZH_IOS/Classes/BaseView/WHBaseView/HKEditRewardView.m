//
//  HKEditRewardView.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/26.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKEditRewardView.h"
#import "UIImage+YY.h"
@interface HKEditRewardView()
@property (weak, nonatomic) IBOutlet UIView *shadeView;
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIButton *confirm;

@end

@implementation HKEditRewardView
- (instancetype)init
{
    self = [super init];
    self = [[NSBundle mainBundle]loadNibNamed:@"HKEditRewardView" owner:self options:nil].firstObject;
    if (self) {
        UIImageView*imagev = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, 18, 18)];
        imagev.image = [UIImage imageNamed:@"514_goldc_"];
        self.textField.leftViewMode = UITextFieldViewModeAlways;
        UIView*view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 23, 18)];
        [view addSubview:imagev];
        self.textField.leftView = view;
        [self.textField addTarget:self action:@selector(passConTextChange:) forControlEvents:UIControlEventEditingChanged];
   self.backgroundColor = [UIColor colorWithRed:255.0/255.0 green:255.0/255.0 blue:255.0/255.0 alpha:0.8];
        UIImage*image = [UIImage createImageWithColor:[UIColor colorWithRed:196.0/255.0 green:89.0/255.0 blue:77.0/255.0 alpha:1] size:CGSizeMake(95, 36)];
        image = [image zsyy_imageByRoundCornerRadius:5];
        [self.confirm setBackgroundImage:image forState:0];
    }
    return self;
}
-(void)passConTextChange:(UITextField*)textField{
    if (textField.text.length>0) {
        self.shadeView.hidden = YES;
    }
}
- (IBAction)showLeft:(id)sender {
    if ([self.delegate respondsToSelector:@selector(gotoLeft)]) {
        [self.delegate gotoLeft];
    }
}

-(void)startEdit{
    [self.textField becomeFirstResponder];
}
- (IBAction)edit:(id)sender {
    [self startEdit];
}
- (IBAction)confirmClick:(id)sender {
    if (self.textField.text.length>0) {
        if ([self.delegate respondsToSelector:@selector(confirmWithNum:)]) {
            [self.delegate confirmWithNum:self.textField.text.integerValue];
        }
    }else{
        [SVProgressHUD showErrorWithStatus:@"请输入金额"];
    }
 
}
- (IBAction)closeClick:(id)sender {
    if ([self.delegate respondsToSelector:@selector(hideView)]) {
        [self.delegate hideView];
    }
}

@end
