//
//  SDBaseEditImageViewModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDBaseEditImageViewModel.h"

@implementation SDBaseEditImageViewModel

+ (SDBaseEditImageViewModel * )modelViewController:(UIViewController *)viewController
{

    SDBaseEditImageViewModel * viewModel = [[self alloc] initWithViewController:viewController];
    return viewModel;
}

- (instancetype)initWithViewController:(UIViewController *)viewController
{
    self = [super init];
    if (self) {
        _viewController = viewController;
        
    }
    return self;
}

@end
