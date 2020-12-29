//
//  HKColorHeadCollectionViewCell.m
//  HongKZH_IOS
//
//  Created by wanghui on 2018/9/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKColorHeadCollectionViewCell.h"
@interface HKColorHeadCollectionViewCell()
@property (weak, nonatomic) IBOutlet UILabel *titleView;
@property (weak, nonatomic) IBOutlet UIView *lineVIew;

@end

@implementation HKColorHeadCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
-(void)setIndexPath:(NSIndexPath *)indexPath{
    _indexPath = indexPath;
    if (indexPath.section == 1) {
        self.titleView.text = @"颜色";
        self.lineVIew.hidden = YES;
    }else{
        self.titleView.text = @"尺寸";
        self.lineVIew.hidden = NO;
    }
}
@end
