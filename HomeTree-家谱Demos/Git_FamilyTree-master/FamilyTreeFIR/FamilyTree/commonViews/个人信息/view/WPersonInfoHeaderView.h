//
//  WPersonInfoHeaderView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/21.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WPersonInfoHeaderView : UIView
/**头像*/
@property (nonatomic,strong) UIImageView *headImage;
/**名字*/
@property (nonatomic,strong) UILabel *nameLabel;
/**性别*/
@property (nonatomic,strong) UIImageView *sexImage;
/**学历*/
@property (nonatomic,strong) UILabel *eduLabel;
/**职业*/
@property (nonatomic,strong) UILabel *jobLabel;
/**爱好*/
@property (nonatomic,strong) UILabel *intertsLabel;
/**个人签名*/
@property (nonatomic,strong) UILabel *signatureLabel;
/**时间*/
@property (nonatomic,strong) UILabel *timeLabel;
/**关注*/
@property (nonatomic,strong) UIButton *focusBtn;





@end
