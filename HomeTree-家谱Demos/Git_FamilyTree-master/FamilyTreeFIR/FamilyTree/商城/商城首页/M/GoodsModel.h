//
//  GoodsModel.h
//  ListV
//
//  Created by imac on 16/7/26.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <Foundation/Foundation.h>
@class GPage,GoodsDatalist;

@interface GoodsModel : NSObject
/**
 *  商品名
 */
@property (strong,nonatomic) NSString *goodName;
/**
 *  商品实付价格
 */
@property (strong,nonatomic) NSString *goodMoney;
/**
 *  商品报价
 */
@property (strong,nonatomic) NSString *goodQuote;
/**
 *  商品图片
 */
@property (strong,nonatomic) NSString *goodImage;


@property (nonatomic, strong) NSArray<GoodsDatalist *> *datalist;

@property (nonatomic, strong) GPage *page;


@end
@interface GPage : NSObject

@property (nonatomic, assign) NSInteger allpage;

@property (nonatomic, assign) NSInteger datanum;

@property (nonatomic, assign) NSInteger pagenum;

@property (nonatomic, assign) NSInteger pagesize;

@end

@interface GoodsDatalist : NSObject

@property (nonatomic, assign) NSInteger CoprId;

@property (nonatomic, assign) NSInteger CoprMoney;

@property (nonatomic, copy) NSString *CoConame;

@property (nonatomic, assign) NSInteger CoprActpri;

@property (nonatomic, copy) NSString *CoCover;

@property (nonatomic, copy) NSString *CoLabel;

@property (nonatomic, copy) NSString *CoConstype;

@property (nonatomic, assign) NSInteger CoId;

@end


