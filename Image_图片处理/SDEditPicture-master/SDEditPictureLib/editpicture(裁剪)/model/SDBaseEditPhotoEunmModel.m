//
//  SDBaseEditPhotoEunmModel.m
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import "SDBaseEditPhotoEunmModel.h"

@implementation SDBaseEditPhotoEunmModel



- (RACSubject *)done_subject
{
    if (!_done_subject) {
        _done_subject = [RACSubject subject];
    }
    return _done_subject;
}


@end
