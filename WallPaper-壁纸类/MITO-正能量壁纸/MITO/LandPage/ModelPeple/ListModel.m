//
//  ListModel.m
//  MITO
//
//  Created by keenteam on 2017/12/17.
//  Copyright © 2017年 keenteam. All rights reserved.
//

#import "ListModel.h"

@implementation ListModel

+ ( NSDictionary*)modelContainerPropertyGenericClass {
    return @{@"audio":[List_audioModel class]};
}


@end
