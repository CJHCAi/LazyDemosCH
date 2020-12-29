//
//Created by ESJsonFormatForMac on 18/09/14.
//

#import "HKInitializationRespone.h"
@implementation HKInitializationRespone
MJExtensionCodingImplementation
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation InitializationDatas
MJExtensionCodingImplementation
+ (NSDictionary *)objectClassInArray{
    return @{@"allMediaCategorys" : [AllmediacategorysModel class], @"allCategorys" : [AllcategorysModel class], @"recruitCategorys" : [RecruitcategorysModel class], @"dict" : [DictModel class], @"recruitIndustrys" : [RecruitindustrysModel class]};
}

@end


@implementation AllmediacategorysModel
MJExtensionCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

@end


@implementation AllcategorysModel
MJExtensionCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

@end


@implementation RecruitcategorysModel
MJExtensionCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

@end


@implementation DictModel
MJExtensionCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             ,@"Description":@"description"};
}

@end


@implementation RecruitindustrysModel
MJExtensionCodingImplementation
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{
             @"ID":@"id"
             };
}

@end


