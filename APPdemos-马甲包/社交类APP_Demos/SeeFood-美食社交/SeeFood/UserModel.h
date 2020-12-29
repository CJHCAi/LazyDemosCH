//
//  UserModel.h
//  XMPP
//
//  Created by 纪洪波 on 15/11/21.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface UserModel : NSObject
@property (nullable, nonatomic, retain) NSString *username;
@property (nullable, nonatomic, retain) NSString *password;
@property (nullable, nonatomic, retain) NSString *email;
@property (nullable, nonatomic, retain) NSString *phone;
@property (nullable, nonatomic, retain) NSString *photoURL;
@property (nullable, nonatomic, retain) NSString *gender;
@property (nullable, nonatomic, retain) NSString *myIntroduction;
@property (nullable, nonatomic, retain) NSString *address;
@property (nullable, nonatomic, retain) NSString *nickname;
@property (nullable, nonatomic, retain) NSData *birthday;
//  解析到模型
+ (UserModel *)jsonToModel:(NSDictionary *)dic;
@end
