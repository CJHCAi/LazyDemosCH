//
//  SDDecorateFunctionModel.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/26.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    SDDecorateFunctionReset,
    SDDecorateFunctionImage,
} SDDecorateFunctionType;

@interface SDDecorateFunctionModel : NSObject

@property (nonatomic, assign) SDDecorateFunctionType decorateType;


@property (nonatomic, strong) NSString * imageLink;

@property (nonatomic, assign) BOOL isSelected;


@property (nonatomic, strong) RACSubject * done_subject;

- (instancetype)initWithFunctionType:(SDDecorateFunctionType)type;


@end
