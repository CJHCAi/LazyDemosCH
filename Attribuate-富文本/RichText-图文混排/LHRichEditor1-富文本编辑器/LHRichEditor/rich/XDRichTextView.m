//
//  XDRichTextView.m
//  XDZHBook
//
//  Created by 刘昊 on 2018/4/21.
//  Copyright © 2018年 刘昊. All rights reserved.
//

#import "XDRichTextView.h"
#import "XDRichTextModel.h"
#define kAppFrameWidth      [[UIScreen mainScreen] bounds].size.width
#define kAppFrameHeight     [[UIScreen mainScreen] bounds].size.height
#define UIColorFromRGB(rgbValue) [UIColor \
colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0xFF00) >> 8))/255.0 \
blue:((float)(rgbValue & 0xFF))/255.0 alpha:1.0]
@interface XDRichTextView()
@property (nonatomic ,strong) XDRichTextModel *model;
@property (nonatomic,strong) NSMutableArray * dataArr;
@property (nonatomic,assign) NSInteger index;
@end

@implementation XDRichTextView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        [self initData];
        [self setUI];
        self.showsVerticalScrollIndicator = NO;
        _color = UIColorFromRGB(0x333333);

    }
    return self;
}

- (void)initData{
    
    _NextFont = (15);
    
}

- (void)setUI{
    _index = 0;
    _dataArr = [NSMutableArray array];
}


- (void)setBold:(BOOL)Bold{
    _Bold = Bold;
}

- (void)setOblique:(BOOL)Oblique{
    _Oblique = Oblique;
}

- (void)setUnderLine:(BOOL)UnderLine{
    _UnderLine = UnderLine;
}

- (void)setNextFont:(CGFloat)NextFont{
    _NextFont =NextFont;
}

- (void)setColor:(UIColor *)color{
    _color = color;
}
- (void)setStyle{
    [self setInitLocation];
    if (_isDelete) {
        return;
    }
    NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineSpacing = 5;// 字体的行间距
    NSDictionary *attributes = @{
                                 NSParagraphStyleAttributeName:paragraphStyle,
                                 NSForegroundColorAttributeName:_color,
                                 NSStrokeWidthAttributeName:(_Bold?@-3:@0),
                                 NSObliquenessAttributeName :(_Oblique?@0.3:@0),//斜体
                                 NSUnderlineStyleAttributeName:(_UnderLine?@1:@0), // 下划线
                                 NSUnderlineColorAttributeName:_color,  // 下划线颜色
                                 NSFontAttributeName :[UIFont systemFontOfSize:_NextFont]
                                 };
    NSAttributedString * replaceStr=[[NSAttributedString alloc] initWithString:self.newstr attributes:attributes                                                  ];
    [self.locationStr replaceCharactersInRange:self.newRange withAttributedString:replaceStr];
    self.attributedText = self.locationStr;
    self.selectedRange  = NSMakeRange(self.newRange.location+self.newRange.length, 0);
    [self scrollRangeToVisible: self.selectedRange ];
    //这里需要把光标的位置重新设定
   
}


//撤销
- (void)undo{
    if (_index <= 0) {
        return;
    }
    _index--;
    self.attributedText = _dataArr[_index];
}

//恢复
- (void)redo{
   
    if (_index >= _dataArr.count - 1 || _dataArr.count == 0) {
        return;
    }
    _index ++;
    self.attributedText = _dataArr[_index];
}



-(void)setInitLocation
{
    self.locationStr=nil;
    self.locationStr=[[NSMutableAttributedString alloc]initWithAttributedString:self.attributedText];
    _index ++;
    [_dataArr addObject:self.locationStr];

}

- (void)setAttributedText:(NSAttributedString *)attributedText{
    [super setAttributedText:attributedText];
}

//插入图片
- (void)addImage:(UIImage *)image{
    CGSize  imgSize = image.size;
    CGFloat newImgW = imgSize.width;
    CGFloat newImgH = imgSize.height;
    CGFloat textW   = kAppFrameWidth - (30);
    if (newImgW > textW) {
        CGFloat ratio = textW / newImgW;
        newImgW  = textW;
        newImgH *= ratio;
    }
    NSAttributedString *enterStr = [[NSAttributedString alloc] initWithString:@"\n"];
    // 前文
    NSMutableAttributedString *bfStr = [[NSMutableAttributedString alloc] initWithAttributedString:self.attributedText];
    /*---------------添加内容 start-----------------*/
    // 转换图片
    NSTextAttachment *attachment = [[NSTextAttachment alloc]initWithData:nil ofType:nil];
    attachment.image = image;
    attachment.bounds = CGRectMake(0, 0, newImgW, newImgH);
    NSAttributedString *text = [NSAttributedString attributedStringWithAttachment:attachment];
    NSMutableAttributedString *imageText = [[NSMutableAttributedString alloc] initWithAttributedString:text];
    // 前文换行
    [imageText insertAttributedString:enterStr atIndex:0];
    /*---------------添加内容 end-----------------*/
    // 前文拼接图片
    // 换行
    [imageText insertAttributedString:enterStr atIndex:imageText.length];
    [bfStr insertAttributedString:imageText atIndex:bfStr.length];
//    // 拼接转换后的attributeStirng
    [bfStr insertAttributedString:enterStr atIndex:bfStr.length];
    NSMutableAttributedString *newAtt = [[NSMutableAttributedString alloc]init];
    [newAtt setAttributedString:bfStr];
    self.attributedText = newAtt;
    [self becomeFirstResponder];
    [self setInitLocation];
}

- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event {
    
  UIView *view = [super hitTest:point withEvent:event];
    if (_block) {
        _block();
    }
    return view;
}
- (void)setIsDelete:(BOOL)isDelete{
    _isDelete = isDelete;
}

@end
