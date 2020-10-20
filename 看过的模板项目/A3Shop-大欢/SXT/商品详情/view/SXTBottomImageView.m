//
//  SXTBottomImageView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/24.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTBottomImageView.h"
#import "SXTDetailsImageModel.h"
#import <UIImageView+WebCache.h>
@implementation SXTBottomImageView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setImageArray:(NSArray *)imageArray{
    CGFloat imageHeight = 0;
    
    
    for (SXTDetailsImageModel *imageModel in imageArray) {
        
        if ([imageModel.ImgType isEqualToString:@"1"]) {
            
            NSArray *sizeArray = [imageModel.Resolution componentsSeparatedByString:@"*"];
            CGFloat height = VIEW_WIDTH/[sizeArray[0] floatValue] * [sizeArray[1] floatValue];
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, imageHeight, VIEW_WIDTH, height)];
            [image sd_setImageWithURL:[NSURL URLWithString:imageModel.ImgView]];
            [self addSubview:image];
            imageHeight += height;
        }
        
    }
    if (_imageHeightBlock) {
        _imageHeightBlock(imageHeight);
    }
    SXTLog(@"imageHeight = %lf",imageHeight);
}



@end








