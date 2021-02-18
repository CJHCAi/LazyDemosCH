//
//  CliffordTributeModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface CliffordTributeModel : NSObject

@property (nonatomic, assign) NSInteger CoprId;

@property (nonatomic, assign) NSInteger CoprMoney;

@property (nonatomic, copy) NSString *CoConame;

@property (nonatomic, assign) NSInteger CoprActpri;

@property (nonatomic, copy) NSString *CoCover;

@property (nonatomic, copy) NSString *CoLabel;

@property (nonatomic, copy) NSString *CoConstype;

@property (nonatomic, assign) NSInteger CoId;

/**数组*/
@property (nonatomic,copy) NSArray *cliffordArr;
+(instancetype)shareClifordArr;
@end
