//
//  Base64ViewController.m
//  WYMultimediaDemo
//
//  Created by Mac mini on 16/7/22.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import "Base64ViewController.h"
#import "WYBase64EncodeTools.h"

@interface Base64ViewController ()

@property (strong, nonatomic) UITextView *base64StringTextView;

@end

@implementation Base64ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    self.navigationItem.title = @"转码中...";
    
    [self.view addSubview:self.base64StringTextView];
    
    if (self.filePathString.length != 0) {// 转视频
        
        [WYBase64EncodeTools base64StringFromString:self.filePathString SuccessBlock:^(NSString *string) {
            
            self.base64StringTextView.text = string;
            self.navigationItem.title = [NSString stringWithFormat:@"压缩data的Base64码, %.2fM", string.length / 1024.0 / 1024.0];
        } FailedBlock:^{
            
            self.navigationItem.title = @"转码失败了!";
        }];
    }else {// 转图片
        
        [WYBase64EncodeTools base64StringFromData:self.fileData SuccessBlock:^(NSString *string) {
            
            self.base64StringTextView.text = string;
            self.navigationItem.title = [NSString stringWithFormat:@"压缩data的Base64码, %.2fK", string.length / 1024.0];
        } FailedBlock:^{
            
            self.navigationItem.title = @"转码失败了!";
        }];
    }
    
//    if (self.filePathString.length == 0) {
//        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            self.tempString = [WYBase64EncodeTools base64StringFromData:self.fileData];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                if (self.filePathString.length == 0) {
//                    
//                    self.base64StringTextView.text = self.tempString;
//                    self.navigationItem.title = [NSString stringWithFormat:@"压缩data的Base64码, %.2fK", self.base64StringTextView.text.length / 1024.0];
//                }else {
//                    
//                    self.base64StringTextView.text = self.tempString;
//                    self.navigationItem.title = [NSString stringWithFormat:@"压缩data的Base64码, %.2fM", self.base64StringTextView.text.length / 1024.0 / 1024.0];
//                }
//            });
//        });
//    }else {
//        
//        dispatch_async(dispatch_get_global_queue(0, 0), ^{
//            
//            self.tempString = [WYBase64EncodeTools base64StringFromString:self.filePathString];
//            
//            dispatch_async(dispatch_get_main_queue(), ^{
//                
//                if (self.filePathString.length == 0) {
//                    
//                    self.base64StringTextView.text = self.tempString;
//                    self.navigationItem.title = [NSString stringWithFormat:@"压缩data的Base64码, %.2fK", self.base64StringTextView.text.length / 1024.0];
//                }else {
//                    
//                    self.base64StringTextView.text = self.tempString;
//                    self.navigationItem.title = [NSString stringWithFormat:@"压缩data的Base64码, %.2fM", self.base64StringTextView.text.length / 1024.0 / 1024.0];
//                }
//            });
//        });
//    }
}

- (UITextView *)base64StringTextView {
    
    if (!_base64StringTextView) {
        
        _base64StringTextView = [[UITextView alloc] initWithFrame:self.view.bounds];
        _base64StringTextView.backgroundColor = [UIColor redColor];
        
        _base64StringTextView.textColor = [UIColor blackColor];
        
        _base64StringTextView.editable = NO;
    }
    
    return _base64StringTextView;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
