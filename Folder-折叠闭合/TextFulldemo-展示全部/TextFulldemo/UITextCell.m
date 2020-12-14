//
//  UITextCell.m
//  TextFulldemo
//
//  Created by 刘昊 on 17/10/17.
//  Copyright © 2017年 刘昊. All rights reserved.
//

#import "UITextCell.h"
#import "YYText.h"

//#import "NSAttributedString+YYText.h"
//#import "YYLabel.h"

#define kAppFrameWidth      [[UIScreen mainScreen] bounds].size.width
#define kAppFrameHeight     [[UIScreen mainScreen] bounds].size.height
//随机色
#define HWColor(r, g, b) [UIColor colorWithRed:(r)/255.0 green:(g)/255.0 blue:(b)/255.0 alpha:1.0]
#define kRandomColor HWColor(arc4random_uniform(256), arc4random_uniform(256), arc4random_uniform(256))


@interface UITextCell(){
    UILabel *_fillLab;
}
@property (nonatomic, strong)   YYLabel *label;
@end
@implementation UITextCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initData];
        [self layoutView];
        self.backgroundColor = kRandomColor;
        
    }
    return self;
}

- (void)initData{
    
}

- (void)layoutView{
    _label = [YYLabel new];
    _label.userInteractionEnabled =YES;
    _label.numberOfLines =3;
    _label.backgroundColor = kRandomColor;
    _label.textVerticalAlignment =YYTextVerticalAlignmentTop;
    [self addSubview:_label];
    
    _fillLab = [UILabel new];
    _fillLab.backgroundColor = kRandomColor;
    [self addSubview:_fillLab];
    
}
- (void)layoutSubviews{
    [super layoutSubviews];
    _label.frame = CGRectMake(15, 15, kAppFrameWidth -30, self.frame.size.height - 30);
}

-(void)setIsFill:(BOOL)isFill{
    _isFill = isFill;
}

- (void)reloadData:(NSString *)data{
    if (_isFill) {
        _fillLab.numberOfLines = 0;
        _fillLab.text =data;
        _fillLab.font =  [UIFont systemFontOfSize:15];
        _fillLab.frame = CGRectMake(15, 15, kAppFrameWidth -30, [self heightWithFont:15 limitWidth:kAppFrameWidth -30 string:data]);
        _label.hidden = YES;
    }else{
        NSMutableAttributedString *text = [NSMutableAttributedString new];
        UIFont *font = [UIFont systemFontOfSize:15];
        [text appendAttributedString:[[NSAttributedString alloc] initWithString:data attributes:nil]];
        text.yy_font = font ;
        _label.attributedText = text;
        [self addSeeMoreButton];
    }
    
  
}


- (void)addSeeMoreButton {
    
    __weak typeof(self) _self = self;
    NSMutableAttributedString *text = [[NSMutableAttributedString alloc] initWithString:@"...展开全部"];
      //文本的高亮事件
    YYTextHighlight *hi = [YYTextHighlight new];
    [hi setColor:[UIColor colorWithRed:0.578 green:0.790 blue:1.000 alpha:1.000]];
    hi.tapAction = ^(UIView *containerView,NSAttributedString *text,NSRange range, CGRect rect) {
        _label.numberOfLines =0;
        YYLabel *label = _self.label;
        [label sizeToFit];
        _label.frame = CGRectMake(15,15,kAppFrameWidth -30,label.frame.size.height);
        
        NSDictionary *dic = @{@"tag":@(self.tag),@"height":@(label.frame.size.height)};
        [[NSNotificationCenter defaultCenter] postNotificationName:@"tag" object:dic];
        
    };
    
    [text yy_setColor:[UIColor colorWithRed:0.000 green:0.449 blue:1.000 alpha:1.000] range:[text.string rangeOfString:@"展开全部"]];
    //文本添加事件
    [text yy_setTextHighlight: hi range:[text.string rangeOfString:@"展开全部"]];
    text.yy_font =_label.font;
    
    YYLabel *seeMore = [YYLabel new];
    seeMore.attributedText = text;
    [seeMore sizeToFit];
    NSAttributedString *truncationToken = [NSAttributedString yy_attachmentStringWithContent:seeMore contentMode:UIViewContentModeCenter attachmentSize: text.size  alignToFont:text.yy_font alignment:YYTextVerticalAlignmentCenter];
    _label.truncationToken = truncationToken;
    
}


- (float)heightWithFont:(float)font limitWidth:(float)width string:(NSString *)str{
    NSDictionary *attribute = @{NSFontAttributeName: [UIFont systemFontOfSize:font]};
    CGSize size = [str boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX)
                                    options:NSStringDrawingUsesLineFragmentOrigin
                                 attributes:attribute
                                    context:nil].size;
    return size.height;
}


@end
