//
//  ListCell.h
//  SeeFood
//
//  Created by 陈伟捷 on 15/11/24.
//  Copyright © 2015年 纪洪波. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCell : UICollectionViewCell

/**背景图片*/
@property(nonatomic, strong, readonly)UIImageView *imageView;
/**名字label*/
@property(nonatomic, strong, readonly)UILabel *nameLabel;

- (void)setImageViewWithImageName:(NSString *)imageName;

@end
