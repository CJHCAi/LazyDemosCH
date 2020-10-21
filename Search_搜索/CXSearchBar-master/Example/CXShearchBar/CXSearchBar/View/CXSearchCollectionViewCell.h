//
//  CXSearchCollectionViewCell.h
//  CXShearchBar_Example
//
//  Created by caixiang on 2019/4/29.
//  Copyright © 2019年 caixiang305621856. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CXSearchCollectionViewCell : UICollectionViewCell

@property (nonatomic, copy) NSString *text;

+ (CGSize)getSizeWithText:(NSString*)text;

@end

