//
//  HLLabel.m
//  HLAlertView
//
//  Created by 梁明哲 on 2020/5/4.
//  Copyright © 2020 Tony. All rights reserved.
//

#import "HLLabel.h"

@interface HLLabel()
@property (nonatomic ,copy)NSString *title;
@property (nonatomic ,strong) Constraint *constraint;
@property (nonatomic ,strong) HLLabelModel *labelModel;
@property (nonatomic,strong)  UILabel *label;



@end
@implementation HLLabel

- (id)init {
    self = [super init];
    if (self) {
        self.label = [[UILabel alloc] init];
        self.labelModel = [[HLLabelModel alloc] init];
        self.constraint = [[Constraint alloc] init];
    }
    return self;
}


+ (instancetype)labelWithTitle:(NSString *)title block:(void(^)(Constraint *,HLLabelModel *))block {
    HLLabel *object = [[HLLabel alloc] init];
    object.title = title;
    object.label.text = title;
    object.label.textColor = [UIColor blackColor];
    object.label.numberOfLines = 0;
    object.label.font = [UIFont systemFontOfSize:13.0f];
    object.label.textAlignment = NSTextAlignmentCenter;
    [object.label setTranslatesAutoresizingMaskIntoConstraints:NO];
    block(object.constraint,object.labelModel);
    
    return object;
}
- (void)hide:(BOOL)state {
    [self.label setHidden:state];
}

//获取文字高度
+ (CGFloat)getHightWithText:(NSString *)text andWidth:(CGFloat)textWidth font:(UIFont *)font withFontOfSize:(CGFloat)size {
    
    CGRect rect = [text boundingRectWithSize:CGSizeMake(textWidth, 10000) options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:[UIFont fontWithName:font.fontName size:font.pointSize + 0.2]} context:nil];
    
    return rect.size.height;
}
@end
