//
//  HKTitleAndContentCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKTitleAndContentCell.h"

@interface HKTitleAndContentCell () <UITextViewDelegate>

@property (nonatomic, weak) UIImageView *iconView;

@property (nonatomic, weak) UITextView *titleTextView;

@property (nonatomic, weak) UILabel *countLabel;

@property (nonatomic, weak) UIView *line;

@property (nonatomic, assign) NSInteger count;

@property (nonatomic, weak) UITextView *contentTextView;

@end

@implementation HKTitleAndContentCell

- (UIImageView *)iconView {
    if (!_iconView) {
        UIImageView *imageView = [[UIImageView alloc] init];
        imageView.backgroundColor = RGB(241, 241, 241);
        imageView.image = [HKReleaseVideoParam shareInstance].coverImgSrc;
        imageView.contentMode = UIViewContentModeScaleAspectFit;
        [self.contentView addSubview:imageView];
        _iconView = imageView;
    }
    return _iconView;
}

- (UITextView *)titleTextView {
    if (!_titleTextView) {
        UITextView *textView = [[UITextView alloc] init];
        textView.delegate = self;
        textView.font = [UIFont fontWithName:PingFangSCRegular size:15.f];
        textView.placeholder = @"好标题更有人气";
        textView.text = [[HKReleaseVideoParam shareInstance].dict objectForKey:@"title"];
        [self.contentView addSubview:textView];
        _titleTextView = textView;
    }
    return _titleTextView;
}

- (UILabel *)countLabel {
    if(!_countLabel) {
        UILabel *label = [[UILabel alloc] init];
        label.font = [UIFont fontWithName:PingFangSCRegular size:13.f];
        label.textColor = RGB(204, 204, 204);
        label.textAlignment = NSTextAlignmentRight;
        label.text = @"30/30";
        [self.contentView addSubview:label];
        self.countLabel = label;
    }
    return _countLabel;
}

- (UIView *)line {
    if (!_line) {
        UIView *line = [[UIView alloc] init];
        line.backgroundColor = RGB(226,226,226);
        [self.contentView addSubview:line];
        _line = line;
    }
    return _line;
}

- (UITextView *)contentTextView {
    if (!_contentTextView) {
        UITextView *textView = [[UITextView alloc] init];
        textView.delegate = self;
        textView.font = [UIFont fontWithName:PingFangSCRegular size:15.f];
        textView.placeholder = @"说说你的心得吧～";
        textView.text = [[HKReleaseVideoParam shareInstance].dict objectForKey:@"remarks"];
        [self.contentView addSubview:textView];
        _contentTextView = textView;
    }
    return _contentTextView;
}

- (void)setCoverImage:(UIImage *)coverImage {
    if (coverImage) {
        _coverImage = coverImage;
        self.iconView.image = coverImage;
    }
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    //左侧图片
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(16);
        make.size.mas_equalTo(CGSizeMake(75, 75));
    }];
    
    //countlabel
    [self.countLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.right.equalTo(self.contentView).offset(-15);
        make.top.equalTo(self.iconView).offset(67);
        make.height.mas_equalTo(13);
    }];
    
    //textView
    [self.titleTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(12);
        make.top.equalTo(self.iconView).offset(7);
        make.right.equalTo(self.contentView).offset(-10);
        make.bottom.equalTo(self.countLabel.mas_top).offset(-5);
    }];
    
    //line
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.contentView);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.iconView.mas_bottom).offset(15);
    }];
    
    //contentTextView
    [self.contentTextView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(16);
        make.right.equalTo(self.contentView).offset(-16);
        make.top.equalTo(self.line.mas_bottom).offset(14);
        make.bottom.equalTo(self.contentView).offset(-14);
    }]; 
}


- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.contentView.backgroundColor = [UIColor whiteColor];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}


#pragma mark textViewDelegate

#define  MAX_LIMIT_NUMS 30

