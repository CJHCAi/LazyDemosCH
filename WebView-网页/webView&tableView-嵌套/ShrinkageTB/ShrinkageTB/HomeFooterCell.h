//
//  HomeFooterCell.h
//  BasicFW
//
//  Created by xxlc on 2019/6/24.
//  Copyright © 2019 zyy. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface HomeFooterCell : UITableViewCell
@property (nonatomic, strong) UIView *backView;
@property (nonatomic, copy) NSString *urlStr;
@property (nonatomic, copy) void(^gotoMoreBtnBlock)(NSInteger typeTag);


@end

NS_ASSUME_NONNULL_END
