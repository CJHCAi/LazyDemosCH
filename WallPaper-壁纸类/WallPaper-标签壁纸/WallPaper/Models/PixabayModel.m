//
//  PixabayModel.m
//  WallPaper
//
//  Created by Never on 2019/7/18.
//  Copyright © 2019 Never. All rights reserved.
//

#import "PixabayModel.h"
#import <MJExtension/MJExtension.h>

@implementation PixabayModel

+(NSDictionary *)mj_replacedKeyFromPropertyName{
    
    return @{@"Id":@"id"};
    
}
@end
