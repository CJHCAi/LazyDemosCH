//
//  DLMaxLinkTextField.h
//  DownLoadTest
//
//  Created by 李五民 on 15/10/25.
//  Copyright © 2015年 李五民. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DLMaxLinkTextFieldView : UIView

@property (nonatomic, copy) void (^linkNumberBlock)(NSUInteger number ,BOOL bToast);
- (void)configTextFieldWithMaxNum:(NSUInteger)maxNum;
- (void)setText:(NSString *)text;

@end
