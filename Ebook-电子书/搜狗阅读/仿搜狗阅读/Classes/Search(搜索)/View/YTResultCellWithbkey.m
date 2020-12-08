//
//  YTResultCellWithbkey.m
//  仿搜狗阅读
//
//  Created by Mac on 16/6/4.
//  Copyright © 2016年 YinTokey. All rights reserved.
//

#import "YTResultCellWithbkey.h"
#import "YTsearchResultItem.h"
#import "YTNetCommand.h"
@interface YTResultCellWithbkey()
@property (weak, nonatomic) IBOutlet UIImageView *bookImgView;
@property (weak, nonatomic) IBOutlet UILabel *bookName;
@property (weak, nonatomic) IBOutlet UILabel *author;
@property (weak, nonatomic) IBOutlet UILabel *status;
@property (weak, nonatomic) IBOutlet UILabel *site;
@property (weak, nonatomic) IBOutlet UITextView *desc;

@end



@implementation YTResultCellWithbkey

//创建自定义可重用的cell对象
+ (instancetype)resultCellWithbkeyWithTableView:(UITableView *)tableView
{
    static NSString *reuseId = @"resultwithbkey";
    YTResultCellWithbkey *cell = [tableView dequeueReusableCellWithIdentifier:reuseId];
    if (cell == nil) {
        cell = [[[NSBundle mainBundle] loadNibNamed:@"YTResultCellWithbkey" owner:nil options:nil] lastObject];
    }
    return cell;
}

- (void)setResultCellWithbkey:(YTsearchResultItem *)resultItem{
    _searchResultItem = resultItem;
    self.bookName.text = resultItem.book;
    self.author.text = resultItem.author;
    if ([resultItem.status isEqualToString:@"0"]) {
        self.status.text = @"连载中";
    }else{
        self.status.text = @"已完结";
    }
    self.desc.text = resultItem.desc;
    self.site.text = resultItem.site;
    //UIImageView *imgView = [[UIImageView alloc]init];
    self.bookImgView.image = [YTNetCommand downloadImageWithImgStr:resultItem.picurl
                                               placeholderImageStr:@"book_blue"
                                                         imageView:_bookImgView];
}


@end
