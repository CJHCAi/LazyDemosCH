//
//  YIMEditerTextFontCell.h
//  yimediter
//
//  Created by ybz on 2017/11/22.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerStyleBaseCell.h"
#import "YIMEditerTextStyle.h"

/**字体大小cell*/
@interface YIMEditerTextFontSizeCell : YIMEditerStyleBaseCell

/**获取或设置当前选择的字体*/
@property(nonatomic,assign)NSInteger fontSize;
/**选择字体发生改变时执行的block*/
@property(nonatomic,copy)void(^fontSizeChangeBlock)(NSInteger fontSize);

@end
