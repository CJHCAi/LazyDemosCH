//
//  UserModel.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/21.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "UserModel.h"

@implementation UserModel
- (void)setValue:(id)value forUndefinedKey:(NSString *)key {
}

+ (UserModel *)jsonToModel:(NSDictionary *)dic {
    UserModel *model = [[UserModel alloc]init];
    [model setValuesForKeysWithDictionary:dic];
    return model;
}
@end
