//
//  HKSowIngTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/12.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSowIngTableViewCell.h"
#import "HKLeSeeSowIngMapView.h"
@interface HKSowIngTableViewCell()
@property (weak, nonatomic) IBOutlet HKLeSeeSowIngMapView *iconViews;

@end

@implementation HKSowIngTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
+(instancetype)sowIngTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID = @"HKSowIngTableViewCell";
    
    HKSowIngTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:@"HKSowIngTableViewCell" bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)setImageArray:(NSMutableArray *)imageArray{
    _imageArray = imageArray;
    self.iconViews.imageArray  = imageArray;
}
@end
