//
//  WSearchViewCell.h
//  FamilyTree
//
//  Created by 王子豪 on 16/7/13.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WSearchViewCell : UITableViewCell
/**头像*/
@property (nonatomic,strong) UIImageView *portraitView;
/**家谱名*/
@property (nonatomic,strong) UILabel *famName;
/**家谱id*/
@property (nonatomic,copy) NSString *famId;
@end
