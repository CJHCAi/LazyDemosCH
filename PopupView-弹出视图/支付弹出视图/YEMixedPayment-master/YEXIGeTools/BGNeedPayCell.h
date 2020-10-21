//
//  BGNeedPayCell.h
//  WeiTuan
//
//  Created by Apple on 2019/4/18.
//  Copyright © 2019 西格. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface BGNeedPayCell : UITableViewCell

+ (instancetype)cellWithTableView:(UITableView *)tableView;

//- (void)updateShowContent:(NSDictionary *)contentDic;
@property (weak, nonatomic) IBOutlet UIImageView *iconImg;
@property (weak, nonatomic) IBOutlet UILabel *payLabel;
@property (weak, nonatomic) IBOutlet UIImageView *payStateImg;

@end

NS_ASSUME_NONNULL_END
