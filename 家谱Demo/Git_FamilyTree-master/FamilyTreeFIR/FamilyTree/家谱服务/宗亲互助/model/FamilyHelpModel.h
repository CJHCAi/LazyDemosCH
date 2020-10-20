//
//  FamilyHelpModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/8/16.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class FamilyHelpPageModel,FamilyHelpDatalistModel;
@interface FamilyHelpModel : NSObject

@property (nonatomic, strong) NSArray<FamilyHelpDatalistModel *> *datalist;

@property (nonatomic, strong) FamilyHelpPageModel *page;


@end
@interface FamilyHelpPageModel : NSObject

@property (nonatomic, assign) NSInteger allpage;

@property (nonatomic, assign) NSInteger datanum;

@property (nonatomic, assign) NSInteger pagenum;

@property (nonatomic, assign) NSInteger pagesize;

@end

@interface FamilyHelpDatalistModel : NSObject

@property (nonatomic, assign) NSInteger ZqId;

@property (nonatomic, assign) NSInteger ZqIntencnt;

@property (nonatomic, copy) NSString *ZqCover;

@property (nonatomic, copy) NSString *ZqTitle;

@property (nonatomic, assign) NSInteger ZqFollowcnt;

@property (nonatomic, assign) NSInteger Syts;

@end

