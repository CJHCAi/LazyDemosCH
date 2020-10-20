//
//  WSearchModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WPage,WSearchGenlist;
@interface WSearchModel : NSObject

@property (nonatomic, strong) NSArray<WSearchGenlist *> *genlist;

@property (nonatomic, assign) BOOL datatype;

@property (nonatomic, strong) WPage *page;

/**点击的家谱id*/
@property (nonatomic,copy) NSString *selectedFamilyID;
/**点击的家谱名*/
@property (nonatomic,copy) NSString *selectedFamilyName;



+(instancetype)shardSearchModel;

@end
@interface WPage : NSObject

@property (nonatomic, assign) NSInteger allpage;

@property (nonatomic, assign) NSInteger datanum;

@property (nonatomic, assign) NSInteger pagenum;

@property (nonatomic, assign) NSInteger pagesize;

@end

@interface WSearchGenlist : NSObject

@property (nonatomic, assign) NSInteger GeId;

@property (nonatomic, copy) NSString *GeName;

@property (nonatomic, copy) NSString *GeCover;

@end

