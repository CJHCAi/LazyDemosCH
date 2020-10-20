//
//  ExpandTableViewCell.h
//  ExpandFrameModel
//
//  Created by 栗子 on 2017/12/8.
//  Copyright © 2017年 http://www.cnblogs.com/Lrx-lizi/. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ListFrameModel;

@interface ExpandTableViewCell : UITableViewCell

@property (nonatomic,strong)ListFrameModel *frameModel;
@property (nonatomic, strong) UILabel       *questionLB;
@property (nonatomic, strong) UILabel       *answerLB;
@property (nonatomic, strong) UIImageView   *arrowIV;
@property (nonatomic, strong) UIView        *line;
@property (nonatomic, strong) UIView        *line1;


@end
