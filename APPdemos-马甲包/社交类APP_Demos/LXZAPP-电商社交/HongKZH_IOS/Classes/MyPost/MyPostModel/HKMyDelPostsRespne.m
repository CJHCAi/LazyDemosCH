//
//Created by ESJsonFormatForMac on 18/09/08.
//

#import "HKMyDelPostsRespne.h"
@implementation HKMyDelPostsRespne
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation HKMyDelPostsData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKMyDelPostsModel class]};
}

@end


@implementation HKMyDelPostsModel

@end


