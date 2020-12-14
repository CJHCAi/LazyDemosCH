//
//  SABookModelTBCell.m
//  01-购物车
//
//  Created by Shenao on 2017/5/17.
//  Copyright © 2017年 hcios. All rights reserved.
//

#import "SABookModelTBCell.h"
#import "SABookModel.h"

@interface SABookModelTBCell ()

@property (nonatomic,weak) IBOutlet UIImageView * iconImg;
@property (weak, nonatomic) IBOutlet UILabel *priceLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;

@property (weak, nonatomic) IBOutlet UIButton *minusBtu;
@property (weak, nonatomic) IBOutlet UILabel *countLabel;

@end


@implementation SABookModelTBCell
- (IBAction)plusButton {
    
    self.bookModel.count++;
    
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.bookModel.count];
    self.minusBtu.enabled = YES;
    
    [self.delegate bookCellDidClickPlusButton:self];
    
}
- (IBAction)minusButton {
    
    self.bookModel.count--;
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.bookModel.count];
    if (self.bookModel.count == 0) {
        self.minusBtu.enabled = NO;
    }
    
    [self.delegate bookCellDidClickMinusButton:self];
    
}



- (void)setBookModel:(SABookModel *)bookModel{
    _bookModel = bookModel;
    
    self.iconImg.image = [UIImage imageNamed:bookModel.icon];
    self.nameLabel.text = bookModel.name;
    self.priceLabel.text = [NSString stringWithFormat:@"¥%@",bookModel.price];
    // 根据count决定countLabel显示文字
    self.countLabel.text = [NSString stringWithFormat:@"%ld",self.bookModel.count];
    // 根据count决定减号按钮是否能够被点击（如果不写这一行代码，会出现cell复用)
    self.minusBtu.enabled = (bookModel.count > 0);
}

@end
