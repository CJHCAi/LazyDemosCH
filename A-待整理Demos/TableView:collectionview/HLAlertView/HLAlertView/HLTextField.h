//
//  HLTextField.h
//  HLAlertView
//
//  Created by benjaminlmz@qq.com on 2020/5/6.
//  Copyright © 2020 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLAlertModel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLTextField : UITextField
@property (nonatomic ,strong) HLAlertModel *model;
@end

NS_ASSUME_NONNULL_END
