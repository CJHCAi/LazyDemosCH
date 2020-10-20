//
//  WIDModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/1.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>
//身份id，每个身份有唯一id



@class Ds,Sf,Gemedata;
@interface WIDModel :NSObject

//@property (nonatomic, copy) NSString *syntype;
//
//@property (nonatomic, copy) NSString *syntypeval;
//
@property (nonatomic,strong) NSDictionary *idDic; /*身份dic*/
//
@property (nonatomic,strong) NSDictionary *fatherDic; /*父亲dic*/
//
@property (nonatomic,strong) NSDictionary *genDic; /*代数字辈dic*/

/**成员是否成为首卷谱*/
@property (nonatomic,assign)  BOOL becomeFirstJP;


+(instancetype)sharedWIDModel;


@property (nonatomic,copy) NSArray *gemedata; /*父辈id*/
@property (nonatomic,strong) NSDictionary *ds; /*字辈字典*/
@property (nonatomic,copy) NSArray *sf; /*身份id*/






@end

