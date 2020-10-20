//
//  GoodEvaluateViewController.m
//  ListV
//
//  Created by imac on 16/7/29.
//  Copyright © 2016年 imac. All rights reserved.
//

#import "GoodEvaluateViewController.h"
#import "StarGetView.h"

@interface GoodEvaluateViewController ()<UITextViewDelegate>
/**
 *  评价
 */
@property (strong,nonatomic) UITextView *evaluateTV;
/**
 *  提示
 */
@property (strong,nonatomic) UILabel *promptLb;
/**
 *  评价视图
 */
@property (strong,nonatomic) StarGetView *starGetV;

@end

@implementation GoodEvaluateViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"评价";
    self.view .backgroundColor = LH_RGBCOLOR(230, 230, 230);
    [self initView];
}

- (void)initView{
    UIView *backV = [[UIView alloc]initWithFrame:CGRectMake(0, 64, __kWidth, 170)];
    [self.view addSubview:backV];
    backV.backgroundColor = [UIColor whiteColor];

    UILabel *evaluateLb = [[UILabel alloc]initWithFrame:CGRectMake(15, 20, 50, 15)];
    [backV addSubview:evaluateLb];
    evaluateLb.font =MFont(15);
    evaluateLb.textAlignment = NSTextAlignmentLeft;
    evaluateLb.text = @"评价:";

    _evaluateTV = [[UITextView alloc]initWithFrame:CGRectMake(CGRectXW(evaluateLb)+5, 15, __kWidth-30, 120)];
    [backV addSubview:_evaluateTV];
    _evaluateTV.backgroundColor = [UIColor clearColor];
    _evaluateTV.delegate = self;
    _evaluateTV.font = MFont(14);


    _promptLb = [[UILabel alloc]initWithFrame:CGRectMake(5, 5, 240, 40)];
    [_evaluateTV addSubview:_promptLb];
    _promptLb.font = MFont(14);
    _promptLb.textAlignment = NSTextAlignmentLeft;
    _promptLb.textColor = LH_RGBCOLOR(80, 80, 80);
    _promptLb.text = @"亲，产品如何？质量如何？价格合不合适？";
    _promptLb.numberOfLines = 0;

    _starGetV = [[StarGetView alloc]initWithFrame:CGRectMake(0, CGRectYH(_evaluateTV)+5, __kWidth, 55)];
    [backV addSubview:_starGetV];

    UIButton *finishBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, __kHeight-46-46, __kWidth, 46)];
    [self.view addSubview:finishBtn];
    finishBtn.backgroundColor = [UIColor redColor];
    [finishBtn setTitle:@"发表评价" forState:BtnNormal];
    [finishBtn setTitleColor:[UIColor whiteColor] forState:BtnNormal];
    [finishBtn addTarget:self action:@selector(evaluateAction) forControlEvents:BtnTouchUpInside];

}
#pragma mark ==提交评价==
- (void)evaluateAction{
    NSLog(@"%@",_starGetV.star);
    WK(weakSelf);
    [TCJPHTTPRequestManager POSTWithParameters:@{@"userid":GetUserId,
                                                @"did":_orderNumber,
                                                @"pf":_starGetV.star,
                                                 @"pl":self.evaluateTV.text} requestID:GetUserId requestcode:kRequestCodeevaluateadd success:^(id responseObject, BOOL succe, NSDictionary *jsonDic) {
                                                    if (succe) {
                                                        [SXLoadingView showAlertHUD:@"评价成功" duration:0.5];
                                                        [weakSelf.navigationController popViewControllerAnimated:YES];
                                                    }else{
                                                        [SXLoadingView showAlertHUD:@"评论失败" duration:0.5];
                                                    }
                                                } failure:^(NSError *error) {
                                                    
                                                }];
    
}


#pragma mark -UITextViewDelegate
-(void)textViewDidChange:(UITextView *)textView{
    if (IsNilString(textView.text)) {
        _promptLb.hidden =NO;
    }else{
        _promptLb.hidden = YES;
    }
}

-(void)textViewDidEndEditing:(UITextView *)textView{
    NSLog(@"%@",textView.text);
}
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
        return NO;
    }
    return YES;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.view endEditing:true];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
