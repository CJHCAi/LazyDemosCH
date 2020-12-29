//
//Created by ESJsonFormatForMac on 18/09/08.
//

#import "HKMyRepliesPostsRespone.h"
@implementation HKMyRepliesPostsRespone
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}
@end

@implementation MyRepliesPostsList

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [MyRepliesPostsListModel class]};
}

@end


@implementation MyRepliesPostsListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"comments" : [MyRepliesPostsModel class]};
}

@end


@implementation MyRepliesPostsModel

@end


