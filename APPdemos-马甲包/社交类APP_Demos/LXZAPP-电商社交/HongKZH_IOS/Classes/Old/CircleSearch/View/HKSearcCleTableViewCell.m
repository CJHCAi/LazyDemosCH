//
//  HKSearcCleTableViewCell.m
//  HongKZH_IOS
//
//  Created by 王辉 on 2018/8/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKSearcCleTableViewCell.h"
@interface HKSearcCleTableViewCell ()
@property (weak, nonatomic) IBOutlet UIImageView *headImage;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *numL;
@end
@implementation HKSearcCleTableViewCell

+(instancetype)searcCleTableViewCellWithTableView:(UITableView*)tableView{
    HKSearcCleTableViewCell *cell = (HKSearcCleTableViewCell*)[tableView dequeueReusableHeaderFooterViewWithIdentifier:@"HKSearcCleTableViewCell"];
    if (cell == nil) {
        cell = [[NSBundle mainBundle]loadNibNamed:@"HKSearcCleTableViewCell" owner:self options:nil].lastObject;
        cell.headImage.layer.cornerRadius = 24;
        cell.headImage.layer.masksToBounds = YES;
    }
    return cell;
}
-(void)setDataM:(HKSearchcircleListModelData *)dataM{
    _dataM = dataM;
    [self.headImage sd_setImageWithURL:[NSURL URLWithString:dataM.coverImgSrc]];
    self.nameL.text = dataM.circleName;
    
    self.numL.text = [NSString stringWithFormat:@"%@ · %ld",dataM.categoryName,dataM.userCount ];
}
@end
