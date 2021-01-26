//
//  CQTopBarSegment.h
//  CQTopBar
//
//  Created by CQ on 2018/1/10.
//  Copyright © 2018年 CQ. All rights reserved.
//

#import <UIKit/UIKit.h>

@class CQTopBarSegment,CQTopBarView;
@protocol CQTopBarSegmentDelegate <NSObject>
@optional
- (void)topBarSegmentWithBlock:(CQTopBarSegment *_Nonnull)segment indexPath:(NSIndexPath *_Nonnull)indexPath;
- (void)topBarSegmentWithSegmentView:(CQTopBarSegment *_Nonnull)segmentView;
@end

@interface CQTopBarSegment : UIView
@property (nonatomic, weak) id<CQTopBarSegmentDelegate> delegate;
@property(nonatomic,strong) UICollectionView * _Nonnull collectionView;
@property (nonatomic, strong) NSMutableArray * _Nonnull sectionTitles;
@property (nonatomic, strong) UIColor * _Nonnull titleTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIColor * _Nonnull selectedTitleTextColor UI_APPEARANCE_SELECTOR;
@property (nonatomic, strong) UIFont * _Nonnull titleTextFont;
@property (nonatomic, strong) NSString * _Nullable segmentImage;
@property (nonatomic, strong) NSString * _Nonnull selectSegmentImage;
@property (nonatomic, strong) UIColor * _Nonnull segmentlineColor;
@property (nonatomic, strong) UIColor * _Nonnull segmentbackColor;
@property (nonatomic, strong) UIColor * _Nonnull selectSegmentbackColor;
@property (nonatomic, strong) UIImage * _Nullable segmentbackImage;
@property (nonatomic, strong) UIImage * _Nullable selectSegmentbackImage;

- (instancetype _Nonnull )initWithFrame:(CGRect)frame sectionTitles:(NSArray *_Nonnull)sectionTitles;
- (void)topBarReplaceObjectsAtIndexes:(NSUInteger)indexes withObjects:(id _Nonnull )objects BarView:(CQTopBarView *_Nonnull)barView;

@end
