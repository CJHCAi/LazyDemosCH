//
//  ImagePickerCell.h
//  Ps
//
//  Created by Deon Botha on 10/12/2013.
//  Copyright (c) 2013 dbotha. All rights reserved.
//

#import <UIKit/UIKit.h>

@class OLInstagramImage;

@interface OLInstagramImagePickerCell : UICollectionViewCell
- (void)bind:(OLInstagramImage *)media;
@property (nonatomic, retain)NSURL *fullURL;

@end
