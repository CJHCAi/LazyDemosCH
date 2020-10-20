//
//  AddMenberView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/3.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import "BackScrollAndDetailView.h"

@interface AddMenberView : BackScrollAndDetailView
@property (nonatomic,strong) DiscAndNameView *name; /*性名*/
@property (nonatomic,strong) InputView *fatheView; /*父亲*/
@property (nonatomic,strong) UITextField *motherView; /*母亲*/

@property (nonatomic,strong) InputView *sexInView; /*性别*/

@property (nonatomic,strong) InputView *idView; /*身份*/

@property (nonatomic,strong) ClickRoundView *famousPerson; /*家族名人*/

@property (nonatomic,strong) InputView *gennerNum; /*第几代*/

@property (nonatomic,strong) UITextField *gennerTextField; /*字辈*/

/**字辈*/
@property (nonatomic,strong) InputView *gennerZB;


@property (nonatomic,strong) InputView *rankingView; /*排行*/
@end
