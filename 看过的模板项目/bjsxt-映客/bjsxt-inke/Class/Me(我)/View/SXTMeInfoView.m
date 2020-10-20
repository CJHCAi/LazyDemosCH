//
//  SXTMeInfoView.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/7.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTMeInfoView.h"

@implementation SXTMeInfoView

+ (instancetype)loadInfoView {
    
    return  [[[NSBundle mainBundle] loadNibNamed:@"SXTMeInfoView" owner:self options:nil] lastObject];
}


@end
