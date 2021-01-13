//
//  YCSearchTableViewCell.h
//  YClub
//
//  Created by yuepengfei on 17/5/9.
//  Copyright © 2017年 岳鹏飞. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol YCSearchTableViewCellDelegate <NSObject>

- (void)doSearchWithHotKey:(NSString *)hotKey;

@end

@interface YCSearchTableViewCell : UITableViewCell

@property (nonatomic, assign) id<YCSearchTableViewCellDelegate>delegate;

- (void)configHotTitle:(NSArray *)titles;

+ (CGFloat)calculateCellHeightWithTitles:(NSArray *)titles;

@end
