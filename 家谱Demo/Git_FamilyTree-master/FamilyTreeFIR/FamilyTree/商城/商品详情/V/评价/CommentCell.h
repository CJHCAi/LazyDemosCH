//
//  CommentCell.h
//  ListV
//
//  Created by imac on 16/7/22.
//  Copyright © 2016年 imac. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "StarView.h"

@interface CommentCell : UITableViewCell
/**
 *  头像
 */
@property (strong,nonatomic) UIImageView *headIV;
/**
 *  账号名
 */
@property (strong,nonatomic) UILabel *nameLb;

@property (strong,nonatomic) StarView *StarV;
/**
 *  日期
 */
@property (strong,nonatomic) UILabel *timeLb;
/**
 *  评价文本
 */
@property (strong,nonatomic) UILabel *descLb;
/**
 *  商品型号信息
 */
@property (strong,nonatomic) UILabel *infoLb;
/**
 *  用户上传照片
 */
#warning 接口数据没有图片暂时不加
@property (strong,nonatomic) UIImageView *goodImgV;

-(void)updateFrame;

@end
