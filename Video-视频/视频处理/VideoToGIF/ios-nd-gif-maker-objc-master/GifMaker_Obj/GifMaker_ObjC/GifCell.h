//
//  GifCell.h
//  GifMaker_ObjC
//
//  Created by Gabrielle Miller-Messner on 4/18/16.
//  Copyright © 2016 Gabrielle Miller-Messner. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "Gif.h"

@interface GifCell : UICollectionViewCell

@property (weak, nonatomic) IBOutlet UIImageView *gifImageView;

- (void)configureForGif:(Gif *)gif;

@end
