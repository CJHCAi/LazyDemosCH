//
//  MusicCell.h
//  仿抖音
//
//  Created by ireliad on 2018/3/15.
//  Copyright © 2018年 正辰科技. All rights reserved.
//

#import "CardCell.h"
@class MusicCell;
@protocol  MusicCellDeletegate<NSObject>
@optional
-(void)MusicCellGoBack:(MusicCell *)musicCell;
-(void)MusicCellCommentBtnClicked;
@end

@interface MusicCell : CardCell
-(void)play;
-(void)pause;

@property(nonatomic,strong)UIImageView *musicImageView;
@property(nonatomic,weak)id<MusicCellDeletegate> deledate;

@end
