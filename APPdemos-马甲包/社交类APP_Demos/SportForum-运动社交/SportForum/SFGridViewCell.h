//
//  SFGridViewCell.h
//  SportForum
//
//  Created by zhengying on 6/9/14.
//  Copyright (c) 2014 zhengying. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SFGridMainViewCell : UITableViewCell
@property(nonatomic, assign) NSString * strDirection;
@end

@interface SFGridViewCell : UIButton
@property(nonatomic, assign) NSInteger rowIndex;
@property(nonatomic, assign) NSInteger colIndex;
//@property(nonatomic, strong) UIView* contentView;
@end