- (void)textViewDidEndEditing:(UITextView *)textView {
    if ([textView isEqual:self.titleTextView]) {
        self.title = textView.text;
    } else if ([textView isEqual:self.contentTextView]) {
        self.remarks = textView.text;
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range
 replacementText:(NSString *)text
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    //获取高亮部分内容
    //NSString * selectedtext = [textView textInRange:selectedRange];
    
    //如果有高亮且当前字数开始位置小于最大限制时允许输入
    if (selectedRange && pos) {
        NSInteger startOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.start];
        NSInteger endOffset = [textView offsetFromPosition:textView.beginningOfDocument toPosition:selectedRange.end];
        NSRange offsetRange = NSMakeRange(startOffset, endOffset - startOffset);
        
        if (offsetRange.location < MAX_LIMIT_NUMS) {
            return YES;
        }
        else
        {
            return NO;
        }
    }
    
    
    NSString *comcatstr = [textView.text stringByReplacingCharactersInRange:range withString:text];
    
    NSInteger caninputlen = MAX_LIMIT_NUMS - comcatstr.length;
    
    if (caninputlen >= 0)
    {
        return YES;
    }
    else
    {
        NSInteger len = text.length + caninputlen;
        //防止当text.length + caninputlen < 0时，使得rg.length为一个非法最大正数出错
        NSRange rg = {0,MAX(len,0)};
        
        if (rg.length > 0)
        {
            NSString *s = @"";
            //判断是否只普通的字符或asc码(对于中文和表情返回NO)
            BOOL asc = [text canBeConvertedToEncoding:NSASCIIStringEncoding];
            if (asc) {
                s = [text substringWithRange:rg];//因为是ascii码直接取就可以了不会错
            }
            else
            {
                __block NSInteger idx = 0;
                __block NSString  *trimString = @"";//截取出的字串
                //使用字符串遍历，这个方法能准确知道每个emoji是占一个unicode还是两个
                [text enumerateSubstringsInRange:NSMakeRange(0, [text length])
                                         options:NSStringEnumerationByComposedCharacterSequences
                                      usingBlock: ^(NSString* substring, NSRange substringRange, NSRange enclosingRange, BOOL* stop) {
                                          
                                          if (idx >= rg.length) {
                                              *stop = YES; //取出所需要就break，提高效率
                                              return ;
                                          }
                                          
                                          trimString = [trimString stringByAppendingString:substring];
                                          
                                          idx++;
                                      }];
                
                s = trimString;
            }
            //rang是指从当前光标处进行替换处理(注意如果执行此句后面返回的是YES会触发didchange事件)
            [textView setText:[textView.text stringByReplacingCharactersInRange:range withString:s]];
            //既然是超出部分截取了，哪一定是最大限制了。
            self.countLabel.text = [NSString stringWithFormat:@"%d/%ld",0,(long)MAX_LIMIT_NUMS];
        }
        return NO;
    }
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    UITextRange *selectedRange = [textView markedTextRange];
    //获取高亮部分
    UITextPosition *pos = [textView positionFromPosition:selectedRange.start offset:0];
    
    //如果在变化中是高亮部分在变，就不要计算字符了
    if (selectedRange && pos) {
        return;
    }
    
    NSString  *nsTextContent = textView.text;
    NSInteger existTextNum = nsTextContent.length;
    
    if (existTextNum > MAX_LIMIT_NUMS)
    {
        //截取到最大位置的字符(由于超出截部分在should时被处理了所在这里这了提高效率不再判断)
        NSString *s = [nsTextContent substringToIndex:MAX_LIMIT_NUMS];
        
        [textView setText:s];
    }
    
    //不让显示负数 口口日
    self.countLabel.text = [NSString stringWithFormat:@"%ld/%d",MAX(0,MAX_LIMIT_NUMS - existTextNum),MAX_LIMIT_NUMS];
}



@end
