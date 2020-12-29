//
//  Tools.h
//  WallPaper
//
//  Created by Never on 2017/2/15.
//  Copyright © 2017年 Never. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <MBProgressHUD.h>

@interface Tools : NSObject<MBProgressHUDDelegate>
//默认方式
+ (MBProgressHUD *)MBProgressHUD:(NSString *)text;
//仅文字提示
+ (MBProgressHUD *)MBProgressHUDOnlyText:(NSString *)text;
//带进度view
+ (MBProgressHUD *)MBProgressHUDProgress:(NSString *)text;
//自定义视图
+ (MBProgressHUD *)MBProgressHUDCustomView:(NSString *)text;



@end
