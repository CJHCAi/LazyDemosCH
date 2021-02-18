//
//  LoginView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/5/25.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AccountView.h"
#import "TopView.h"
#import "OtherLoginView.h"
@class LoginView;

@protocol LoginViewDelegate <NSObject>

@optional

-(void)loginView:(LoginView *)loginView didSelectedTopViewBtn:(UIButton *)sender;
-(void)loginView:(LoginView *)loginView didSelectedOtherLoginBtn:(UIButton *)sender;
-(void)loginView:(LoginView *)loginView didSelectedLoginBtn:(UIButton *)sender;
-(void)loginView:(LoginView *)loginView didSelectedTourBtn:(UIButton *)sender;



@end

@interface LoginView : UIView

@property (nonatomic,strong)  AccountView *accountView; /*账号*/
@property (nonatomic,strong)  AccountView *passwordView; /*密码*/
@property (nonatomic,strong)  TopView *topView; /*顶部控件*/

@property (nonatomic,weak)   id<LoginViewDelegate> delegate; /*代理人*/

@end
