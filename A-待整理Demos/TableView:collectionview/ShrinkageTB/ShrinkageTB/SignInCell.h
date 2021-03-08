//
//  SignInCell.h
//  BasicFW
//
//  Created by zhouyy on 2019/5/10.
//  Copyright © 2019 zyy. All rights reserved.
//

#import <UIKit/UIKit.h>


NS_ASSUME_NONNULL_BEGIN

@interface SignInCell : UITableViewCell
@property (nonatomic, strong) UILabel *titleLab;
@property (nonatomic, strong) UILabel *typeLab;
@property (nonatomic, strong) UILabel *promitLab;
@property (nonatomic, strong) UILabel *glodLab;
@property (nonatomic, strong) UILabel *goldImagelab;
@property (nonatomic, strong) UIButton *rightBtn;
@property (nonatomic, strong) UIView *leftView;
@property (nonatomic, strong) UIView *backHidenView;
@property (nonatomic, strong) UIButton *selectedBtn;

@property (nonatomic, copy) void(^gotoNextBtnBlock)(void);





@end

NS_ASSUME_NONNULL_END
