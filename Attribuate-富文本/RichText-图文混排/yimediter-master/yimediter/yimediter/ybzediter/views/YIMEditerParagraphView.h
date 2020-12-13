//
//  YIMEditerParagraphView.h
//  yimediter
//
//  Created by ybz on 2017/11/30.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import "YIMEditerView.h"
#import "YIMEditerProtocol.h"
#import "YIMEditerParagraphStyle.h"

@class YIMEditerParagraphView;

@protocol YIMEditerParagraphViewDelegate <NSObject>
@required
/**当段落样式改变时*/
-(void)paragraphView:(YIMEditerParagraphView*)fontView styleDidChange:(YIMEditerParagraphStyle*)style;
@end

@interface YIMEditerParagraphView : YIMEditerView <YIMEditerStyleChangeObject>

@property(nonatomic,strong)YIMEditerParagraphStyle *paragraphStyle;


@end
