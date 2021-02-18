//
//  QueryModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/24.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class QueryKzxxModel,QueryMembModel,QueryAreaModel;
@interface QueryModel : NSObject

@property (nonatomic, strong) QueryKzxxModel *kzxx;

@property (nonatomic, strong) QueryMembModel *memb;

@property (nonatomic, strong) QueryAreaModel *area;

@end
@interface QueryKzxxModel : NSObject

@property (nonatomic, copy) NSString *Photo;

@property (nonatomic, copy) NSString *Grxl;

@property (nonatomic, copy) NSString *Grah;

@property (nonatomic, copy) NSString *Grqm;

@property (nonatomic, copy) NSString *Grjl;

@property (nonatomic, copy) NSString *Grzy;

@end

@interface QueryMembModel : NSObject

@property (nonatomic, copy) NSString *MeSurname;

@property (nonatomic, copy) NSString *MeAccount;

@property (nonatomic, assign) NSInteger MeLng;

@property (nonatomic, copy) NSString *MeState;

@property (nonatomic, copy) NSString *MeNickname;

@property (nonatomic, copy) NSString *MePassword;

@property (nonatomic, assign) NSInteger MeIntegral;

@property (nonatomic, copy) NSString *MeOperuser;

@property (nonatomic, copy) NSString *MeIsvip;

@property (nonatomic, copy) NSString *MeRegistertime;

@property (nonatomic, copy) NSString *MeCardnum;

@property (nonatomic, copy) NSString *MeExtension;

@property (nonatomic, copy) NSString *MeIsblack;

@property (nonatomic, copy) NSString *MeScbz;

@property (nonatomic, copy) NSString *MeKeepdate;

@property (nonatomic, copy) NSString *MeName;

@property (nonatomic, assign) NSInteger MeBalance;

@property (nonatomic, assign) NSInteger MeLat;

@property (nonatomic, assign) NSInteger MeId;

@property (nonatomic, copy) NSString *MeBirthday;

@property (nonatomic, assign) NSInteger MeKeepnum02;

@property (nonatomic, assign) NSInteger MeKeepnum01;

@property (nonatomic, copy) NSString *MeCertype;

@property (nonatomic, copy) NSString *MeMobile;

@property (nonatomic, assign) NSInteger MeViplevel;

@property (nonatomic, copy) NSString *MeSex;

@property (nonatomic, copy) NSString *MeEmail;

@property (nonatomic, assign) NSInteger MeIsgenealogy;

@property (nonatomic, assign) NSInteger MeAreacodeid;

@property (nonatomic, copy) NSString *MeKeepstr02;

@property (nonatomic, copy) NSString *MeKeepstr01;

@end

@interface QueryAreaModel : NSObject

@property (nonatomic, assign) NSInteger AreaId;

@property (nonatomic, copy) NSString *AreaCountry;

@property (nonatomic, copy) NSString *AreaMapcode;

@property (nonatomic, copy) NSString *AreaCountryCode;

@property (nonatomic, copy) NSString *AreaMap;

@property (nonatomic, copy) NSString *AreaProvince;

@property (nonatomic, copy) NSString *AreaCity;

@property (nonatomic, copy) NSString *AreaCode;

@property (nonatomic, copy) NSString *AreaMailcode;

@end

