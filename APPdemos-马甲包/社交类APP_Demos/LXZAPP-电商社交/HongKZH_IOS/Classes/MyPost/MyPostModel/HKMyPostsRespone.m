//
//Created by ESJsonFormatForMac on 18/09/07.
//

#import "HKMyPostsRespone.h"
@implementation HKMyPostsRespone
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation HKMypostList

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKMyPostModel class]};
}

@end


@implementation HKMyPostModel

@end

@implementation StaticadvModel

@end
