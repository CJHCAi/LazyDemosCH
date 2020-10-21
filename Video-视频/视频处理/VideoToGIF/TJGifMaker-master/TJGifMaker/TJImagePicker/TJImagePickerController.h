//
//  TJImagePickerController.h
//  TJGifMaker
//
//  Created by TanJian on 17/6/16.
//  Copyright © 2017年 Joshpell. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TJImagePickerController : UIViewController

@property (nonatomic, copy) void (^photoPickDoneBlock)(NSArray *);

@end
