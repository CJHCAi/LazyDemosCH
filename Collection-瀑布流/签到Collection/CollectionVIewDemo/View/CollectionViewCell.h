//
//  CollectionViewCell.h
//  CollectionVIewDemo
//
//  Created by 栗子 on 2017/12/13.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "CollectionModel.h"

@interface CollectionViewCell : UICollectionViewCell
/*任务图片*/
@property (nonatomic, strong) UIImageView *iconIV;
/*线圈*/
@property (nonatomic, strong) UIImageView *iconBorder;
/*任务名称*/
@property (nonatomic, strong) UILabel *nameLB;
/*进行中*/
@property (nonatomic, strong) UILabel *progressLB;
//上线
@property (nonatomic, strong) UIView *topLine;
//下线
@property (nonatomic, strong) UIView *downLine;
//左线
@property (nonatomic, strong) UIView *leftLine;
//右线
@property (nonatomic, strong) UIView *rightLine;
-(void)cellIndexPathRow:(NSInteger)row rowCount:(NSInteger)count;
@property(nonatomic,strong)CollectionModel *dataModel;
@property(nonatomic,strong)CollectionModel *statueModel;

@end
