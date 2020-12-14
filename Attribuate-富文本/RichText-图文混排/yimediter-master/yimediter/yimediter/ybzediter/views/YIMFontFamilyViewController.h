//
//  YIMFontFamilyViewController.h
//  yimediter
//
//  Created by ybz on 2017/11/25.
//  Copyright © 2017年 ybz. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YIMEditerFontFamilyManager.h"

/**字体选择控制器*/
@interface YIMFontFamilyViewController : UIViewController


/** 选择字体后执行的块 */
@property(nonatomic,copy)void(^completeSelect)(NSString*fontName);

@end
