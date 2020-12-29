//
//  ChatCell.m
//  XMPP
//
//  Created by 纪洪波 on 15/11/19.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import "ChatCell.h"
#import "UIView+UIView_Frame.h"

#define KScreenWidth [[UIScreen mainScreen]bounds].size.width
#define KScreenHeight [[UIScreen mainScreen]bounds].size.height

@interface ChatCell()

@end

@implementation ChatCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userInteractionEnabled = NO;
    [self.outImage addSubview:self.outMessageLable];
    [self.inImage addSubview:self.inMessageLable];
    // Initialization code
}

- (void)updateFrameWithMessage:(NSString *)message {
    CGSize maxSize = CGSizeMake(240, MAXFLOAT);
    CGSize titleSize = [self labelAutoCalculateRectWith:message FontSize:17.0f MaxSize:maxSize];
    
    self.outImage.frame = CGRectMake(KScreenWidth - (titleSize.width + 25) - 5, 0, titleSize.width + 25, titleSize.height + 15);
    self.outMessageLable.numberOfLines = 0;
    self.outMessageLable.size = CGSizeMake(titleSize.width, titleSize.height);
    self.outMessageLable.center = CGPointMake(self.outImage.frame.size.width / 2 - 3, self.outImage.frame.size.height / 2);
    
    
    self.inImage.frame = CGRectMake(5, 0, titleSize.width + 25, titleSize.height + 15);
    self.inMessageLable.numberOfLines = 0;
    self.inMessageLable.size = CGSizeMake(titleSize.width, titleSize.height);
    self.inMessageLable.center = CGPointMake(self.inImage.frame.size.width / 2 + 3, self.inImage.frame.size.height / 2);
}


- (CGSize)labelAutoCalculateRectWith:(NSString*)text FontSize:(CGFloat)fontSize MaxSize:(CGSize)maxSize
{
    NSMutableParagraphStyle* paragraphStyle = [[NSMutableParagraphStyle alloc]init];
    paragraphStyle.lineBreakMode=NSLineBreakByWordWrapping;
    NSDictionary* attributes =@{NSFontAttributeName:[UIFont systemFontOfSize:fontSize],NSParagraphStyleAttributeName:paragraphStyle.copy};
    //如果系统为iOS7.0；
    CGSize labelSize;
    if (![text respondsToSelector:@selector(boundingRectWithSize:options:attributes:context:)]){
        labelSize = [text sizeWithFont:[UIFont systemFontOfSize:fontSize] constrainedToSize:maxSize lineBreakMode:NSLineBreakByWordWrapping];
    }
    //如果是IOS6.0
    else{
        labelSize = [text boundingRectWithSize: maxSize
                                       options: NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading|NSStringDrawingTruncatesLastVisibleLine
                                    attributes:attributes
                                       context:nil].size;
    }
    labelSize.height=ceil(labelSize.height);
    labelSize.width=ceil(labelSize.width);
    return labelSize;
}

+ (CGFloat)heightForText:(NSString *)text {
    CGRect bounds = [text boundingRectWithSize:CGSizeMake(240, MAXFLOAT) options:NSStringDrawingUsesLineFragmentOrigin attributes:[NSDictionary dictionaryWithObject:[UIFont systemFontOfSize:17] forKey:NSFontAttributeName] context:nil];
    return bounds.size.height + 25;
}



- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
