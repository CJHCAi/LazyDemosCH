//
//  ZJAddHeaderForCollectionReusableView.h
//  ZJCollectionViewSummary
//
//  Created by James on 2018/6/7.
//  Copyright © 2018年 James. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ZJAddHeaderForCollectionReusableView : UICollectionReusableView

@property (weak, nonatomic) IBOutlet UIImageView *imageV;
@property (weak, nonatomic) IBOutlet UILabel *titleL;
@property (weak, nonatomic) IBOutlet UILabel *detailL;

@property (nonatomic,strong) NSDictionary *dict;
@end
