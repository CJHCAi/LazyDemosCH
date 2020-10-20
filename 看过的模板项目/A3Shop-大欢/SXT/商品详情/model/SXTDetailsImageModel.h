//
//  SXTDetailsImageModel.h
//  SXT
//
//  Created by 赵金鹏 on 16/8/23.
//  Copyright © 2016年 赵金鹏. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface SXTDetailsImageModel : NSObject

/**图片地址*/
@property (copy, nonatomic) NSString *ImgView;

/**图片名称*/
@property (copy, nonatomic) NSString *ImgType;

/**图片尺寸*/
@property (copy, nonatomic) NSString *Resolution;

@end
