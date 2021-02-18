//
//  WFamilyModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@class WFDatalist;
@interface WFamilyModel : NSObject


@property (nonatomic, assign) NSInteger rs;

@property (nonatomic, assign) NSInteger ds;

@property (nonatomic, strong) NSArray<WFDatalist *> *datalist;

/**自己选择的家谱id*/
@property (nonatomic,copy) NSString *myFamilyId;
/**自己选择的家谱名称*/
@property (nonatomic,copy) NSString *myFamilyName;




+(instancetype)shareWFamilModel;

@end

@interface WFDatalist : NSObject

@property (nonatomic, assign) NSInteger GemeId;

@property (nonatomic, copy) NSString *GemeName;

@property (nonatomic, copy) NSString *Grjl;

@property (nonatomic, copy) NSString *GemePhoto;

@property (nonatomic, copy) NSString *GemeSurname;



@end

