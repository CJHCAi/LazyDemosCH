//
//  SDCutFunctionModel.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/25.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SDCutFunctionReset,
    SDCutFunctionFree,
    SDCutFunction1_1,
    SDCutFunction16_9,
    SDCutFunction4_3,
    SDCutFunction3_2,
    SDCutFunction5_4,
} SDCutFunctionType;

@interface SDCutFunctionModel : NSObject

@property (nonatomic, assign)SDCutFunctionType cutModel;


@property (nonatomic, assign) BOOL isSelected;


@property (nonatomic, strong) RACSubject* done_subject;

- (instancetype)initWithFunctionModel:(SDCutFunctionType )model;

@end
