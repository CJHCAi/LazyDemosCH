//
//  WorshipModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WorshipPageModel,WorshipDatalistModel;
@interface WorshipModel : NSObject

@property (nonatomic, strong) NSArray<WorshipDatalistModel *> *datalist;

@property (nonatomic, strong) WorshipPageModel *page;

@end
@interface WorshipPageModel : NSObject

@property (nonatomic, assign) NSInteger allpage;

@property (nonatomic, assign) NSInteger datanum;

@property (nonatomic, assign) NSInteger pagenum;

@property (nonatomic, assign) NSInteger pagesize;

@end

@interface WorshipDatalistModel : NSObject

@property (nonatomic, copy) NSString *CeName;

@property (nonatomic, assign) NSInteger CeId;

@property (nonatomic, copy) NSString *Lp;

@property (nonatomic, copy) NSString *CeCover;

@property (nonatomic, copy) NSString *CePhoto;

@property (nonatomic, copy) NSString *Smr;

@property (nonatomic, assign) NSInteger CeReadcount;

@property (nonatomic, copy) NSString *Sj;

/** 是否可编辑*/
@property (nonatomic,assign)BOOL worshipDatalistModelEdit;
@end

