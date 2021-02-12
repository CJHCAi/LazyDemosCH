//
//  MYZWebRootViewController.m
//  MYZWebHybrid
//
//  Created by MA806P on 2019/2/23.
//  Copyright © 2019 myz. All rights reserved.
//

#import "MYZWebRootViewController.h"
#import <WebKit/WebKit.h>
#import <Photos/Photos.h>
#import <AVFoundation/AVFoundation.h>
#import "MYZTools.h"
#import "MYZWebChildViewController.h"

@interface MYZWebRootViewController ()<WKScriptMessageHandler,UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, copy) NSString *callBackName;

@end

@implementation MYZWebRootViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    WKUserContentController *userCC = self.webView.configuration.userContentController;
    [userCC addScriptMessageHandler:self name:@"call"];
    
    if ([MYZTools is_stringEmpty:self.urlString] == NO && [self.urlString hasPrefix:@"http"]) {
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:self.urlString]]];
    } else if ([MYZTools is_stringEmpty:self.urlString] == NO){
        NSString *path = [[NSBundle mainBundle] pathForResource:self.urlString ofType:@"html"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    } else {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"index" ofType:@"html"];
        [self.webView loadRequest:[NSURLRequest requestWithURL:[NSURL fileURLWithPath:path]]];
    }
    
}




#pragma mark - WKScriptMessageHandler

- (void)userContentController:(WKUserContentController *)userContentController didReceiveScriptMessage:(WKScriptMessage *)message {
    NSLog(@"%@",message.body);
    
    if ([message.name isEqualToString:@"call"]) {
        NSString *messageJson = [NSString stringWithFormat:@"%@", message.body];
        
        if ([MYZTools is_stringEmpty:messageJson] == NO) {
            NSData *data = [messageJson dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary *json = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
            
            if (json && [json isKindOfClass:[NSDictionary class]]) {
                [self p_webViewSendMessageWithDictionary:json];
            }
            
        }
        
    }
}

-(void)removeAllScriptMsgHandle{
    WKUserContentController *controller = self.webView.configuration.userContentController;
    [controller removeScriptMessageHandlerForName:@"call"];
}


#pragma mark - 网页消息处理

- (void)p_webViewSendMessageWithDictionary:(NSDictionary *)jsonDict {
    
    if (jsonDict == nil || [MYZTools is_dcitionary:jsonDict] == NO) { return; }
    
    NSString *name = jsonDict[@"name"];
    if ([MYZTools is_stringEmpty:name]) { return; }
    
    NSString *callBack = nil;
    if ([MYZTools is_stringEmpty:jsonDict[@"callback"]] == NO) {
        callBack = jsonDict[@"callback"];
    }
    
    if ([name isEqualToString:@"WebViewOpen"]) {
        //打开新的网页
        NSDictionary *paramDict = jsonDict[@"params"];
        if (paramDict && [MYZTools is_dcitionary:paramDict]) {
            NSString *webName = paramDict[@"name"];
            NSString *urlStr = paramDict[@"url"];
            
            MYZWebChildViewController *webViewController = [[MYZWebChildViewController alloc] init];
            webViewController.urlString = urlStr;
            webViewController.name = webName;
            [self.navigationController pushViewController:webViewController animated:YES];
        }
        
    } else if ([name isEqualToString:@"WebViewClose"]) {
        
        //关闭已经打开的网页 name 标记的
        NSDictionary *paramDict = jsonDict[@"params"];
        if (paramDict && [MYZTools is_dcitionary:paramDict]) {
            NSString *webName = paramDict[@"name"];
            if ([MYZTools is_stringEmpty:webName] == NO) {
                MYZWebChildViewController *tempWebViewController = nil;
                NSArray *navChildViewControllers = self.navigationController.childViewControllers;
                for (MYZWebChildViewController *webViewController in navChildViewControllers) {
                    if ([webViewController.name isEqualToString:webName]) {
                        NSInteger thisIndex = [self.navigationController.childViewControllers indexOfObject:webViewController];
                        thisIndex -= 1;
                        if (thisIndex < 0) {
                            thisIndex = 0;
                        }
                        tempWebViewController = navChildViewControllers[thisIndex];
                        break;
                    }
                }
                [self.navigationController popToViewController:tempWebViewController animated:YES];
            }
        }
        
    } else if ([name isEqualToString:@"CameraOpen"]) {
        
        self.callBackName = callBack;
        [self p_getImageFromCamera];
        
    } else if ([name isEqualToString:@"AlbumOpen"]) {
        
        self.callBackName = callBack;
        [self p_getImageFromAlbum];
        
    } else if ([name isEqualToString:@"ToastShow"]) {
        
        NSString *param = jsonDict[@"params"];
        if ([MYZTools is_stringEmpty:param] == NO) {
            [MYZTools showMessage:param];
            
            if ([MYZTools is_stringEmpty:callBack] == NO) {
                NSString *callBackString = [NSString stringWithFormat:@"%@('success')", callBack];
                [self.webView evaluateJavaScript:callBackString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                    NSLog(@"-- %@  %@", obj, error);
                }];
            }
        }
    } else if ([name isEqualToString:@"DataSave"]) {
        
        NSDictionary *paramDict = jsonDict[@"params"];
        if (paramDict && [MYZTools is_dcitionary:paramDict]) {
            NSString *name = paramDict[@"name"];
            NSString *value = paramDict[@"value"];
            if ([MYZTools is_stringEmpty:name] == NO && value != nil) {
                [[NSUserDefaults standardUserDefaults] setObject:value forKey:name];
                [[NSUserDefaults standardUserDefaults] synchronize];
                [MYZTools showMessage:@"数据保存成功"];
                
                if ([MYZTools is_stringEmpty:callBack] == NO) {
                    NSString *callBackString = [NSString stringWithFormat:@"%@('success')", callBack];
                    [self.webView evaluateJavaScript:callBackString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                        NSLog(@"-- %@  %@", obj, error);
                    }];
                }
            }
        }
        
    } else if ([name isEqualToString:@"DataGet"]) {
        
        NSDictionary *paramDict = jsonDict[@"params"];
        if (paramDict && [MYZTools is_dcitionary:paramDict]) {
            NSString *name = paramDict[@"name"];
            if ([MYZTools is_stringEmpty:name] == NO) {
                id value = [[NSUserDefaults standardUserDefaults] objectForKey:name];
                [MYZTools showMessage:[NSString stringWithFormat:@"%@", value]];
                
                if ([MYZTools is_stringEmpty:callBack] == NO) {
                    NSString *callBackString = [NSString stringWithFormat:@"%@('success: value = %@')", callBack, value];
                    [self.webView evaluateJavaScript:callBackString completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
                        NSLog(@"-- %@  %@", obj, error);
                    }];
                }
            }
        }
        
    } else if ([name isEqualToString:@"CallPhone"]) {
        
        NSString *phoneNumber = jsonDict[@"params"];
        if ([MYZTools is_stringEmpty:phoneNumber] == NO) {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@", phoneNumber]]];
        }
    }
    
    
}


