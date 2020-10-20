//
//  ScrollerView.h
//  FamilyTree
//
//  Created by 王子豪 on 16/5/26.
//  Copyright © 2016年 王子豪. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ScrollerView : UIView
@property (nonatomic,strong) NSMutableArray *imageNames; /*图组*/
- (instancetype)initWithFrame:(CGRect)frame images:(NSMutableArray *)imageNames;
-(void)updateImageView;//更新图片
@end
