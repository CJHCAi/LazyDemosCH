//
//  TMExpandModel.h
//  TMSwipeCell
//
//  Created by cocomanber on 2018/9/10.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef NS_ENUM(NSInteger, TMExpandType){
    TMExpandTypeOne = 0,
    TMExpandTypeTwo = 1,
};

@interface TMExpandModel : NSObject

@property (nonatomic, copy)NSString *headUrl;
@property (nonatomic, copy)NSString *name;
@property (nonatomic, copy)NSString *content;
@property (nonatomic, copy)NSString *time;

@property (nonatomic, assign)TMExpandType expandType;

+ (NSArray *)getAllDatas;

@end
