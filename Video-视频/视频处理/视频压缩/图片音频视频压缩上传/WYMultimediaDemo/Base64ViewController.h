//
//  Base64ViewController.h
//  WYMultimediaDemo
//
//  Created by Mac mini on 16/7/22.
//  Copyright © 2016年 DryoungDr. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface Base64ViewController : UIViewController

@property (strong, nonatomic) NSString *tempString;

@property (strong, nonatomic) NSString *filePathString;
@property (strong, nonatomic) NSData *fileData;

@end
