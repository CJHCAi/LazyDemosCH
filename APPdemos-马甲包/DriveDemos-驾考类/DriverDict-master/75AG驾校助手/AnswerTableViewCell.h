//
//  AnswerTableViewCell.h
//  75AG驾校助手
//
//  Created by again on 16/4/8.
//  Copyright © 2016年 again. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface AnswerTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *answerLabel;
@property (weak, nonatomic) IBOutlet UILabel *numberLabel;
@property (weak, nonatomic) IBOutlet UIImageView *numberImage;

@end
