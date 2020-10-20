//
//  CollectionViewCell.h
//  ListViewLoading
//
//  Created by 刘江 on 2019/10/15.
//  Copyright © 2019 Liujiang. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface CollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *payIcon;
@property (weak, nonatomic) IBOutlet UILabel *payway;
@property (weak, nonatomic) IBOutlet UIImageView *checkBox;

@end

NS_ASSUME_NONNULL_END
