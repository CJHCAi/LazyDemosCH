//
//  WFamilyTableViewCell.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/6.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
/** 左右头像两种图 */
typedef enum : NSUInteger {
    FamilyCellImageTypeLeft,
    FamilyCellImageTypeRight,
} FamilyCellImageType;

@interface WFamilyTableViewCell : UITableViewCell
/**cell名字*/
@property (nonatomic,strong) UILabel *famNameLabel;
/**cell人物头像*/
@property (nonatomic,strong) UIImageView *famImageView;
/**cell简介*/
@property (nonatomic,strong) UITextView *famIntroLabel;
/**自己的genmeID*/
@property (nonatomic,copy) NSString *myGemid;

@property (nonatomic,assign) FamilyCellImageType famCellType; /*左右类型*/

-(void)changeCellStyle;

@end
