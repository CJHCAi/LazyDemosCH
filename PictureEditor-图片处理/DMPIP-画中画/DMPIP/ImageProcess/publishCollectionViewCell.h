//
//  publishCollectionViewCell.h
//  LuoChang
//
//  Created by Supwin_mbp002 on 16/1/12.
//  Copyright © 2016年 Rick. All rights reserved.
//

#import <UIKit/UIKit.h>

@class publishCollectionViewCell;
@protocol publishCellDelegate <NSObject>
-(void)publishCellDelteClick:(publishCollectionViewCell *)itemView ;
@end

@interface publishCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *imageview;
@property (weak, nonatomic) IBOutlet UIButton *deletebtn;
@property (nonatomic , weak) id<publishCellDelegate> delegate;

@end
