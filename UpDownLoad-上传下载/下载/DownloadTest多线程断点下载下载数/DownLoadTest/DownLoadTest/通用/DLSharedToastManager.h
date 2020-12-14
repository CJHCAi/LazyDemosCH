//
//  DLSharedToastManager.h
//  DownLoadTest
//
//  Created by 李五民 on 15/10/26.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface DLSharedToastManager : NSObject

+ (DLSharedToastManager *)sharedManager;
- (void)showToast:(NSString *)toast controller:(UIViewController *)controller;

@end
