//
//  WpersonInfoModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WPersonGenlist;
@interface WpersonInfoModel : NSObject

@property (nonatomic, copy) NSString *hour;

@property (nonatomic, copy) NSString *ah;

@property (nonatomic, copy) NSString *scbz;

@property (nonatomic, copy) NSString *qm;

@property (nonatomic, copy) NSString *sex;

@property (nonatomic, strong) NSArray<WPersonGenlist *> *genlist;

@property (nonatomic, copy) NSString *day;

@property (nonatomic, strong) NSArray *pic;

@property (nonatomic, copy) NSString *year;

@property (nonatomic, copy) NSString *month;

@property (nonatomic, copy) NSString *xz;

@property (nonatomic, copy) NSString *xl;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *name;

@end
@interface WPersonGenlist : NSObject

@property (nonatomic, assign) NSInteger ds;

@property (nonatomic, copy) NSString *gename;

@property (nonatomic, assign) NSInteger geid;

@property (nonatomic, copy) NSString *zb;

@end

