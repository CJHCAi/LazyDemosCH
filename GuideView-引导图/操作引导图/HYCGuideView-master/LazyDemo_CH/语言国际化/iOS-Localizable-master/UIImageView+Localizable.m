//
//  UIImageView+Localizable.m
//  Internationalization
//
//  Created by Qiulong-CQ on 16/12/2.
//  Copyright © 2016年 xiaoheng. All rights reserved.
//

#import "UIImageView+Localizable.h"

@implementation UIImageView(Localizable)



- (void)setNewImage:(NSString *)newImage{
    self.image = [UIImage imageWithContentsOfFile:[[GDLocalizableController bundle] pathForResource:newImage ofType:nil]];

}

-(NSString *)newImage{
    return self.newImage;
}

@end
