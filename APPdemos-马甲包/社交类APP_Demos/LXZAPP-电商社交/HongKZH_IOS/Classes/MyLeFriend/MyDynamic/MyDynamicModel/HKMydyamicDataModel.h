//
//  HKMydyamicDataModel.h
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <Foundation/Foundation.h>
@interface HKMydyamicDataModel : NSObject
@property (nonatomic,assign) int type;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *headImg;
@property (nonatomic, copy)NSString *uid;
@property (nonatomic, copy)NSString *utype;
@property (nonatomic, copy)NSString *mediaId;
@property (nonatomic,assign) int  sex;
@property (nonatomic, copy)NSString *title;
@property (nonatomic, copy)NSString *createDate;
@property (nonatomic, copy)NSString *categoryName;
@property (nonatomic, copy)NSString *coverImgSrc;
@property (nonatomic,assign) int praiseCount;
@property (nonatomic,assign) int commentCount;
@end
