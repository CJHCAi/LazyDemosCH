//
//  APXProductModel.h
//  ZhongHeBao
//
//  Created by zhb on 17/7/11.
//  Copyright © 2017年 yangyang. All rights reserved.
//
#import <Foundation/Foundation.h>

@interface APXProductModel : NSObject

@property (nonatomic,copy) NSString *pic1url;
@property (nonatomic,copy) NSString *productDetailId;
@property (nonatomic,copy) NSString *productId;
@property (nonatomic,copy) NSString *colornum;
@property (nonatomic,strong) NSAttributedString *colornumAttr;
@property (nonatomic,assign) BOOL isShowColorNum;
@property (nonatomic,copy) NSString *productsubname;
@property (nonatomic,copy) NSString *title;
@property (nonatomic,copy) NSString *name;
@property (nonatomic,copy) NSString *price;
@property (nonatomic,copy) NSString *oldprice;
@property (nonatomic,copy) NSString *topRank;
@property (nonatomic,strong) NSAttributedString *oldpriceAttr;
@property (nonatomic,strong) NSArray *tags;
@property (nonatomic,copy) NSString *totalevalate;
@property (nonatomic,copy) NSString *goodrate;

@property (nonatomic,assign) BOOL isShowTopRank;

@end

