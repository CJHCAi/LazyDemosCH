//
//  ARResultCellWithbkey.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARSearchResultItem;
@interface ARResultCellWithbkey : UITableViewCell

@property (nonatomic,strong) ARSearchResultItem *searchResultItem;

- (void)setResultCellWithbkey:(ARSearchResultItem *)resultItem;

+ (instancetype)resultCellWithbkeyWithTableView:(UITableView *)tableView;

@end
