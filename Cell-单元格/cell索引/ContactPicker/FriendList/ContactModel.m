//
//  ContactModel.m
//  FriendList
//
//  Created by 甘萌 on 17/4/20.
//  Copyright © 2017年 com.esdlumen. All rights reserved.
//

#import "ContactModel.h"
#import "NSString+Utils.h"//category

@implementation ContactModel
- (void)setName:(NSString *)name{
    if (name) {
        _name=name;
        _pinyin=_name.pinyin;
    }
}
@end
