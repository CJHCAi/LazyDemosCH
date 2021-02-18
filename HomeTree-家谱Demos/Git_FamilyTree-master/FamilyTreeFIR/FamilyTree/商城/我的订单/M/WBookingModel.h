//
//  WBookingModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/8/4.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WbPage,WbDatalist,WbOrder,WbDetail;
@interface WBookingModel : NSObject


@property (nonatomic, strong) NSArray<WbDatalist *> *datalist;

@property (nonatomic, strong) WbPage *page;

@end



@interface WbPage : NSObject

@property (nonatomic, assign) NSInteger allpage;

@property (nonatomic, assign) NSInteger datanum;

@property (nonatomic, assign) NSInteger pagenum;

@property (nonatomic, assign) NSInteger pagesize;

@end

@interface WbDatalist : NSObject

@property (nonatomic, strong) WbOrder *order;

@property (nonatomic, strong) NSArray<WbDetail *> *detail;

@end

@interface WbOrder : NSObject

@property (nonatomic, assign) NSInteger ShorTableid;

@property (nonatomic, copy) NSString *ShorState;

@property (nonatomic, copy) NSString *ShorAddress;

@property (nonatomic, copy) NSString *ShorDeliverytime;

@property (nonatomic, assign) NSInteger ShorFreight;

@property (nonatomic, copy) NSString *ShorPaystate;

@property (nonatomic, copy) NSString *ShorPaynumber;

@property (nonatomic, copy) NSString *ShorOvertime;

@property (nonatomic, copy) NSString *ShorKeepstr01;

@property (nonatomic, copy) NSString *ShorKeepstr02;

@property (nonatomic, copy) NSString *ShorPaytype;

@property (nonatomic, copy) NSString *ShorPaytime;

@property (nonatomic, copy) NSString *ShorInvoice;

@property (nonatomic, copy) NSString *ShorMemo;

@property (nonatomic, assign) NSInteger ShorKeepnum02;

@property (nonatomic, assign) NSInteger ShorMoney;

@property (nonatomic, copy) NSString *ShorType;

@property (nonatomic, assign) NSInteger ShorAllid;

@property (nonatomic, copy) NSString *ShorOrdnum;

@property (nonatomic, copy) NSString *ShorKeepdate;

@property (nonatomic, assign) NSInteger ShorMeid;

@property (nonatomic, assign) NSInteger ShorId;

@property (nonatomic, copy) NSString *ShorExpnumber;

@property (nonatomic, assign) NSInteger ShorKeepnum01;

@property (nonatomic, copy) NSString *ShorCreatetime;

@property (nonatomic, copy) NSString *ShorIsdel;

@end

@interface WbDetail : NSObject

@property (nonatomic, assign) NSInteger OrdeActpri;

@property (nonatomic, assign) NSInteger OrdeKeepnum02;

@property (nonatomic, assign) NSInteger OrdeCoprid;

@property (nonatomic, assign) NSInteger OrdeMoney;

@property (nonatomic, copy) NSString *OrdeKeepdate;

@property (nonatomic, copy) NSString *OrdeKeepstr01;

@property (nonatomic, assign) NSInteger OrdePrepri;

@property (nonatomic, assign) NSInteger OrdeShorid;

@property (nonatomic, assign) NSInteger OrdeId;

@property (nonatomic, assign) NSInteger OrdeCoid;

@property (nonatomic, copy) NSString *OrdeConame;

@property (nonatomic, copy) NSString *OrdeCocover;

@property (nonatomic, assign) NSInteger OrdeCount;

@property (nonatomic, copy) NSString *OrdeCoprname;

@property (nonatomic, copy) NSString *OrdeKeepstr02;

@property (nonatomic, assign) NSInteger OrdeKeepnum01;

@end

