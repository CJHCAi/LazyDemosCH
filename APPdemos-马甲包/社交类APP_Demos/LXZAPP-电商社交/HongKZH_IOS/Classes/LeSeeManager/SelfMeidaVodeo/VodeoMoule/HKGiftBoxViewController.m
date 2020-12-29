//
//  HKGiftBoxViewController.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/11/1.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKGiftBoxViewController.h"

@interface HKGiftBoxViewController ()
@property (weak, nonatomic) IBOutlet UILabel *num;

@end

@implementation HKGiftBoxViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
}
-(void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self dismissViewControllerAnimated:YES completion:nil];
}
+(void)showGiftBoxwithSuperVc:(HKBaseViewController*)superVc money:(NSInteger)money{
    HKGiftBoxViewController*vc = [[HKGiftBoxViewController alloc]init];
    [HKBaseViewController showPreWithsuperVc:superVc subVc:vc color:[UIColor colorWithRed:255.0/255.0 green:0.0/255.0 blue:0.0/255.0 alpha:0.204]];
}
-(void)setMonery:(NSInteger)monery{
    _monery = monery;
    self.num.text = [NSString stringWithFormat:@"x %ld",monery];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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
