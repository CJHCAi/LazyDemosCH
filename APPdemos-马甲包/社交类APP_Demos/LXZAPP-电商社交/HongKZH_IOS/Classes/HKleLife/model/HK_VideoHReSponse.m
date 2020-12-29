//
//Created by ESJsonFormatForMac on 18/09/25.
//

#import "HK_VideoHReSponse.h"
@implementation HK_VideoHReSponse

@end

@implementation HK_VideosData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HK_DataVideoList class]};
}

@end


@implementation HK_DataVideoList

//-(void)setValue:(id)value forKey:(NSString *)key {
//    if ([key isEqualToString:@"id"]) {
//        self.ID = value;
//    }
//}

+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}

@end


