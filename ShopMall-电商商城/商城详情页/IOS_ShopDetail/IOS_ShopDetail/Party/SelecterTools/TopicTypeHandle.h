//
//  TopicTypeHandle.h
//  xtd_app_ios_financePeopleios
//
//  Created by 苟应航 on 2017/11/24.
//  Copyright © 2017年 Xtd. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "TopicTypeModel.h"
@interface TopicTypeHandle : NSObject
- (TopicTypeModel *) getDesignPerceptionListByType: (int)type;
@end
