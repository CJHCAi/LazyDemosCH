//
//  friendTableViewCell.m
//  mayisenlin
//
//  Created by iOS on 2020/9/10.
//  Copyright © 2020 jucdy. All rights reserved.
//

#import "friendTableViewCell.h"
#import "Config.h"

@interface friendTableViewCell ()

@property (nonatomic,strong) UILabel *rankingLabel;

@property (nonatomic,strong) UIImageView *iconImg;

@property (nonatomic,strong) UILabel *nameLabel;

@property (nonatomic,strong) UILabel *certificateLabel;

@property (nonatomic,strong) UILabel *energyLabel;

@end

@implementation friendTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self == [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self addViews];
    }
    return self;
}

-(void)addViews
{
    self.rankingLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 40, 70)];
    self.rankingLabel.textAlignment = NSTextAlignmentCenter;
    self.rankingLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.rankingLabel];
    
    
    self.iconImg = [[UIImageView alloc] initWithFrame:CGRectMake(40, 15, 40, 40)];
    self.iconImg.layer.masksToBounds = YES;
    self.iconImg.layer.cornerRadius = 5;
    [self.contentView addSubview:self.iconImg];
    
    
    self.nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 15, 150, 20)];
    self.nameLabel.textColor = [UIColor blackColor];
    self.nameLabel.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.nameLabel];
    
    
    self.certificateLabel = [[UILabel alloc] initWithFrame:CGRectMake(100, 35, 150, 20)];
    self.certificateLabel.font = [UIFont systemFontOfSize:14];
    self.certificateLabel.textColor = [UIColor darkGrayColor];
    [self.contentView addSubview:self.certificateLabel];
    
    
    self.energyLabel = [[UILabel alloc] initWithFrame:CGRectMake(YLBScreenWidth - 70, 0, 70, 70)];
    self.energyLabel.font = [UIFont systemFontOfSize:15];
    self.energyLabel.textAlignment = NSTextAlignmentCenter;
    [self.contentView addSubview:self.energyLabel];
    
    
}

-(void)setDict:(NSDictionary *)dict
{
    _dict = dict;
    
    self.rankingLabel.text = dict[@"ranking"];
    
    self.iconImg.image = [UIImage imageNamed:dict[@"icon"]];
    
    self.nameLabel.text = dict[@"name"];
    
    self.certificateLabel.text = [NSString stringWithFormat:@"获得了%@个环保证书",dict[@"certificate"]];
    
    self.energyLabel.text = [NSString stringWithFormat:@"%@kg",dict[@"energy"]];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
