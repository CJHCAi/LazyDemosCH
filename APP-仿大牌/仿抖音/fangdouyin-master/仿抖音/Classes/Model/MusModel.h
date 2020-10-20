//
//  MusModel.h
//  仿抖音
//
//  Created by ireliad on 2018/3/20.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "CoverLargeModel.h"

@interface MusModel : NSObject
@property(nonatomic,copy)NSString *title;
@property(nonatomic,strong)CoverLargeModel *cover_large;
@end
