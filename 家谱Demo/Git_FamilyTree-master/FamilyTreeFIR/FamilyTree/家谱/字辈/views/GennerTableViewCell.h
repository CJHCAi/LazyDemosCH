//
//  GennerTableViewCell.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/12.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PortraiView.h"
@interface GennerTableViewCell : UITableViewCell
@property (nonatomic,copy) NSArray *nameArr; /*名字*/
@property (nonatomic,copy) NSArray *idArr; /*身份父亲母亲*/
@property (nonatomic,copy) NSArray *proImageUrlArr; /*头像*/
/**成员idArr*/
@property (nonatomic,copy) NSArray *genIdArr;

@property (nonatomic,strong) UILabel *generNumber; /*第几代*/
@property (nonatomic,strong) UILabel *personNumber; /*几个人*/
@property (nonatomic,strong) UILabel *perName; /*字辈*/

-(void)initPorInfo;

@end
