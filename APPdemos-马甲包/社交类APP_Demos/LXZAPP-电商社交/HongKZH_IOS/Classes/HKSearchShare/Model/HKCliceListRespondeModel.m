//
//Created by ESJsonFormatForMac on 18/08/28.
//

#import "HKCliceListRespondeModel.h"
@implementation HKCliceListRespondeModel

+ (NSDictionary *)objectClassInArray{
    return @{@"data" : [HKCliceListData class]};
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

@implementation HKCliceListData

+ (NSDictionary *)objectClassInArray{
    return @{@"list" : [HKClicleListModel class]};
}


@end


@implementation HKClicleListModel
- (instancetype)init
{
    self = [super init];
    if (self) {
        self.tableName = [NSString stringWithFormat:@"Clicle_FromUid_%@",HKUSERID];
        self.whereIdDict = [NSMutableArray arrayWithArray:@[@"circleId"]];
    }
    return self;
}

@end


