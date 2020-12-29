//
//  HKTravelPublishTitleCell.h
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/10/23.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef void(^PhotoBlock)(NSInteger index);

@interface HKTravelPublishTitleCell : UITableViewCell

@property (nonatomic, strong) UIImage *coverImage;

@property (nonatomic, strong) NSString *title;

@property (nonatomic, strong) NSString *content;

@property (nonatomic, copy) PhotoBlock block;

@property (nonatomic,strong)NSString *inHtmlString;

-(void)getNewStringForContent;

@end
