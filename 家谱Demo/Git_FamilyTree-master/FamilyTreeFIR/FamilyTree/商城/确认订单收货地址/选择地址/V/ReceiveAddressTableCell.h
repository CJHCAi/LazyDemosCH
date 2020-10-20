//
//  ReceiveAddressTableCell.h
//  CheLian
//
//  Created by imac on 16/5/4.
//  Copyright © 2016年 imac. All rights reserved.
//


#import <UIKit/UIKit.h>

@protocol ReceiveAddressTableCellDelegate <NSObject>

- (void)editAddress:(UIButton *)sender;

@end

@interface ReceiveAddressTableCell : UITableViewCell
/**
 *  收货人姓名
 */
@property (strong,nonatomic) UILabel *nameLb;
/**
 *  地址
 */
@property (strong,nonatomic) UILabel *addressLb;
/**
 *  收货人手机
 */
@property (strong,nonatomic) UILabel *mobileLb;

/**
 *  编辑按钮
 */
@property (strong,nonatomic) UIButton *editBtn;

@property (weak,nonatomic) id<ReceiveAddressTableCellDelegate>delegate;
@end
