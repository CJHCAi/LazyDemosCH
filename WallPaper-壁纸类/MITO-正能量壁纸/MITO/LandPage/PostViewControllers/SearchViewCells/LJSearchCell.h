//
//  LJSearchCell.h
//  FitnessHelper
//
//  Created by 成都千锋 on 15/11/1.
//  Copyright (c) 2015年 成都千锋. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol searchBarProtocol <NSObject>

- (void) searchBarTextFromButtonTitle:(NSString *)buttonTitle;

@end

@interface LJSearchCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *leftLabel;
@property (weak, nonatomic) IBOutlet UILabel *rightLabel;
@property (weak, nonatomic) IBOutlet UIButton *leftButton;
@property (weak, nonatomic) IBOutlet UIButton *rightButton;

@property (nonatomic, weak) id<searchBarProtocol>delegate;

- (IBAction)buttonClicked:(UIButton *)sender;

- (void) configData:(NSArray *)array addIndex:(NSInteger)index;

@end
