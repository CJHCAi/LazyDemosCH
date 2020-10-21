//
//  DetailCell.h
//  BrowseMeetup
//
//  Created by TAMIM Ziad on 8/16/13.
//  Copyright (c) 2013 TAMIM Ziad. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface DetailCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *whoLabel;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLabel;
@property (weak, nonatomic) IBOutlet UILabel *locationLabel;
@end
