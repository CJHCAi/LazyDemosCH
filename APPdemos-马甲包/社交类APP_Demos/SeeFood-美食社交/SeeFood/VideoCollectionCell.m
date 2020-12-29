//
//  VideoCollectionCell.m
//  SeeFood
//
//  Created by 纪洪波 on 15/11/25.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "VideoCollectionCell.h"
#import "UIView+UIView_Frame.h"
#import <UIImageView+WebCache.h>

@interface VideoCollectionCell()

@end

@implementation VideoCollectionCell
-(instancetype)initWithFrame:(CGRect)frame {
    self = [super initWithFrame:frame];
    if (self) {
        //  poster
        _poster = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        _poster.contentMode = UIViewContentModeScaleAspectFill;
        _poster.backgroundColor = [UIColor grayColor];
        _poster.clipsToBounds = YES;
        [self.contentView addSubview:_poster];
        
        //  backImage
        UIImageView *back = [[UIImageView alloc]initWithFrame:CGRectMake(0, self.bounds.size.height / 3 * 2, self.bounds.size.width, self.bounds.size.height / 3)];
        back.image = [UIImage imageNamed:@"Black"];
        [_poster addSubview:back];
        
        //  title
        _title = [[UILabel alloc]initWithFrame:CGRectMake(0, back.height - 30, back.width, 30)];
        _title.textColor = [UIColor whiteColor];
        _title.textAlignment = NSTextAlignmentCenter;
        [back addSubview:_title];
    }
    return self;
}

- (void)setValueWithModel:(VideoModel *)model {
    NSURL *url1 = [NSURL URLWithString:model.coverForDetail];
    [self.poster sd_setImageWithURL:url1 placeholderImage:nil];
    
    self.title.text = model.title;
}
@end
