//
//  Cell.m
//  ShowMoreText
//
//  Created by yaoshuai on 2017/1/20.
//  Copyright © 2017年 ys. All rights reserved.
//

#import "Cell.h"
#import "Model.h"

#define kWidth [UIScreen mainScreen].bounds.size.width

@interface Cell()

@end

@implementation Cell{
    UILabel *_titleLabel;
    UILabel *_contentLabel;
    UIButton *_moreTextBtn;
}

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier])
    {
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        
        _titleLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, 300, 20)];
        _titleLabel.textColor = [UIColor wjColorFloat:@"008CCF"];
        _titleLabel.font = [UIFont systemFontOfSize:18];
        [self.contentView addSubview:_titleLabel];
        
        _contentLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 30,kWidth - 30 , 20)];
        _contentLabel.textColor = [UIColor darkGrayColor];
        _contentLabel.font = [UIFont systemFontOfSize:16];
        _contentLabel.numberOfLines = 0;
        [self.contentView addSubview:_contentLabel];
        
        _moreTextBtn = [UIButton buttonWithType:UIButtonTypeCustom];
        [_moreTextBtn setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        _moreTextBtn.frame = CGRectMake(kWidth - 50, 5, 40, 20);
        [self.contentView addSubview:_moreTextBtn];
        [_moreTextBtn addTarget:self action:@selector(showMoreText) forControlEvents:UIControlEventTouchUpInside];
        
    }
    return self;
}

- (void)showMoreText{
    self.model.isShowMoreText = !self.model.isShowMoreText;
    if (self.showMoreBlock){
        self.showMoreBlock(self);
    }
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    _titleLabel.text = self.model.title;
    
    _contentLabel.text = self.model.content;
    if (self.model.isShowMoreText){ // 展开状态
        // 计算文本高度
        NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
        
        NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
        
        // self.model.content：内容字符串
        CGSize size = [self.model.content boundingRectWithSize:CGSizeMake(kWidth - 30, 0) options:option attributes:attribute context:nil].size;
        
        [_contentLabel setFrame:CGRectMake(15, 30, kWidth - 30, size.height)];
        
        [_moreTextBtn setTitle:@"收起" forState:UIControlStateNormal];
    } else { // 收缩状态
        
        [_contentLabel setFrame:CGRectMake(15, 30, kWidth - 30, 35)];
        
        [_moreTextBtn setTitle:@"展开" forState:UIControlStateNormal];
    }
}

// MARK: - 获取默认高度
+ (CGFloat)defaultHeight:(Model *)model{
    return 85.0f;
}

// MARK: - 获取展开后的高度
+ (CGFloat)moreHeight:(Model *)model{
    
    // 展开后得高度 = 计算出文本内容的高度 + 固定控件的高度
    
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:16]};
    
    NSStringDrawingOptions option = (NSStringDrawingOptions)(NSStringDrawingTruncatesLastVisibleLine | NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading);
    
    CGSize size = [model.content boundingRectWithSize:CGSizeMake(kWidth - 30, 0) options:option attributes:attribute context:nil].size;
    
    return size.height + 50;
    
}

@end
