//
//  UITableViewCell+Common.m
//  MLLabelDemo
//
//  Created by 孙巧巧 on 2017/11/28.
//  Copyright © 2017年 孙巧巧. All rights reserved.
//

#import "UITableViewCell+Common.h"

@implementation UITableViewCell (Common)


+ (UINib *)nib{
    return [UINib nibWithNibName:NSStringFromClass([self class]) bundle:[NSBundle mainBundle]];
    
}

+ (instancetype)instanceFromNib{
    return [[[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:nil options:nil] lastObject];
}

+ (NSString *)cellReuseIdentifier{
    return NSStringFromClass([self class]);
}

@end
