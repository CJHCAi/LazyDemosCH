//
//  ContactModel.h
//  FriendList
//
//  Created by 甘萌 on 17/4/20.
//  Copyright © 2017年 com.esdlumen. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ContactModel : NSObject

@property (nonatomic,strong) NSString *portrait;
@property (nonatomic,strong) NSString *name;
@property (nonatomic,strong) NSString *pinyin;//拼音
@property (nonatomic,strong) NSString *isSelected;//拼音
@end
