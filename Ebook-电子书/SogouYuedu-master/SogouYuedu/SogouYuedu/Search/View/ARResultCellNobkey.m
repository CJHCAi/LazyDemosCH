//
//  ARResultCellNobkey.m
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import "ARResultCellNobkey.h"
#import "ARSearchResultItem.h"
#import <SDWebImage/UIImageView+WebCache.h>

@interface ARResultCellNobkey()
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UIImageView *bookImgView;

@end
@implementation ARResultCellNobkey

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

//创建自定义可重用的cell对象
+ (instancetype)resultCellNobkeyWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"resultNobkey";
    ARResultCellNobkey *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"ARResultCellNobkey" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setResultCellNobkey:(ARSearchResultItem *)resultItem{
    _searchResultItem = resultItem;
    self.bookName.text = resultItem.book;
    self.author.text = resultItem.author;
    if ([resultItem.status isEqualToString:@"0"]) {
        self.status.text = @"连载中";
    }else{
        self.status.text = @"已完结";
    }
    
//    self.bookImgView.image = [YTNetCommand downloadImageWithImgStr:resultItem.picurl
//                                               placeholderImageStr:@"book_blue"
//                                                         imageView:_bookImgView];
    
    [self.imageView sd_setImageWithURL:[NSURL URLWithString:resultItem.picurl] placeholderImage:[UIImage imageNamed:@"book_blue.png"]];
}

@end
