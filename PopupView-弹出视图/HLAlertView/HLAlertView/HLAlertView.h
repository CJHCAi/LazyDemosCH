//
//  HLAlertView.h
//  HLAlertView
//
//  Created by benjaminlmz@qq.com on 2020/4/29.
//  Copyright © 2020 Tony. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HLAlertModel.h"
#import "HLLabel.h"
#import "HLAction.h"
#import "HLTextField.h"
#import "HLImageView.h"
#import "HLButton.h"
#import "HMLabel.h"
NS_ASSUME_NONNULL_BEGIN

@interface HLAlertView : UIView
@property (nonatomic,assign)BOOL shadowAction;

+ (id)alertWithTitle:(nullable NSString *)title message:(nullable NSString *)message;
+ (void)show;
+ (void)dismiss;
- (void)addLabel:(id)label;
- (void)addAciton:(HLAction *)action;

- (void)addButton:(id)object;
- (void)addImageView:(HLImageView *)imageView;
- (void)addTextFieldWithConfigurationHandler:(void (^ __nullable)(HLTextField *textField))configurationHandler;

- (void)alertSize:(CGSize)size;
@property (nonatomic, readonly) NSArray<HLAction *> *actions;

@end

NS_ASSUME_NONNULL_END
