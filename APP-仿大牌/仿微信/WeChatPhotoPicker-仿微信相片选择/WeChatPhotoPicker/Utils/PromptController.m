//
//  PromptController.m
//  JiaPingMember
//
//  Created by Hailong Yu on 15/12/30.
//  Copyright © 2015年 zhongkeyun. All rights reserved.
//

#import "PromptController.h"
#import <AVFoundation/AVFoundation.h>

@implementation PromptController
+(PromptController *)shareManager{
    static PromptController* _manager;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _manager = [[PromptController alloc] init];
    });
    return _manager;
}


-(void)showJPGHUDWithMessage:(NSString*)message inView:(UIView*)view{
    self.HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    self.HUD.textLabel.text = [NSString stringWithFormat:@"%@", message];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.HUD showInView:view animated:YES];
    });
}

-(void)showSuccessJPGHUDWithMessage:(NSString*)message intView:(UIView*)view time:(NSInteger)time{

//    获取自定义bundle下的图片
    NSString* jgpBundelPath = [[NSBundle mainBundle] pathForResource:@"JGProgressHUD Resources" ofType:@"bundle"];
    NSString* imagePath = [[NSBundle bundleWithPath:jgpBundelPath] pathForResource:@"jg_hud_success" ofType:@"png"];
 
    JGProgressHUD* HUD = [JGProgressHUD progressHUDWithStyle:JGProgressHUDStyleDark];
    HUD.textLabel.text = [NSString stringWithFormat:@"%@", message];

    HUD.indicatorView = [[JGProgressHUDImageIndicatorView alloc] initWithImage:[UIImage imageWithContentsOfFile:imagePath]];

    dispatch_async(dispatch_get_main_queue(), ^{
        [HUD showInView:view animated:YES];
    });
    
    
    [HUD dismissAfterDelay:time animated:YES];
}

-(void)dismissJPGHUD{
    dispatch_async(dispatch_get_main_queue(), ^{//回主线程dismiss
        [self.HUD dismiss];
    });
}

-(void)showAlertWithMessage:(NSString *)message buttonTitle:(NSString *)buttonTitle block:(void (^)())block{
    message = [NSString stringWithFormat:@"%@", message];
    buttonTitle = [NSString stringWithFormat:@"%@", buttonTitle];
    
    UIAlertController* ac = [UIAlertController alertControllerWithTitle:@"" message:message preferredStyle:(UIAlertControllerStyleAlert)];
    UIAlertAction* action = [UIAlertAction actionWithTitle:buttonTitle style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
        if (block) {
            block();
        }
    }];
    
    [ac addAction:action];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:ac animated:YES completion:^{
            
        }];
    });

}


#pragma mark -
#pragma mark - praviteMentod
- (NSString *) getBlankString:(id)string{
    if (string == nil || string == NULL) {
        return @"";
    }
    if ([string isKindOfClass:[NSNull class]]) {
        return @"";
    }
    //    if ([[string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
    //        return @"";
    //    }
    return [NSString stringWithFormat:@"%@", string];
}


//检查摄像头
- (BOOL)cameraCanRecordShowAlert:(BOOL)showAlert
{
  
    NSString *mediaType = AVMediaTypeVideo;// Or AVMediaTypeAudio
    AVAuthorizationStatus authStatus = [AVCaptureDevice authorizationStatusForMediaType:mediaType];
//    NSLog(@"---cui--authStatus--------%d",authStatus);
    // This status is normally not visible—the AVCaptureDevice class methods for discovering devices do not return devices the user is restricted from accessing.
    if(authStatus ==AVAuthorizationStatusRestricted){
        NSLog(@"Restricted");
    }else if(authStatus == AVAuthorizationStatusDenied){ //用户关闭了权限
        // The user has explicitly denied permission for media capture.
        NSLog(@"Denied");
      
        if (showAlert) {
            UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在设备的\"设置-隐私-相机\"中允许访问相机。" preferredStyle:(UIAlertControllerStyleAlert)];
            UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
                
            }];
            
            [alert addAction:action];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
                    
                }];
            });
        }
        return NO;
    }
    else if(authStatus == AVAuthorizationStatusAuthorized){//允许访问
        // The user has explicitly granted permission for media capture, or explicit user permission is not necessary for the media type in question.
        NSLog(@"Authorized");
        return YES;
        
    }else if(authStatus == AVAuthorizationStatusNotDetermined){//第一次使用，则会弹出是否打开权限
        // Explicit user permission is required for media capture, but the user has not yet granted or denied such permission.
        [AVCaptureDevice requestAccessForMediaType:mediaType completionHandler:^(BOOL granted) {
            if(granted){//点击允许访问时调用
                //用户明确许可与否，媒体需要捕获，但用户尚未授予或拒绝许可。
                NSLog(@"Granted access to %@", mediaType);
            }
            else {
                NSLog(@"Not granted access to %@", mediaType);
            }
            
        }];
        
    }else {
        NSLog(@"Unknown authorization status");
    }

    
    return NO;

}

//检查麦克风
- (BOOL)microphoneCanRecordShowAlert:(BOOL)showAlert
{
    __block BOOL bCanRecord = YES;

    [[AVAudioSession sharedInstance] requestRecordPermission:^(BOOL granted) {
        bCanRecord = granted;

    }];
    
    
    if (!bCanRecord && showAlert) {
        UIAlertController* alert = [UIAlertController alertControllerWithTitle:@"提示" message:@"请在iPhone的 \"设置\"-\"隐私\"-\"麦克风\" 选项中，允许佳平医生访问您的手机麦克风。" preferredStyle:(UIAlertControllerStyleAlert)];
       UIAlertAction* action = [UIAlertAction actionWithTitle:@"确定" style:(UIAlertActionStyleDefault) handler:^(UIAlertAction * _Nonnull action) {
           
       }];
        
        [alert addAction:action];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            [[UIApplication sharedApplication].keyWindow.rootViewController presentViewController:alert animated:YES completion:^{
                
            }];
        });
       
    }
    
    return bCanRecord;
}



@end
