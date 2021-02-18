//
//  EditPersonalInfoDetailViewController.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/16.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditPersonalInfoDetailViewController;

@protocol EditPersonalInfoDetailViewControllerDelegate <NSObject>

-(void)EditPersonalInfoDetailViewController:(EditPersonalInfoDetailViewController *)editVC withTitle:(NSString *)title withDetail:(NSString *)detail;

@end

@interface EditPersonalInfoDetailViewController : UIViewController
/** 更改哪项内容*/
@property (nonatomic, copy) NSString *detailStr;
/** 文本框内容*/
@property (nonatomic, copy) NSString *TFStr;
/** 代理人*/
@property (nonatomic, weak) id<EditPersonalInfoDetailViewControllerDelegate> delegate;

@end
