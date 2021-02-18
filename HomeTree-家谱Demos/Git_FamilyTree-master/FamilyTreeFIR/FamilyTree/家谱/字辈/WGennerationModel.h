//
//  WGennerationModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/29.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class Page,WGeDatalist,WGeDetailDatas;
@interface WGennerationModel : NSObject



@property (nonatomic, strong) NSArray<WGeDatalist *> *datalist;

@property (nonatomic, strong) Page *page;


@end

@interface Page : NSObject

@property (nonatomic, assign) NSInteger allpage;

@property (nonatomic, assign) NSInteger datanum;

@property (nonatomic, assign) NSInteger pagenum;

@property (nonatomic, assign) NSInteger pagesize;

@end

@interface WGeDatalist : NSObject

@property (nonatomic, assign) NSInteger ds;

@property (nonatomic, copy) NSString *zb;

@property (nonatomic, assign) NSInteger cnt;

@property (nonatomic, strong) NSArray<WGeDetailDatas *> *datas;

@end

@interface WGeDetailDatas : NSObject

@property (nonatomic, copy) NSString *mother;

@property (nonatomic, assign) NSInteger gemeid;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *father;

@end

