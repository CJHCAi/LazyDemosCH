//
//  DiagnosisTableViewCell.m
//  RPSimpleTagLabelView
//
//  Created by 李贤惠 on 2020/3/13.
//  Copyright © 2020 Tao. All rights reserved.
//

#import "DiagnosisTableViewCell.h"
#import "NSString+Extension.h"
@implementation DiagnosisTableViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
    }
    return self;
}
+ (instancetype)instanceWithDiagnosisTableViewCellIdentifier {
    return [[self alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"DiagnosisTableViewCell"];
}
- (void)setDataArray:(NSArray *)dataArray {
    _dataArray = dataArray;
    [self commitSubViews];
}
- (void) commitSubViews
{
    self.textLabel.font = [UIFont systemFontOfSize:13.0];
    self.subTitleLabel = [[UILabel alloc]init];
    self.subTitleLabel.font = [UIFont systemFontOfSize:13.0];
    self.subTitleLabel.textColor = [UIColor lightGrayColor];
    [self addSubview:self.subTitleLabel];
    
    self.labelView = [[TabLabelView alloc]initWithFrame:CGRectZero andTabsArray:self.dataArray andBackgroundColor:[UIColor whiteColor]];
    self.labelView.delegate = self;
    self.labelView.normalColor = [UIColor grayColor];
    [self addSubview:self.labelView];
    self.subTitleLabel.frame = CGRectMake(100, 1, SCREEN_WIDTH - 100, 34.0);
    self.labelView.frame = CGRectMake(20, CGRectGetMaxY(self.subTitleLabel.frame), SCREEN_WIDTH - 40, [self.labelView setCell]);
}
- (void)showTipMessageWithButton:(UIButton *)button {
    if ([self.delegate respondsToSelector:@selector(showArray:)]) {
        [self.delegate showArray:button];
    }
}
- (void)layoutSubviews {
    [super layoutSubviews];
    self.textLabel.frame = CGRectMake(20, 1, SCREEN_WIDTH - 24, 34.0);
}
- (CGFloat)CellHeight {
    return CGRectGetMaxY(self.labelView.frame);
}

@end
