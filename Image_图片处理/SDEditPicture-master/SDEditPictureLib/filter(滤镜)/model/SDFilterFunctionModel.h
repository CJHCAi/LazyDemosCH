//
//  SDFilterFunctionModel.h
//  SDEditPicture
//
//  Created by shansander on 2017/7/18.
//  Copyright © 2017年 shansander. All rights reserved.
//

#import <Foundation/Foundation.h>

@class IFImageFilter;

typedef enum : NSUInteger {
    SDfilter_None,
    SDfilter_1977,
    SDfilter_amaro,
    SDfilter_brannan,
    SDfilter_earlybird,
    SDfilter_hefe,
    SDfilter_hudson,
    SDfilter_inkwell,
    SDfilter_lomofi,
    SDfilter_LordKelvin,
    SDfilter_Nashville,
    SDfilter_Normal,
    SDfilter_Rise,
    SDfilter_Sierra,
    SDfilter_Toaster,
    SDfilter_Valencia,
    SDfilter_Walden,
    SDfilter_XproII,
} SDFilterFunctionType;

@interface SDFilterFunctionModel : NSObject

@property (nonatomic, assign) SDFilterFunctionType functionType;

@property (nonatomic, strong) NSString * filterImageLink;

@property (nonatomic, strong) NSString * filterTitle;

@property (nonatomic, assign) BOOL isSelected;

@property (nonatomic, strong, readonly) IFImageFilter * imageFilter;

- (instancetype)initWithFilterType:(SDFilterFunctionType)functionType;

@end
