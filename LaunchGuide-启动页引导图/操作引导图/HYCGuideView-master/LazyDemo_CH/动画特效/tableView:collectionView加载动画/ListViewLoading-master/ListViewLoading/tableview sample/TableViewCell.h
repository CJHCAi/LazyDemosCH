//
//  TableViewCell.h
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/14.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface TableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *avatar;
@property (weak, nonatomic) IBOutlet UILabel *name;
@property (weak, nonatomic) IBOutlet UILabel *job;
@property (weak, nonatomic) IBOutlet UILabel *desc;

@end

NS_ASSUME_NONNULL_END
