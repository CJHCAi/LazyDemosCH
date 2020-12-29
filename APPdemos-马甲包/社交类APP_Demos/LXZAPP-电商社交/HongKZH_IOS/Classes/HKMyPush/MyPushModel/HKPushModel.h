//
//  HKPushModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "ZSDBBaseModel.h"

@interface HKPushModel : ZSDBBaseModel
@property (nonatomic, copy)NSString *sysUid;
@property (nonatomic, copy)NSString* headImg;
@property (nonatomic, copy)NSString* uname;
@property (nonatomic, copy)NSString* name;
@property (nonatomic, copy)NSString* coverImgSrc;
@property (nonatomic, copy)NSString* postId;
@property (nonatomic, assign)int type;
@property (nonatomic, copy)NSString* title;
@property (nonatomic, copy)NSString* createDate;
@property (nonatomic, copy)NSString* content;
@property (nonatomic, copy)NSString* uid;
@property (nonatomic, copy)NSString* circleId;
@end
