//
//  WGoodsDetailModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/8/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class DetailData,DetailPic,DetailPro;
@interface WGoodsDetailModel : NSObject

@property (nonatomic, strong) NSArray<DetailPic *> *pic;

@property (nonatomic, strong) DetailData *data;

@property (nonatomic, strong) NSArray<DetailPro *> *pro;

@end
@interface DetailData : NSObject

@property (nonatomic, copy) NSString *CoShoptype;

@property (nonatomic, assign) NSInteger CoSalescnt;

@property (nonatomic, assign) NSInteger CoIntegral;

@property (nonatomic, assign) NSInteger CoReadcount;

@property (nonatomic, copy) NSString *CoKeepstr01;

@property (nonatomic, copy) NSString *CoKeepstr02;

@property (nonatomic, copy) NSString *CoState;

@property (nonatomic, copy) NSString *CoKeepdate;

@property (nonatomic, copy) NSString *CoConame;

@property (nonatomic, copy) NSString *CoBrief;

@property (nonatomic, assign) NSInteger CoAllid;

@property (nonatomic, assign) NSInteger CoId;

@property (nonatomic, copy) NSString *CoConstype;

@property (nonatomic, assign) NSInteger CoGroval;

@property (nonatomic, copy) NSString *CoExtension;

@property (nonatomic, copy) NSString *CoCover;

@property (nonatomic, assign) NSInteger CoIstop;

@property (nonatomic, copy) NSString *CoUpdatetime;

@property (nonatomic, copy) NSString *CoUsername;

@property (nonatomic, copy) NSString *CoCreatetime;

@property (nonatomic, copy) NSString *CoLabel;

@property (nonatomic, assign) NSInteger CoKeepnum01;

@property (nonatomic, assign) NSInteger CoQcd;

@property (nonatomic, assign) NSInteger CoKeepnum02;

@end

@interface DetailPic : NSObject

@property (nonatomic, copy) NSString *PicKeepstr01;

@property (nonatomic, copy) NSString *PicType;

@property (nonatomic, assign) NSInteger PicCoid;

@property (nonatomic, copy) NSString *PicAddtime;

@property (nonatomic, copy) NSString *PicKeepstr02;

@property (nonatomic, copy) NSString *PicKeepdate;

@property (nonatomic, copy) NSString *PicFilepath;

@property (nonatomic, assign) NSInteger PicKeepnum01;

@property (nonatomic, assign) NSInteger PicId;

@property (nonatomic, assign) NSInteger PicKeepnum02;

@end

@interface DetailPro : NSObject

@property (nonatomic, copy) NSString *CoprKeepstr01;

@property (nonatomic, assign) NSInteger CoprActPri;

@property (nonatomic, copy) NSString *CoprKeepstr02;

@property (nonatomic, assign) NSInteger CoprKeepnum01;

@property (nonatomic, assign) NSInteger CoprCoid;

@property (nonatomic, assign) NSInteger CoprCount;

@property (nonatomic, assign) NSInteger CoprKeepnum02;

@property (nonatomic, assign) NSInteger CoprId;

@property (nonatomic, copy) NSString *CoprUsername;

@property (nonatomic, copy) NSString *CoprData;

@property (nonatomic, assign) NSInteger CoprPrePri;

@property (nonatomic, copy) NSString *CoprUnit;

@property (nonatomic, copy) NSString *CoprName;

@property (nonatomic, copy) NSString *CoprCreatetime;

@property (nonatomic, copy) NSString *CoprKeepdate;

@property (nonatomic, assign) NSInteger CoprMoney;

@end

