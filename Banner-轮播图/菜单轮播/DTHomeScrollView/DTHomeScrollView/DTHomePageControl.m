//
//  DTHomePageControl.m
//  DTHomeScrollView
//
//  Created by 信达 on 2018/7/24.
//  Copyright © 2018年 ymh. All rights reserved.
//

#import "DTHomePageControl.h"

@implementation DTHomePageControl


//重写setCurrentPage方法，可设置圆点大小
- (void) setCurrentPage:(NSInteger)page {
    [super setCurrentPage:page];
    
    for (NSUInteger subviewIndex = 0; subviewIndex < [self.subviews count]; subviewIndex++) {
        UIImageView* subview = [self.subviews objectAtIndex:subviewIndex];
        CGSize size;
        size.height = 2;
        size.width = 10;
        [subview setFrame:CGRectMake(subview.frame.origin.x, subview.frame.origin.y,
                                     size.width,size.height)];
    }

}
@end
