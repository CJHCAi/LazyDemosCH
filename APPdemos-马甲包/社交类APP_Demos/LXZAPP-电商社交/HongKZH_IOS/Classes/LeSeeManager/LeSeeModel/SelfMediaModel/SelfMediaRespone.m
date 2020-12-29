//
//Created by ESJsonFormatForMac on 18/09/15.
//

#import "SelfMediaRespone.h"
#import "GetMediaAdvAdvByIdRespone.h"
@implementation SelfMediaRespone

@end

@implementation SelfMediaDatas

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [SelfMediaModelList class]};
}

@end


@implementation SelfMediaModelList
+ (NSDictionary *)mj_replacedKeyFromPropertyName
{
    return @{@"ID": @"id"};
}
-(void)setRespone:(GetMediaAdvAdvByIdRespone *)respone{
    _respone = respone;
    self.ID = respone.data.ID;
    self.coverImgSrc = respone.data.coverImgSrc;
    self.title = respone.data.title;
    self.praiseCount = respone.data.praiseCount;
    self.rewardCount = respone.data.rewardCount;
}
@end


