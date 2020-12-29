//
//  HK_UserInfoModel.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/5/29.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "BaseModel.h"

@interface HK_UserInfoModel : BaseModel
@property(nonatomic , copy)NSString* userName;
@property(nonatomic , copy)NSString* userurl;
@property(nonatomic , copy)NSString* nickname;
@property(nonatomic , copy)NSString* useruid;
@property(nonatomic , copy)NSString* userreturn_money;
@property(nonatomic , copy)NSString* userprovince;
@property(nonatomic , copy)NSString* userdescription;
@property(nonatomic , copy)NSString* passWord;
@property(nonatomic , assign)int islogin;
@end
