//
//  YIMEditerParagraphSpacingCell.h
//  yimediter
//
//  Created by ybz on 2017/12/2.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerStyleBaseCell.h"

/**段落行间距cell*/
@interface YIMEditerParagraphSpacingCell : YIMEditerStyleBaseCell

@property(nonatomic,assign)CGFloat spacingHeight;
@property(nonatomic,copy)void(^spacingChange)(CGFloat height);

@end
