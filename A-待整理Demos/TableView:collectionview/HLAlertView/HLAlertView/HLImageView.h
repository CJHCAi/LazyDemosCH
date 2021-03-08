//
//  HLImageView.h
//  HLAlertView
//
//  Created by benjaminlmz@qq.com on 2020/5/7.
//  Copyright © 2020 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLAlertModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLImageView : NSObject

+ (instancetype)imageViewWithImage:(UIImage *)image block:(void(^)(Constraint *constraint,HLImageViewModel * imageModel))block;
@end

NS_ASSUME_NONNULL_END
