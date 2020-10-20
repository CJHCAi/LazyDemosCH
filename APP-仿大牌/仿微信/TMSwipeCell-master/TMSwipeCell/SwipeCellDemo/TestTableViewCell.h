//
//  TestTableViewCell.h
//  TMSwipeCell
//
//  Created by cocomanber on 2018/7/7.
//  Copyright © 2018年 cocomanber. All rights reserved.
//

#import "TMSwipeCell.h"
#import "TestModel.h"

@interface TestTableViewCell : TMSwipeCell

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *nameL;
@property (weak, nonatomic) IBOutlet UILabel *contentL;
@property (weak, nonatomic) IBOutlet UILabel *timeL;

+ (CGFloat)rowHeight;

@end
