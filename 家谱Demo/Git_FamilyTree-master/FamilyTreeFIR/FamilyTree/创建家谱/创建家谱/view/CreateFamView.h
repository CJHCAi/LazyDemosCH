//
//  CreateFamView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/2.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "BackScrollAndDetailView.h"



@interface CreateFamView : BackScrollAndDetailView

@property (nonatomic,strong) DiscAndNameView *famName; /*家族名称*/

@property (nonatomic,strong) DiscAndNameView *famfarName; /*祖宗姓名*/

@property (nonatomic,strong) InputView *gennerNum; /*第几代*/

@property (nonatomic,strong) UITextField *famBookName; /*家谱名称*/

@property (nonatomic,strong) InputView *sexInpuView; /*性别*/

@property (nonatomic,strong) ClickRoundView *diXiView; /*嫡系*/

@property (nonatomic,strong) ClickRoundView * famousPerson; /*家族名人*/

@property (nonatomic,strong) UIImageView *famTotem; /*家族图腾图*/



@end
