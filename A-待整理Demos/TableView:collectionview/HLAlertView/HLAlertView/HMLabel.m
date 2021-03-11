//
//  HMLabel.m
//  HLAlertView
//
//  Created by benjaminlmz@qq.com on 2020/5/9.
//  Copyright © 2020 Tony. All rights reserved.
//

#import "HMLabel.h"

@interface HMLabel()
@property (nonatomic,strong) UITextView *textView;
@property (nonatomic ,strong) Constraint *constraint;
@property (nonatomic ,strong) HLTextModel *textModel;
@end
@implementation HMLabel
- (id)init {
    self = [super init];
    if (self) {
        self.textView = [[UITextView alloc] init];
        self.textModel = [[HLTextModel alloc] init];
        self.constraint = [[Constraint alloc] init];
    }
    return self;
}

+ (instancetype)labelWithTitle:(NSString *)title block:(void(^)(Constraint *,HLTextModel *))block {
    if (title == nil) {
        return nil;
    }
    HMLabel *object = [[HMLabel alloc] init];
    object.textView.text = title;
    object.title = title;
    object.textView.editable = NO;
    object.textView.selectable = NO;
    object.textView.showsVerticalScrollIndicator = NO;
    object.textView.showsHorizontalScrollIndicator = NO;
    [object.textView setTranslatesAutoresizingMaskIntoConstraints:NO];
    block(object.constraint,object.textModel);
    return object;
}


- (void)setTitle:(NSString * _Nonnull)title {
    self.textView.text = title;
    _title = title;
}


//获取文字高度
+ (CGFloat)getHightWithText:(NSString *)text andWidth:(CGFloat)textWidth font:(UIFont *)font withFontOfSize:(CGFloat)size {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:font.fontName size:font.pointSize + 0.2]} context:nil];
    
    return rect.size.height;
}
@end
