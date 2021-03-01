//
//  URLCardView.h
//  HTMLDescription
//
//  Created by 刘继新 on 2017/9/12.
//  Copyright © 2017年 TopsTech. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HTMLDescription.h"

@interface URLCardView : UIView

@property (nonatomic, strong) UILabel *titleLabel;
@property (nonatomic, strong) UILabel *desLable;
@property (nonatomic, strong) UIImageView *imageView;

- (void)setHTMLData:(HTMLModel *)data;

@end
