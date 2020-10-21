//
//  NSString+Size.h
//  CustomTabbar
//
//  Created by CDchen on 2017/9/4.
//  Copyright © 2017年 Dong Chen. All rights reserved.
//

#import <Foundation/Foundation.h>

#import <UIKit/UIKit.h>
@interface NSString (Size)
- (CGSize)stringSizeWithContentSize:(CGSize)contentSize font:(UIFont *)font;

@end
