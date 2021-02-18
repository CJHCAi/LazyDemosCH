//
//  WOrderSureModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/8/3.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WAddress,WPaymoney,WShopmoney,WKuaidi;
@interface WOrderSureModel : NSObject

@property (nonatomic, strong) NSArray<WShopmoney *> *shopmoney;

@property (nonatomic, strong) NSArray<WKuaidi *> *kd;

@property (nonatomic, strong) NSArray<WPaymoney *> *pay;

@property (nonatomic, strong) WAddress *address;

@end
@interface WAddress : NSObject

@property (nonatomic, copy) NSString *ReName;

@property (nonatomic, copy) NSString *ReCountry;

@property (nonatomic, copy) NSString *ReKeepstr01;

@property (nonatomic, copy) NSString *ReKeepstr02;

@property (nonatomic, copy) NSString *ReMap;

@property (nonatomic, copy) NSString *ReProvince;

@property (nonatomic, copy) NSString *ReIsdefault;

@property (nonatomic, assign) NSInteger ReKeepnum01;

@property (nonatomic, assign) NSInteger ReKeepnum02;

@property (nonatomic, copy) NSString *ReKeepdate;

@property (nonatomic, assign) NSInteger ReId;

@property (nonatomic, copy) NSString *ReMobile;

@property (nonatomic, copy) NSString *ReAddrdetail;

@property (nonatomic, copy) NSString *ReCity;

@property (nonatomic, assign) NSInteger ReMeid;

@property (nonatomic, assign) NSInteger ReAreaid;

@end

@interface WPaymoney : NSObject

@property (nonatomic, copy) NSString *AllKeepstr01;

@property (nonatomic, copy) NSString *AllKeepstr02;

@property (nonatomic, copy) NSString *AllClasstype;

@property (nonatomic, copy) NSString *AllClassname;

@property (nonatomic, copy) NSString *AllValue;

@property (nonatomic, copy) NSString *AllKeepdate;

@property (nonatomic, assign) NSInteger AllKeepnum01;

@property (nonatomic, assign) NSInteger AllId;

@property (nonatomic, assign) NSInteger AllKeepnum02;

@property (nonatomic, copy) NSString *AllName;

@end

@interface WShopmoney : NSObject

@property (nonatomic, assign) NSInteger money;

@property (nonatomic, assign) NSInteger prepri;

@property (nonatomic, assign) NSInteger coid;

@end

@interface WKuaidi : NSObject

@property (nonatomic, copy) NSString *AllKeepstr01;

@property (nonatomic, copy) NSString *AllKeepstr02;

@property (nonatomic, copy) NSString *AllClasstype;

@property (nonatomic, copy) NSString *AllClassname;

@property (nonatomic, copy) NSString *AllValue;

@property (nonatomic, copy) NSString *AllKeepdate;

@property (nonatomic, assign) NSInteger AllKeepnum01;

@property (nonatomic, assign) NSInteger AllId;

@property (nonatomic, assign) NSInteger AllKeepnum02;

@property (nonatomic, copy) NSString *AllName;

@end

