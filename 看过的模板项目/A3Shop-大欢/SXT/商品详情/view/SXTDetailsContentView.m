//
//  SXTDetailsContentView.m
//  SXT
//
//  Created by 赵金鹏 on 16/8/23.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import "SXTDetailsContentView.h"
#import "SXTDetailsListModel.h"
#import "NSString+SXTStringHelpe.h"

@implementation SXTDetailsContentView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor whiteColor];
    }
    return self;
}

- (void)setContentArray:(NSArray *)contentArray{
    _contentArray = contentArray;
    
    CGFloat textHeight = 13;
    for (SXTDetailsListModel *model in contentArray) {
        
        UILabel *titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, textHeight, 60, 12)];
        titleLabel.font = [UIFont systemFontOfSize:12.0];
        titleLabel.text = model.Title;
        [self addSubview:titleLabel];
        
        CGFloat height = [NSString returnLabelTextHeight:model.Value width:VIEW_WIDTH-190 fontSize:[UIFont systemFontOfSize:13.0]];
        UILabel *contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(75, textHeight, VIEW_WIDTH-190, height)];
        contentLabel.font = [UIFont systemFontOfSize:12.0];
        contentLabel.numberOfLines = 0;
        contentLabel.text = model.Value;
        [self addSubview:contentLabel];
        
        textHeight = textHeight + height + 15;
    }
    if (_heightBlock) {
        _heightBlock(textHeight);
    }
}



@end





