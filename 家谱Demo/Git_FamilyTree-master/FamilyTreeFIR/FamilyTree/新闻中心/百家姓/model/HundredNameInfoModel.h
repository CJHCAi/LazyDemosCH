//
//  HundredNameInfoModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class HundredNameInfoDataModel;
@interface HundredNameInfoModel : NSObject

@property (nonatomic, strong) HundredNameInfoDataModel *data;

@property (nonatomic, strong) NSArray<NSString *> *yl;

@end
@interface HundredNameInfoDataModel : NSObject

@property (nonatomic, copy) NSString *FaClantribe;

@property (nonatomic, copy) NSString *FaSurname;

@property (nonatomic, copy) NSString *FaInter;

@property (nonatomic, copy) NSString *FaKeepstr01;

@property (nonatomic, copy) NSString *FaMigration;

@property (nonatomic, copy) NSString *FaKeepstr02;

@property (nonatomic, copy) NSString *FaKeepdate;

@property (nonatomic, assign) NSInteger FaKeepnum01;

@property (nonatomic, copy) NSString *FaUsername;

@property (nonatomic, assign) NSInteger FaKeepnum02;

@property (nonatomic, copy) NSString *FaCelebrity;

@property (nonatomic, assign) NSInteger FaId;

@property (nonatomic, copy) NSString *FaState;

@property (nonatomic, copy) NSString *FaBrief;

@property (nonatomic, copy) NSString *FaHall;

@property (nonatomic, copy) NSString *FaCountyhall;

@property (nonatomic, copy) NSString *FaExtension;

@property (nonatomic, copy) NSString *FaCreatetime;

@property (nonatomic, copy) NSString *FaLogo;

@property (nonatomic, copy) NSString *FaOther;

@end

