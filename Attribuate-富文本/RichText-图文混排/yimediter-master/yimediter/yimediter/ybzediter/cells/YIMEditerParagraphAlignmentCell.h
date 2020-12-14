//
//  YIMEditerParagraphAlignmentCell.h
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerStyleBaseCell.h"

/**段落对齐方式cell*/
@interface YIMEditerParagraphAlignmentCell : YIMEditerStyleBaseCell

@property(nonatomic,assign)NSTextAlignment currentTextAlignment;
@property(nonatomic,copy)void(^alignmentChangeBlock)(NSTextAlignment alignment);

@end
