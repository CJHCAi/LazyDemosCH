//
//  AddressCell.h
//  ReuseTableViewDemo
//
//  Created by 萧奇 on 2017/10/1.
//  Copyright © 2017年 萧奇. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Address.h"

@protocol AddressCellClickDelegate <NSObject>

// 添加人员
- (void)addUserDicToUsers:(NSDictionary *)userDic;
// 删减人员
- (void)deleteUserDicFromUsers:(NSDictionary *)userDic;

@end

@interface AddressCell : UITableViewCell

@property (nonatomic, strong)Address *address;

@property (nonatomic, weak) id<AddressCellClickDelegate> addressDelegate;

@end

