//
//  ViewController.m
//  ASUserAgreementAndPrivacyPolicyView
//
//  Created by Mac on 2020/1/5.
//  Copyright © 2020 Mac. All rights reserved.
//

#import "ViewController.h"
#import "ASUserAgreementAndPrivacyPolicyView.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    
    [ASUserAgreementAndPrivacyPolicyView showUserAgreementAndPrivacyPolicyViewIsAgreeOperation:^(BOOL isAgree) {
        
        NSLog(@"isAgree:%d", isAgree);
        if (isAgree == NO) {
            
            exit(0);
        }
    }];
}


@end
