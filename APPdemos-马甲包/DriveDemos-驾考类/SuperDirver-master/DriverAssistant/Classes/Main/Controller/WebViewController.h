//
//  WebViewController.h
//  DriverAssistant
//
//  Created by C on 16/3/31.
//  Copyright © 2016年 C. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebViewController : UIViewController
- (instancetype)initWithURL:(NSString *)url;
@property (nonatomic, copy) NSString *myTitle;

@end
