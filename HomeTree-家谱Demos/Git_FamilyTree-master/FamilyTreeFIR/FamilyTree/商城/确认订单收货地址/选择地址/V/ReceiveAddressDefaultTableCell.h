//
//  ReceiveAddressDefaultTableCell.h
//  CheLian
//
//  Created by imac on 16/5/28.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ReceiveAddressDefaultTableCellDelegate <NSObject>

- (void)editAddress:(UIButton*)sender;

@end

@interface ReceiveAddressDefaultTableCell : UITableViewCell
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
 *  默认勾选
 */
@property (strong,nonatomic) UIImageView *headIV;
/**
 *  编辑按钮
 */
@property (strong,nonatomic) UIButton *editBtn;

@property (weak,nonatomic) id<ReceiveAddressDefaultTableCellDelegate>delegate;

@end
