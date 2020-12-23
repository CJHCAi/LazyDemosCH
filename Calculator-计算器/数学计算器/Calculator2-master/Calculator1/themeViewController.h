//
//  themeViewController.h
//  Calculator1
//
//  Created by ruru on 16/4/25.
//  Copyright © 2016年 ruru. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Common.h"
#define IOS8 ([[[UIDevice currentDevice] systemVersion] floatValue] >=8.0 ? YES : NO)

@interface themeViewController : UIViewController<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
- (IBAction)gotoBack:(id)sender;

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@end
