//
//  WDetailJPInfoModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WJPInfoDatalist,WJPInfoDatas;
@interface WDetailJPInfoModel : NSObject

@property (nonatomic, strong) NSArray<WJPInfoDatalist *> *datalist;

/**当前卷谱id*/
@property (nonatomic,copy) NSString *currentJPID;
/**当前卷谱名*/
@property (nonatomic,copy) NSString *currentJPName;

@property (nonatomic,assign) NSInteger currentJPIdx; /*多少层*/



+(instancetype)sharedWDetailJPInfoModel;

@end
@interface WJPInfoDatalist : NSObject

@property (nonatomic, strong) NSArray<WJPInfoDatas *> *datas;

@property (nonatomic, assign) NSInteger ds;

@end

@interface WJPInfoDatas : NSObject

@property (nonatomic, copy) NSString *mother;

@property (nonatomic, assign) NSInteger gemeid;

@property (nonatomic, strong) NSArray<NSString *> *chl;

@property (nonatomic, copy) NSString *name;

@property (nonatomic, copy) NSString *photo;

@property (nonatomic, copy) NSString *father;

@end

