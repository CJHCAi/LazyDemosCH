//
//  ModifyAddresstableViewCell.h
//  CheLian
//
//  Created by imac on 16/5/27.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ModifyAddresstableViewCell : UITableViewCell
/**
 *  类型显示
 */
@property (strong,nonatomic) UILabel *titleLb;
/**
 *  信息显示
 */
@property (strong,nonatomic) UITextField *detailTV;
/**
 *  选择是否为默认地址
 */
@property (strong,nonatomic) UIImageView *chooseIV;

@property (strong,nonatomic) UITextView *addressTF;
@end
