//
//  HomeCollectionViewCell.h
//  ChangBa
//
//  Created by V.Valentino on 16/9/22.
//  Copyright © 2016年 huyifan. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeTextView.h"
#import "HomeResult.h"
@interface HomeCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *headphotoIV;
@property (weak, nonatomic) IBOutlet UILabel *nicknameLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *listen_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *flower_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *forward_numLabel;
@property (weak, nonatomic) IBOutlet UILabel *comment_numLabel;
@property (weak, nonatomic) IBOutlet UIImageView *mvIV;
@property (weak, nonatomic) IBOutlet UIImageView *recommendIV;
@property (nonatomic, strong) HomeTextView *textView;
@property (nonatomic, strong) HomeResult *result;

@end
