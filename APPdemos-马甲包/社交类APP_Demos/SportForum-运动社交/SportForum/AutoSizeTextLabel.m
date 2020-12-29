//
//  AutoSizeTextLabel.m
//  SportForum
//
//  Created by zhengying on 6/16/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import "AutoSizeTextLabel.h"

@implementation AutoSizeTextLabel {
    CGFloat _fontSizeMin;
    CGFloat _fontSizeNormal;
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Initialization code
        _fontSizeMin = 8;
        _fontSizeNormal = 30;
        self.edgeInsets = UIEdgeInsetsMake(5, 10, 5, 10);
        self.textAlignment = NSTextAlignmentCenter;
        self.lineBreakMode = NSLineBreakByTruncatingTail;
        self.numberOfLines = 0;
    }
    return self;
}


-(void)setText:(NSString *)text {
    [super setText:text];
    [self reLayoutText];
}


-(void)reLayoutText {
    NSString* content = @"";

    if (self.text == nil ||
        [(content = [self.text stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]])
         isEqualToString:@""]) {
        return;
    }
    CGRect selfRealFrame = UIEdgeInsetsInsetRect(self.frame, _edgeInsets);
    
    CGSize constraint = CGSizeMake(self.frame.size.width - self.edgeInsets.left - self.edgeInsets.right  , 20000.0f);
    
    CGSize tmpSize;
    UIFont* tmpFont = [self.font fontWithSize:_fontSizeNormal];
    
    do {
          //tmpSize = [content sizeWithFont:tmpFont constrainedToSize:constraint lineBreakMode:NSLineBreakByWordWrapping];
        
        NSStringDrawingOptions options =  NSStringDrawingUsesLineFragmentOrigin | NSStringDrawingUsesFontLeading;
        tmpSize = [content boundingRectWithSize:constraint
                                                           options:options
                                                        attributes:@{NSFontAttributeName:tmpFont} context:nil].size;
        
        if (tmpSize.height <= selfRealFrame.size.height || tmpFont.pointSize <= _fontSizeMin) {
            break;
        }
          
          tmpFont = [tmpFont fontWithSize:tmpFont.pointSize-1.0];
        
    } while (tmpSize.height >= selfRealFrame.size.height && tmpFont.pointSize >= _fontSizeMin);
    
    if (content.length > 20 && tmpFont.pointSize > 20) {
        NSLog(@"Here!!");
    }
    
    self.font = tmpFont;
}

- (void)drawTextInRect:(CGRect)rect {
    [super drawTextInRect:UIEdgeInsetsInsetRect(rect, self.edgeInsets)];
}

@end
