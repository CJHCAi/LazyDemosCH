//
//  EditPersonalInfoTableViewCell.h
//  FamilyTree
//
//  Created by 姚珉 on 16/6/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, EditPersonalInfoTableViewCellCustomStyle){
    EditPersonalInfoTableViewCellStyleNone,
    EditPersonalInfoTableViewCellStyleEdit,
    EditPersonalInfoTableViewCellStyleArrow,
};

@class EditPersonalInfoTableViewCell;

@protocol EditPersonalInfoTableViewCellDelegate <NSObject>
-(void)respondToEditBtn:(UIButton *)sender;
-(void)respondToPullDownBtn:(UIButton *)sender;

@end

@interface EditPersonalInfoTableViewCell : UITableViewCell

/** 代理人*/
@property (nonatomic, weak) id<EditPersonalInfoTableViewCellDelegate> delegate;

/** 标题*/
@property (nonatomic, strong) UILabel *customTitleLB;
/** 详细信息*/
@property (nonatomic, strong) UILabel *customDetailLB;
/** 虚线*/
@property (nonatomic, strong) UILabel *dashLineLB;
/** 更改按钮*/
@property (nonatomic, strong) UIButton *editBtn;

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier WithCustomStyle:(EditPersonalInfoTableViewCellCustomStyle)EditPersonalInfoTableViewCellCustomStyle;
@end
