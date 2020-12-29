//
//  LHPhotoView.m
//  LHand
//
//  Created by 小华 on 15/5/15.
//  Copyright (c) 2015年 chenstone. All rights reserved.
//  对应的小图片

#import "LHPhotoView.h"
#import "LHPhotoModel.h"
#import "ImageListModel.h"
#import "UIImageView+WebCache.h"
//#import "ResultsModel.h"
//#import "SimpleMethods.h"
#import "UIImageView+HKWeb.h"
//#import "UIImageView+CornerRadius.h"

@implementation LHPhotoView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.userInteractionEnabled=YES;
        self.contentMode = UIViewContentModeScaleAspectFill;
        self.clipsToBounds = YES;
        self.layer.cornerRadius=3;
    }
    return self;
}

- (void)setPhoto:(ImageListModel *)photo
{
    _photo = photo;

    [self hk_sd_setImageWithURL:photo.fileUrl placeholderImage:kPlaceholderImage];

}



@end
