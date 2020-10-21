//
//  ImageProcessCell.m
//  LuoChang
//
//  Created by Supwin_mbp002 on 16/1/14.
//  Copyright © 2016年 Rick. All rights reserved.
//

#import "ImageProcessCell.h"

@implementation ImageProcessCell

- (void)awakeFromNib {
    // Initialization code
    self.imageView.contentMode = UIViewContentModeScaleAspectFill;
    self.coverImageView.backgroundColor = [UIColor blackColor];
}

@end
