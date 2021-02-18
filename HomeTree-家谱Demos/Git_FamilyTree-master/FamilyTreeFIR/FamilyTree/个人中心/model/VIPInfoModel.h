//
//  VIPInfoModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/28.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VIPInfoModel : NSObject
//ID--id
@property (nonatomic, copy) NSString *ID;

@property (nonatomic, strong) NSArray<NSString *> *content;

@end
