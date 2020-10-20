//
//  ExpandTableViewCell.m
//  ExpandFrameModel
//
//  Created by 栗子 on 2017/12/8.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import "ExpandTableViewCell.h"
#import "ListFrameModel.h"

@implementation ExpandTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}
-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        
        [self addSubviews];
    }
    return self;
}
-(void)addSubviews{
    self.questionLB = [[UILabel alloc]init];
    self.questionLB.font = [UIFont systemFontOfSize:15];
    [self.contentView addSubview:self.questionLB];
    self.questionLB.textAlignment = NSTextAlignmentLeft;
    
    self.arrowIV = [[UIImageView alloc]init];
    [self.contentView addSubview:self.arrowIV];
    
    self.line = [[UIView alloc]init];
    [self.contentView addSubview:self.line];
    self.line.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
    self.answerLB = [[UILabel alloc]init];
    [self.contentView addSubview:self.answerLB];
    self.answerLB.font = [UIFont systemFontOfSize:15];
    self.answerLB.textAlignment = NSTextAlignmentLeft;
    self.answerLB.numberOfLines = 0;
    
    self.line1 = [[UIView alloc]init];
    [self.contentView addSubview:self.line1];
    self.line1.backgroundColor = [UIColor groupTableViewBackgroundColor];
    
}

-(void)setFrameModel:(ListFrameModel *)frameModel{
    _frameModel = frameModel;
    self.questionLB.frame = frameModel.questionFrame;
    self.arrowIV.frame    = frameModel.arrowFrame;
    self.line.frame       = frameModel.firstLineFrame;
    self.answerLB.frame   = frameModel.answerFrame;
    self.line1.frame      = frameModel.secondLineFrame;
    
    self.questionLB.text = [NSString stringWithFormat:@"%@",frameModel.listModel.question];
    self.answerLB.text = [NSString stringWithFormat:@"%@",frameModel.listModel.answer];
    if (frameModel.listModel.isSelected) {
        self.arrowIV.image = [UIImage imageNamed:@"arrowTop"];
    }else{
        self.arrowIV.image = [UIImage imageNamed:@"arrowdown"];
    }
    
}


@end
