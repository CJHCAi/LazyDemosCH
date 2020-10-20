//
//  SXTLiveCell.m
//  bjsxt-inke
//
//  Created by 大欢 on 16/9/2.
//  Copyright © 2016年 大欢. All rights reserved.
//

#import "SXTLiveCell.h"

@interface SXTLiveCell ()

@property (weak, nonatomic) IBOutlet UIImageView *headView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@property (weak, nonatomic) IBOutlet UILabel *onLineLabel;
@property (weak, nonatomic) IBOutlet UIImageView *bigImageView;


@end

@implementation SXTLiveCell

- (void)setLive:(SXTLive *)live {
    
    _live = live;
    

    self.nameLabel.text = live.creator.nick;
    self.locationLabel.text = live.city;
    self.onLineLabel.text = [@(live.onlineUsers) stringValue];
    
    if ([live.creator.portrait isEqualToString:@"dahuan"]) {
        
        self.headView.image = [UIImage imageNamed:@"dahuan"];
        self.bigImageView.image = [UIImage imageNamed:@"dahuan"];
        
    } else {
        
        [self.headView downloadImage:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,live.creator.portrait] placeholder:@"default_room"];
        [self.bigImageView downloadImage:[NSString stringWithFormat:@"%@%@",IMAGE_HOST,live.creator.portrait] placeholder:@"default_room"];
    }
    

    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
//    self.headView.layer.cornerRadius = 25;
//    self.headView.layer.masksToBounds = YES;
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
