//
//  SDDecorateFunctionModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDDecorateFunctionModel.h"

@implementation SDDecorateFunctionModel

- (instancetype)initWithFunctionType:(SDDecorateFunctionType)type
{
    self = [super init];
    if (self) {
        _decorateType = type;
    }
    return self;
}


- (RACSubject *)done_subject
{
    if (!_done_subject) {
        _done_subject = [RACSubject subject];
    }
    return _done_subject;
}

@end
