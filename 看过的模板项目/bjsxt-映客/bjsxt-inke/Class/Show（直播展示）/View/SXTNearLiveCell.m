//
//  SXTNearLiveCell.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/6.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTNearLiveCell.h"

@interface SXTNearLiveCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headView;

@property (weak, nonatomic) IBOutlet UILabel *distanceLabel;

@end

@implementation SXTNearLiveCell

- (void)showAnimation {
    
    if (self.live.isShow) {
        return;
    }
    
    self.layer.transform = CATransform3DMakeScale(0.1, 0.1, 1);
    
    [UIView animateWithDuration:0.5 animations:^{
        
        self.layer.transform = CATransform3DMakeScale(1, 1, 1);
        
        self.live.show = YES;
        
    }];
}

- (void)setLive:(SXTLive *)live {
    
    _live = live;
    
    [self.headView downloadImage:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,live.creator.portrait] placeholder:@"default_room"];
    
    self.distanceLabel.text = live.distance;
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

@end
