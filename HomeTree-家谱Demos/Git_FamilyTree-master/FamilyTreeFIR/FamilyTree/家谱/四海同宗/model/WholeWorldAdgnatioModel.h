//
//  WholeWorldAdgnatioModel.h
//  FamilyTree
//
//  Created by 姚珉 on 16/7/14.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WholeWorldAdgnatioModel : NSObject

@property (nonatomic, assign) NSInteger GemeId;

@property (nonatomic, copy) NSString *GemeMobile;

@property (nonatomic, copy) NSString *GemePhoto;

@property (nonatomic, copy) NSString *GemeName;

@property (nonatomic, assign) NSInteger GemeIsfamous;

@property (nonatomic, assign) NSInteger GemeSex;

@property (nonatomic, assign) CGFloat GemeLng;

@property (nonatomic, copy) NSString *GemeSurname;

@property (nonatomic, assign) CGFloat GemeLat;

@property (nonatomic, assign) NSInteger GemeGeid;

@end
