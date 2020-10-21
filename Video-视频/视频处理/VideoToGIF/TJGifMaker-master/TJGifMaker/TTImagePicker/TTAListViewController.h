//
//  TTAListViewController.h
//  videoStudy_1
//
//  Created by 李曈 on 2017/2/24.
//  Copyright © 2017年 lt. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^TTSelectedImg)(NSArray * images);

@interface TTAListViewController : UIViewController



-(void)completeChooseImage:(TTSelectedImg)block;

@end
