//
//  HK_EnterpriseCertificationCell.h
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/11.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HK_FormModel.h"
#import "HK_TextFieldFormModel.h"
#import "HK_SeclectFormModel.h"
#import "HK_LogoFormModel.h"
#import "HK_UnableModifyFormModel.h"
#import "HK_TextViewFormModel.h"
@protocol HK_FormCellDelegate <NSObject>

@optional
-(void)contentStartEditBlock:(CGRect)frameToView;

@end
@interface HK_FormCell : UITableViewCell
@property (nonatomic, strong) HK_FormModel *formModel;  //表单数据
@property (nonatomic,weak) id<HK_FormCellDelegate> delegate;

@end
