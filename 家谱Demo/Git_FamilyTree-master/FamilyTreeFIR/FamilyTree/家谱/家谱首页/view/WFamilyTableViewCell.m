//
//  WFamilyTableViewCell.m
//  FamilyTree
//
//  Created by 王子豪 on 16/7/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "WFamilyTableViewCell.h"

@interface WFamilyTableViewCell()
/**背景*/
@property (nonatomic,strong) UIView *whiteView;

@end

@implementation WFamilyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self.contentView addSubview:self.whiteView];
        [self.whiteView addSubview:self.famNameLabel];
        [self.whiteView addSubview:self.famImageView];
        [self.whiteView addSubview:self.famIntroLabel];
        //图像在左
        
    }
    return self;
}
-(void)changeCellStyle{
    if (_famCellType == FamilyCellImageTypeLeft) {
        self.famNameLabel.frame = AdaptationFrame(280, 13, 340, 50);
        self.famImageView.frame = AdaptationFrame(25, 25, 240, 320);
        
    }else{
        self.famNameLabel.frame = AdaptationFrame(25, 13, 308, 50);
        self.famImageView.frame = AdaptationFrame(400, 25, 240, 320);
       
    }
     self.famIntroLabel.frame = AdaptationFrame(self.famNameLabel.frame.origin.x/AdaptationWidth(), 80, 350, 240);
   
}
#pragma mark *** getters ***
-(UILabel *)famNameLabel{
    if (!_famNameLabel) {
        _famNameLabel = [[UILabel alloc] initWithFrame:AdaptationFrame(25, 13, 340, 50)];
        _famNameLabel.font = WFont(30);
        _famNameLabel.textAlignment = 0;
        [CALayer drawBottomBorder:_famNameLabel];
        
    }
    return _famNameLabel;
}
-(UIImageView *)famImageView{
    
    if (!_famImageView) {
        _famImageView = [[UIImageView alloc] initWithFrame:AdaptationFrame(400, 25, 240, 320)];
        _famImageView.contentMode = UIViewContentModeScaleAspectFit;
        _famImageView.layer.shadowColor = [UIColor blackColor].CGColor;
        _famImageView.layer.shadowOpacity = 0.5;
        _famImageView.layer.shadowRadius = 2.0;
        _famImageView.layer.shadowOffset = CGSizeMake(2, 2);
        
    }
    return _famImageView;
}
-(UITextView *)famIntroLabel{
    if (!_famIntroLabel) {
        _famIntroLabel = [[UITextView alloc] initWithFrame:AdaptationFrame(self.famNameLabel.frame.origin.x/AdaptationWidth(), 80, 350, 240)];
        _famIntroLabel.font = WFont(25);
        [_famIntroLabel setEditable:false];
        
    }
    return _famIntroLabel;
}

-(UIView *)whiteView{
    if (!_whiteView) {
        _whiteView = [[UIView alloc] initWithFrame:AdaptationFrame(0, 20, 664, 350)];
        _whiteView.backgroundColor = [UIColor whiteColor];
        
    }
    return _whiteView;
}

@end
