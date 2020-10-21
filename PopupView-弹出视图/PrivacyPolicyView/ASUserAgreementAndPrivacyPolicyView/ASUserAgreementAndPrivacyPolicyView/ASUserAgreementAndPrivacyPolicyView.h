//
//  ASUserAgreementAndPrivacyPolicyView.h
//  ASUserAgreementAndPrivacyPolicyView
//
//  Created by Mac on 2020/1/5.
//  Copyright © 2020 Mac. All rights reserved.
//

// 用户协议和隐私政策

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ASUserAgreementAndPrivacyPolicyView : UIView

+ (instancetype)showUserAgreementAndPrivacyPolicyViewIsAgreeOperation:(void(^)(BOOL isAgree))isAgreeOperation;

@end

NS_ASSUME_NONNULL_END
