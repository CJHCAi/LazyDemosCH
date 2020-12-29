//
//Created by ESJsonFormatForMac on 18/08/28.
//

#import "HKFriendRespond.h"
@implementation HKFriendRespond

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [HKFriendListModel class]};
}
-(void)setCode:(NSString *)code{
    _code = code;
    if (code.length>0&&code.intValue == 0) {
        self.responeSuc = YES;
    }else{
        self.responeSuc = NO;
    }
}

@end

@implementation HKFriendListModel

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKFriendModel class]};
}


@end


@implementation HKFriendModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableName = [NSString stringWithFormat:@"FriendList_%@",HKUSERID];
        self.whereIdDict=[NSMutableArray arrayWithArray:@[@"uid"]];
    }
    return self;
}

@end


