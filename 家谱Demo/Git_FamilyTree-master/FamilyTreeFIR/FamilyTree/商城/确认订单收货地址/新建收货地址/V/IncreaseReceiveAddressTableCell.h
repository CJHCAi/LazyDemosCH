//
//  IncreaseReceiveAddressTableCell.h
//  CheLian
//
//  Created by 姚珉 on 16/5/19.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface IncreaseReceiveAddressTableCell : UITableViewCell
/** 文本标签*/
@property (nonatomic, strong) UILabel *label;
/** 输入框*/
@property (nonatomic, strong) UITextField *textField;

@property (strong,nonatomic) UIImageView *chooseIV;

@property (strong,nonatomic) UITextView *addressTF;
@end
