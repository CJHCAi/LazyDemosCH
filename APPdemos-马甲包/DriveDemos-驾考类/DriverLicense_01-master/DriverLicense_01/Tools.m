//
//  Tools.m
//  DriverLicense_01
//
//  Created by 付小宁 on 16/2/13.
//  Copyright © 2016年 Maizi. All rights reserved.
//

#import "Tools.h"

@implementation Tools
+(NSArray *)getAnswerWithString:(NSString*)str
{
    NSMutableArray *array = [[NSMutableArray alloc]init];
    NSArray *arr = [str componentsSeparatedByCharactersInSet:@"<BR>"] ;
    [array addObject:arr[0]];
    for (int i = 0; i<4; i++) {
        [array addObject:arr[4]];
    }

    return arr;
}
@end
