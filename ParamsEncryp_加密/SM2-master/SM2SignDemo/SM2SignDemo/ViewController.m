//
//  ViewController.m
//  SM2SignDemo
//
//  Created by Better on 2018/7/13.
//  Copyright © 2018年 Better. All rights reserved.
//

#import "ViewController.h"
#import "SM2SignMessage.h"
@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    //SM2椭圆曲线公钥密码算法 第2部分:数字签名算法
    //示例1:Fp -256提供的参数
    SM2SignMessage *sm2Sign = [[SM2SignMessage alloc] init];
    
    sm2Sign.skString = @"128B2FA8BD433C6C068C8D803DFF79792A519A55171B1B650C23661D15897263";

    sm2Sign.IDString = @"ALICE123@YAHOO.COM";
    
    sm2Sign.Message = @"message digest";
    
    sm2Sign.k = @"6CB28D99385C175C94F94E934817663FC176D925DD72B727260DBAAE1FB2F96F";
    //加签方法
    [sm2Sign sM2Sign];
    // 我这里是把加签后的R、S合并到一起了，前32位是R、后32位是S
    NSLog(@"加签成功:%@",sm2Sign.resultRS);
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
