//
//  RecommendeTableViewCell.m
//  HeaderViewAndPageView
//
//  Created by yangpan on 2016/12/19.
//  Copyright © 2016年 susu. All rights reserved.
//

#import "RecommendeTableViewCell.h"

@implementation RecommendeTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *cellID = @"RecommendeTableViewCell";
    RecommendeTableViewCell           *cell = [tableView dequeueReusableCellWithIdentifier:cellID ];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"RecommendeTableViewCell" owner:self options:nil] lastObject];
    }
    return cell;
    
    
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
