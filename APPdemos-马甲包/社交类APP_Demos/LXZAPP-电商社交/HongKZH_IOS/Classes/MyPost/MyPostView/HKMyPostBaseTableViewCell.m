//
//  HKMyPostBaseTableViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/7.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKMyPostBaseTableViewCell.h"
#import "HKMydyamicDataModel.h"
@implementation HKMyPostBaseTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.selectionStyle =UITableViewCellSelectionStyleNone;

}
+(instancetype)myPostBaseTableViewCellWithTableView:(UITableView*)tableView{
    NSString*ID =NSStringFromClass([self class]);
    
    HKMyPostBaseTableViewCell*cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (cell == nil) {
        [tableView registerNib:[UINib nibWithNibName:ID bundle:nil] forCellReuseIdentifier:ID];
        cell = [tableView dequeueReusableCellWithIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}
-(void)viewShare{
    if ([self.delegate respondsToSelector:@selector(shareWithModel:)]) {
        [self.delegate shareWithModel:self.model];
    }
    
}
-(void)viewcommit{
    if ([self.delegate respondsToSelector:@selector(commitWithModel:)]) {
        [self.delegate commitWithModel:self.model];
    }
    
}
-(void)viewPraise{
    if ([self.delegate respondsToSelector:@selector(praiseWithModel:)]) {
        [self.delegate praiseWithModel:self.model];
    }
}
-(void)setIsHideTool:(BOOL)isHideTool{
    _isHideTool = isHideTool;
}
@end
