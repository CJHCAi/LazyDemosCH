//
//  ViewController.m
//  Internationalization
//
//  Created by Qiulong-CQ on 16/11/10.
//  Copyright © 2016年 xiaoheng. All rights reserved.
//

#import "ViewController.h"
#import "GDLocalizableController.h"
#import "TwoViewController.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}




- (IBAction)change:(id)sender {
    
    
    if ([[GDLocalizableController userLanguage] isEqualToString:@"en"]) {
        [GDLocalizableController setUserlanguage:CHINESE];
    }else{
        [GDLocalizableController setUserlanguage:ENGLISH];
    }
    
    self.label.text = GDLocalizedString(@"首页");
    self.changeBtn.newText =@"切换语言";
    self.jumpBtn.newText = GDLocalizedString(@"跳转");
//    self.img.newImage = GDLocalizedString(@"50.png");

}

- (IBAction)jump:(id)sender {
    
    TwoViewController *two = [[TwoViewController alloc] init];
    [self presentViewController:two animated:YES completion:nil];
    
}
@end
