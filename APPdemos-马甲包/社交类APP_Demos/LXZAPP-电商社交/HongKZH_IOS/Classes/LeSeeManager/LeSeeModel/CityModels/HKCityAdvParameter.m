//
//  HKCityAdvParameter.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/10/22.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCityAdvParameter.h"
#import "UrlConst.h"
@implementation HKCityAdvParameter
-(NSString *)latitude{
    return [NSString stringWithFormat:@"%lf",[ViewModelLocator sharedModelLocator].latitude] ;
}
-(NSString *)longitude{
    return [NSString stringWithFormat:@"%lf",[ViewModelLocator sharedModelLocator].longitude] ;
}
-(void)setType:(int)type{
    _type = type;
    if (type == 1) {
        self.urlString = get_cityNearbyAdvList;
    }else{
        self.urlString = get_CityAdvList;
    }
}
-(NSDictionary*)parameter{
    if (self.type == 1) {
        return @{@"pageNumber":@(self.pageNumber),@"latitude":self.latitude,@"longitude":self.longitude};
    }else{
        return @{@"pageNumber":@(self.pageNumber)};
    }
}
@end
