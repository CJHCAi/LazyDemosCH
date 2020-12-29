//
//  WallCell.m
//  SportForum
//
//  Created by zhengying on 6/10/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "WallCell.h"
#import "UIImageView+WebCache.h"
@implementation WallCellInfo
@end

@implementation WallCell

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
    }
    return self;
}


-(void)setCellInfo:(WallCellInfo *)cellInfo {
    
    if (_viewContent == nil) {
        
        _viewContent = [[UIView alloc]initWithFrame:self.frame];
        
        _imgViewPic = [[UIImageView alloc]initWithFrame:CGRectMake(1, 1, CGRectGetWidth(self.frame) - 2, CGRectGetHeight(self.frame) - 2)];
        //_imgViewPic.layer.borderColor = [UIColor whiteColor].CGColor;
        _imgViewPic.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewPic.clipsToBounds  = YES;
        
        [_viewContent addSubview:_imgViewPic];
        
        _viewFrame = [[UIView alloc] initWithFrame:self.frame];
        _viewFrame.backgroundColor = [UIColor clearColor];//[UIColor colorWithRed:236 / 255.0 green:236 / 255.0 blue:236 / 255.0 alpha:1];
        //CALayer * layer = _viewFrame.layer;
        //[layer setBorderWidth:1.0];
        //[layer setBorderColor:[[UIColor whiteColor] CGColor]];
        
        [_viewContent addSubview:_viewFrame];
        [_viewContent bringSubviewToFront:_imgViewPic];
        
        _lblDesc = [[AutoSizeTextLabel alloc]initWithFrame:CGRectMake(1,
                                                            self.frame.size.height - self.frame.size.height/2 - 1,
                                                            self.frame.size.width - 2,
                                                            self.frame.size.height/2)];
        
        _lblDesc.backgroundColor = [UIColor colorWithWhite:0.2 alpha:0.5];
        _lblDesc.textColor = [UIColor colorWithRed:241.0 / 255.0 green:204.0 / 255.0 blue:0 alpha:1.0];
        [_viewContent addSubview:_lblDesc];
        [_viewContent setUserInteractionEnabled:NO];
        [self addSubview:_viewContent];
        
        _imgViewUser = [[UIImageView alloc]initWithFrame:CGRectMake(5, 10, 30, 30)];
        _imgViewUser.contentMode = UIViewContentModeScaleAspectFill;
        _imgViewUser.clipsToBounds  = YES;
        _imgViewUser.layer.cornerRadius = 5.0;
        [_viewContent addSubview:_imgViewUser];
        [_viewContent bringSubviewToFront:_imgViewUser];
    }
    
    [_imgViewUser sd_setImageWithURL:[NSURL URLWithString:cellInfo.imageUser] placeholderImage:[UIImage imageNamed:@"image-placeholder"] withInset:0];
    [_imgViewPic sd_setImageWithURL:[NSURL URLWithString:cellInfo.imageURL] placeholderImage:[UIImage imageNamed:@"review_bg"]];
    _lblDesc.text = cellInfo.title;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
