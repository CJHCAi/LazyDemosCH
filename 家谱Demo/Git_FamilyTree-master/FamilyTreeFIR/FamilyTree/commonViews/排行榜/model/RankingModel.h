//
//  RankingModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/22.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Myzxr,Zcbr,Hybr,Rsbr,Lsmyzxr;
@interface RankingModel : NSObject

@property (nonatomic, strong) NSArray<Zcbr *> *zcbr;

@property (nonatomic, strong) Myzxr *myzxr;

@property (nonatomic, strong) NSArray<Hybr *> *hybr;

@property (nonatomic, strong) NSArray<Rsbr *> *rsbr;

@property (nonatomic, strong) NSArray<Lsmyzxr *> *lsmyzxr;

@end
@interface Myzxr : NSObject

@property (nonatomic, assign) NSInteger ds;

@property (nonatomic, copy) NSString *mz;

@property (nonatomic, assign) NSInteger ph;

@property (nonatomic, copy) NSString *jpm;

@property (nonatomic, copy) NSString *zb;

@property (nonatomic, copy) NSString *tx;

@end

@interface Zcbr : NSObject

@property (nonatomic, assign) NSInteger ph;

@property (nonatomic, copy) NSString *jpm;

@property (nonatomic, assign) NSInteger je;

@property (nonatomic, copy) NSString *tx;

@end

@interface Hybr : NSObject

@property (nonatomic, assign) NSInteger ph;

@property (nonatomic, copy) NSString *mz;

@property (nonatomic, copy) NSString *jpm;

@property (nonatomic, assign) NSInteger hyd;

@property (nonatomic, copy) NSString *tx;

@end

@interface Rsbr : NSObject

@property (nonatomic, assign) NSInteger ph;

@property (nonatomic, assign) NSInteger rs;

@property (nonatomic, copy) NSString *jpm;

@property (nonatomic, copy) NSString *tx;

@end

@interface Lsmyzxr : NSObject

@property (nonatomic, copy) NSString *xm;

@property (nonatomic, copy) NSString *yf;

@end

