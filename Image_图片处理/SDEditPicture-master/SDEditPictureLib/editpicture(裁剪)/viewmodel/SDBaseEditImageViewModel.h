//
//  SDBaseEditImageViewModel.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SDBaseEditImageViewModel : NSObject

@property (nonatomic, strong) UIViewController * viewController;

+ (SDBaseEditImageViewModel * )modelViewController:(UIViewController *)viewController;

- (instancetype)initWithViewController:(UIViewController *)viewController;

@end