#pragma mark - 获取系统相机相册图片


//打开照相机拍照
- (void)p_getImageFromCamera {
    
    NSDictionary * mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * appName = [mainInfoDictionary objectForKey:@"CFBundleName"];
    
    //相机功能
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        [MYZTools showAlertWithTitle:@"提示" message:@"该设备不支持相机功能"];
        return;
    }
    
    //是否授权使用相机
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:AVMediaTypeVideo];
    if (authStatus == AVAuthorizationStatusDenied) {
        NSString * title = [NSString stringWithFormat:@"%@没有权限访问相机", appName];
        NSString * message = [NSString stringWithFormat:@"请进入系统 设置>隐私>相机 允许\"%@\"访问您的相机",appName];
        [MYZTools showAlertWithTitle:title message:message];
        return;
    }
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.sourceType = UIImagePickerControllerSourceTypeCamera;
    pickerImage.delegate = self;
    [self presentViewController:pickerImage animated:YES completion:nil];
    
}



- (void)p_getImageFromAlbum {
    
    //应用名称, 提示信息里会用到
    NSDictionary * mainInfoDictionary = [[NSBundle mainBundle] infoDictionary];
    NSString * appName = [mainInfoDictionary objectForKey:@"CFBundleName"];
    
    
    //是否支持相册功能
    if(![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypePhotoLibrary]) {
        [MYZTools showMessage:@"该设备不支持相册功能"];
        return;
    }
    
    //是否授权访问照片
    PHAuthorizationStatus authStatus = [PHPhotoLibrary authorizationStatus];
    if (authStatus == PHAuthorizationStatusDenied) {
        NSString * title = [NSString stringWithFormat:@"%@没有权限访问照片", appName];
        NSString * message = [NSString stringWithFormat:@"请进入系统 设置>隐私>照片 允许\"%@\"访问您的照片",appName];
        [MYZTools showAlertWithTitle:title message:message];
        return;
    }
    
    UIImagePickerController *pickerImage = [[UIImagePickerController alloc] init];
    pickerImage.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerImage.delegate = self;
    pickerImage.allowsEditing = YES;
    [self presentViewController:pickerImage animated:YES completion:nil];
}




- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage * originImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    if (originImage == nil || [originImage isKindOfClass:[UIImage class]] == NO) {
        return;
    }
    
    if ([MYZTools is_stringEmpty:self.callBackName] == NO) {
        NSData * imageData = UIImageJPEGRepresentation(originImage, 0.2);
        NSString *imgBase64 = [imageData base64EncodedStringWithOptions:0];//[imageData base64Encoding];
        NSString *callBack = [NSString stringWithFormat:@"%@('%@')", self.callBackName, imgBase64];
        __weak __typeof(self) weakSelf = self;
        [self.webView evaluateJavaScript:callBack completionHandler:^(id _Nullable obj, NSError * _Nullable error) {
            NSLog(@"-- %@  %@", obj, error);
            weakSelf.callBackName = nil;
        }];
    }
    
}


@end

