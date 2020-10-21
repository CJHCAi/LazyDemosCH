//
//  CDOneCell.h
//  CustomTabbar
//
//  Created by CDchen on 2017/9/4.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CDOneCell : UITableViewCell

@property (nonatomic, strong) UIImageView *CD_Image;
@property (nonatomic, strong) UILabel *CD_Label;
+ (CGFloat)cellHeightWithLabel:(NSString *)Label;

@end
