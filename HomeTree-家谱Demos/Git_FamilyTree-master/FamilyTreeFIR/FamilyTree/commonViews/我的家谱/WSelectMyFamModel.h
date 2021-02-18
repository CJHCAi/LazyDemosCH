//
//  WSelectMyFamModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/27.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WSelectMyFamModel : NSObject

@property (nonatomic,copy) NSArray *myFamArray; /*我所有的家谱*/
/**我所有家谱对应的id*/
@property (nonatomic,copy) NSArray *myFamIdArray;

+(instancetype)sharedWselectMyFamModel;

@end
