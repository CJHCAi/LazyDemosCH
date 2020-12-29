//
//Created by ESJsonFormatForMac on 18/09/27.
//

#import "HKLeShopHomeRespone.h"
@implementation HKLeShopHomeRespone

@end

@implementation HKLeShopHomeDatas

+ (NSDictionary *)objectClassInArray{
    return @{@"categorys" : [HKLeShopHomeCategoryes class], @"selectedProducts" : [HKLeShopHomeToSelectedproducts class], @"luckyVoucher" : [HKLeShopHomeLuckyvouchers class], @"carousels" : [HKLeShopHomeCarouseles class], @"hotsShops" : [HKLeShopHomeHotsshopes class]};
}

@end


@implementation HKLeShopHomeCategoryes

@end


@implementation HKLeShopHomeToSelectedproducts

@end


@implementation HKLeShopHomeLuckyvouchers
-(void)setEndDate:(NSInteger)endDate{
    _endDate = endDate;
    if (self.currentTime.length>0) {
        NSArray*array = [self.currentTime componentsSeparatedByString:@":"];
        if (array.count == 3) {
            NSString* h =  array.firstObject;
            NSString*m = array[1];
            NSString*s = array.lastObject;
            self.difference = self.endDate*3600 - h.integerValue*3600+m.integerValue*60+s.integerValue;
        }else if (array.count == 2){
            NSString*m = array[0];
            NSString*s = array.lastObject;
            self.difference =self.endDate*3600 - m.integerValue*60+s.integerValue;
        }else if (array.count == 1){
            self.difference = self.endDate*3600 - [array.firstObject integerValue];
        }
        if (self.difference<0) {
            self.difference = 0;
        }
    }else{
        self.difference = 0;
    }
}
-(void)setBeginDate:(NSInteger)beginDate{
    _beginDate = beginDate;
    if (self.currentTime.length>0) {
        NSArray*array = [self.currentTime componentsSeparatedByString:@":"];
        if (array.count == 3) {
            NSString* h =  array.firstObject;
            NSString*m = array[1];
            NSString*s = array.lastObject;
            self.startDifference = self.beginDate*3600 - h.integerValue*3600+m.integerValue*60+s.integerValue;
        }else if (array.count == 2){
            NSString*m = array[0];
            NSString*s = array.lastObject;
            self.startDifference =self.beginDate*3600 - m.integerValue*60+s.integerValue;
        }else if (array.count == 1){
            self.startDifference = self.beginDate*3600 - [array.firstObject integerValue];
        }
        if (self.startDifference<0) {
            self.startDifference = 0;
        }
    }else{
        self.startDifference = 0;
    }
}
@end


@implementation HKLeShopHomeCarouseles

@end


@implementation HKLeShopHomeHotsshopes

+ (NSDictionary *)objectClassInArray{
    return @{@"shops" : [HKLeShopHomeShopes class]};
}

@end


@implementation HKLeShopHomeShopes

@end


