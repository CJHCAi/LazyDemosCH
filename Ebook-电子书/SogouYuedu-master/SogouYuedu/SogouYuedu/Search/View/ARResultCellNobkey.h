//
//  ARResultCellNobkey.h
//  SogouYuedu
//
//  Created by andyron on 2017/9/26.
//  Copyright © 2017年 andyron. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ARSearchResultItem;
@interface ARResultCellNobkey : UITableViewCell

@property (nonatomic,strong) ARSearchResultItem *searchResultItem;

- (void)setResultCellNobkey:(ARSearchResultItem *)resultItem;

+ (instancetype)resultCellNobkeyWithTableView:(UITableView *)tableView;

@end
