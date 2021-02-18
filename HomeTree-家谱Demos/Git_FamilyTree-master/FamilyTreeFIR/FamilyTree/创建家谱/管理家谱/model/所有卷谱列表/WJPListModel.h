//
//  WJPListModel.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/8.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WJPListModel : NSObject

@property (nonatomic, assign) NSInteger genid;

@property (nonatomic, copy) NSString *jpname;

@property (nonatomic, assign) NSInteger maxlevel;

@property (nonatomic, assign) NSInteger genmeid;

@property (nonatomic, assign) NSInteger minlevel;

@end
