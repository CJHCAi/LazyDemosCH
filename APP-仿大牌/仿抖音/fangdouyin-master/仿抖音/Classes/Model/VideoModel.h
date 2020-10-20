//
//  VideoModel.h
//  仿抖音
//
//  Created by ireliad on 2018/3/19.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "PlayAddrModel.h"
#import "CoverModel.h"

@interface VideoModel : NSObject
@property(nonatomic,strong)PlayAddrModel *play_addr;
@property(nonatomic,strong)CoverModel *cover;
@end
