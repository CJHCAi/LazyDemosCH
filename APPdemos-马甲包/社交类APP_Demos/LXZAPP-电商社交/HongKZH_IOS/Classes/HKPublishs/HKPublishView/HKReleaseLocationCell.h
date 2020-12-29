//
//  HKReleaseLocationCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/8/2.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

@class HKReleaseLocationData;
@interface HKReleaseLocationCell : UITableViewCell

@property (nonatomic, strong) HKReleaseLocationData *locationData;

@end


@interface HKReleaseLocationData : NSObject

@property (nonatomic, strong) NSString *location;

@property (nonatomic, assign, getter=isShow) BOOL show;

@end
