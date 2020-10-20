//
//  UILabel+Localizable.m
//  Internationalization
//
//  Created by Qiulong-CQ on 2016/12/7.
//  Copyright © 2016年 xiaoheng. All rights reserved.
//

#import "UILabel+Localizable.h"

@implementation UILabel(Localizable)


- (void)setNewText:(NSString *)newText
{
    self.text = GDLocalizedString(newText);
}

-(NSString *)newText{
    return self.newText;
}
@end
