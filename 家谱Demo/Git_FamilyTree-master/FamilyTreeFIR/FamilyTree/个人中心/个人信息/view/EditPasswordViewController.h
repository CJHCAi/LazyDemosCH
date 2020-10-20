//
//  EditPasswordViewController.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/23.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class EditPasswordViewController;

@interface EditPasswordViewController : UIViewController
/** 更改哪项内容*/
@property (nonatomic, copy) NSString *detailStr;
/** 文本框内容*/
@property (nonatomic, copy) NSString *TFStr;


@end
