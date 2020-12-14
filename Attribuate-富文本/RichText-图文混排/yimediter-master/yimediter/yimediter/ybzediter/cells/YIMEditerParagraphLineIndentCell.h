//
//  YIMEditerParagraphLineIndentCell.h
//  yimediter
//
//  Created by ybz on 2017/12/2.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerStyleBaseCell.h"

/**行缩进的cell*/
@interface YIMEditerParagraphLineIndentCell : YIMEditerStyleBaseCell

@property(nonatomic,assign)BOOL isRightTab;
@property(nonatomic,copy)void(^lineIndentChange)(BOOL isLineIndent);


@end
