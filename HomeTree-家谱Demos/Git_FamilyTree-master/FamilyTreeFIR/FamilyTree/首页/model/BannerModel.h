//
//  BannerModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/8/18.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BannerModel : NSObject

@property (nonatomic, assign) NSInteger id;

@property (nonatomic, copy) NSString *imgpath;

@property (nonatomic, strong) NSArray<NSString *> *url;

@end
