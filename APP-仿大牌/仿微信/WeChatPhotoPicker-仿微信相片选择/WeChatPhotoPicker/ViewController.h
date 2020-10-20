//
//  ViewController.h
//  WeChatPhotoPicker
//
//  Created by Mac on 16/5/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CollectionCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@end

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UICollectionView *collectionView;

@end

