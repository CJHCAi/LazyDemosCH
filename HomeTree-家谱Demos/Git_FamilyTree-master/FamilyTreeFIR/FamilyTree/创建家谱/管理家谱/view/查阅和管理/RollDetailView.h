//
//  RollDetailView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/15.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RollDetailView : UIView
@property (nonatomic,strong) UIImageView *headImageView; /*头像*/
@property (nonatomic,strong) UILabel *nameLabel; /*名字*/
@property (nonatomic,strong) UILabel *genLabel; /*代数*/
@property (nonatomic,copy) NSArray *leftArr; /*左边数据*/
@property (nonatomic,copy) NSArray *rightArr; /*左边数据*/
/**成员ID*/
@property (nonatomic,copy) NSString *myMemberID;


- (instancetype)initWithFrame:(CGRect)frame leftViewDataArr:(NSArray *)leftArr rightViewDataArr:(NSArray *)rightArr;

@end
