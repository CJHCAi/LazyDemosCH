//
//  CXSearchCollectionViewCell.m
//  CXShearchBar_Example
//
//  Created by caixiang on 2019/4/29.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import "CXSearchCollectionViewCell.h"
#import "CXSearchViewController.h"

@interface CXSearchCollectionViewCell()

@property (weak, nonatomic) IBOutlet UIView *backView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@end

@implementation CXSearchCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.backView.layer setCornerRadius:12.0];
    [self.backView setBackgroundColor:[UIColor colorWithWhite:0.957 alpha:1.000]];
}

- (void)setText:(NSString *)text {
    _text = text;
    self.nameLabel.text = text;
}

+ (CGSize)getSizeWithText:(NSString*)text {
    NSMutableParagraphStyle* style = [[NSMutableParagraphStyle alloc] init];
    style.lineBreakMode = NSLineBreakByCharWrapping;
    CGSize size = [text boundingRectWithSize:CGSizeMake(CGFLOAT_MAX, 24) options: NSStringDrawingUsesLineFragmentOrigin   attributes:@{NSFontAttributeName:[UIFont systemFontOfSize:13.0f],NSParagraphStyleAttributeName:style} context:nil].size;
    if (size.width + 2*8 >= [UIScreen mainScreen].bounds.size.width - 2 *kFirstitemleftSpace) {
        size.width = [UIScreen mainScreen].bounds.size.width - 2 *kFirstitemleftSpace - 2*8.f;
    }
    return CGSizeMake(ceilf(size.width+2*8), 24);
}

@end
