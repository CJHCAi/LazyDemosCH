//
//  SingTableViewCell.h
//  ChangBa
//
//  Created by V.Valentino on 16/9/21.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SingTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *iconImageView;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *sizeAndArtistLabel;
@property (weak, nonatomic) IBOutlet UIButton *playButton;

@end
