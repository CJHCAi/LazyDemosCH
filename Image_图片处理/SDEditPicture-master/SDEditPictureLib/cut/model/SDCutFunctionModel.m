
//
//  SDCutFunctionModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDCutFunctionModel.h"

@implementation SDCutFunctionModel

- (instancetype)initWithFunctionModel:(SDCutFunctionType )model
{
    self = [super init];
    if (self) {
        _cutModel = model;
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
