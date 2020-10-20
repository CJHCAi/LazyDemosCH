//
//  WSwitchDetailFamView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/6/22.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WSwitchDetailFamView;

@protocol WswichDetailFamViewDelegate <NSObject>

-(void)WswichDetailFamViewDelegate:(WSwitchDetailFamView *)detaiView didSelectedButton:(UIButton *)sender repeatNameIndex:(NSInteger)repeatIndex;

@end

@interface WSwitchDetailFamView : UIView

@property (nonatomic,copy) NSArray *famNamesArray; /*名字家谱*/
@property (nonatomic,weak) id<WswichDetailFamViewDelegate> delegate; /*代理人*/

- (instancetype)initWithFrame:(CGRect)frame famNamesArr:(NSArray *)famNames;
-(void)initUI;
@end
