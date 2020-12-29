//
//  HKHistoryTagView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/28.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKHistoryTagView.h"

@interface HKHistoryTagView () <UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UICollectionView *collectionView;

@end

@implementation HKHistoryTagView

- (void)awakeFromNib {
    [super awakeFromNib];
    [self addSubview:self.collectionView];
}

- (instancetype)init {
    if (self = [super init]) {
        [self addSubview:self.collectionView];
    }
    return self;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.estimatedItemSize = CGSizeMake(80, 24);
        layout.minimumInteritemSpacing = 10;
        // 设置最小行间距
//        layout.minimumLineSpacing = 10;
        // 设置布局的内边距
        layout.sectionInset = UIEdgeInsetsZero;
        UICollectionView *collectionView = [HKComponentFactory collectionViewWithFrame:CGRectZero
                                                                                layout:layout
                                                        showsHorizontalScrollIndicator:NO
                                                          showsVerticalScrollIndicator:NO
                                                                              delegate:self
                                                                            dataSource:self
                                                                            supperView:nil];
        // 注册cell
        [collectionView registerClass:[HKHistoryTagInnerCell class] forCellWithReuseIdentifier:NSStringFromClass([HKHistoryTagInnerCell class])];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self);
    }];
}

- (void)setHisTags:(NSArray *)hisTags {
    if (hisTags) {
        _hisTags = hisTags;
        [self.collectionView reloadData];
    }
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.hisTags.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HKHistoryTagInnerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKHistoryTagInnerCell class]) forIndexPath:indexPath];
    HK_AllTagsHis *tagHis = self.hisTags[indexPath.item];
    cell.histroyTag = tagHis;
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    HK_AllTagsHis *tagHis = self.hisTags[indexPath.item];
    if ([self.delegate respondsToSelector:@selector(historyTagViewBlock:)] ) {
        [self.delegate historyTagViewBlock:tagHis];
    }
}



@end


@interface HKHistoryTagInnerCell ()

@property (nonatomic, strong) UIView *containerView;
@property (nonatomic, strong) UIImageView *iconView;
@property (nonatomic, strong) UILabel *tagLabel;

@end

@implementation HKHistoryTagInnerCell

- (UIView *)containerView {
    if (!_containerView) {
        _containerView = [[UIView alloc] init];
        _containerView.backgroundColor = UICOLOR_HEX(0x333b51);
        _containerView.alpha = 0.6;
        _containerView.layer.cornerRadius = 3.f;
        _containerView.layer.masksToBounds = YES;
    }
    return _containerView;
}

- (UIImageView *)iconView {
    if (!_iconView) {
        _iconView = [[UIImageView alloc] init];
    }
    return _iconView;
}

-(UILabel *)tagLabel {
    if (!_tagLabel) {
        _tagLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                             textColor:[UIColor whiteColor]
                                         textAlignment:NSTextAlignmentLeft
                                                  font:PingFangSCRegular13
                                                  text:@""
                                            supperView:nil];
    }
    return _tagLabel;
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self.contentView addSubview:self.containerView];
        [self.contentView addSubview:self.iconView];
        [self.contentView addSubview:self.tagLabel];
    }
    return self;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.containerView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.bottom.equalTo(self.contentView);
        make.right.equalTo(self.tagLabel.mas_right).offset(8);
    }];
    
    [self.iconView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(7);
        make.centerY.equalTo(self.contentView);
        make.width.height.mas_equalTo(11);
    }];
    
    [self.tagLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.iconView.mas_right).offset(4);
        make.centerY.equalTo(self.iconView);
        make.height.mas_equalTo(13);
    }];
}

- (void)setHistroyTag:(HK_AllTagsHis *)histroyTag { //[tagId 标签id tag 名称 type 1圈子 2用户 3自定义]

    if (histroyTag) {
        _histroyTag = histroyTag;
        self.tagLabel.text = histroyTag.tag;
        UIImage *image;
        if ([histroyTag.type integerValue] == 1) { //圈子
            image = [UIImage imageNamed:@"qzsq1f"];
        } else if ([histroyTag.type integerValue] == 2) { //用户
            
        } else if ([histroyTag.type integerValue] == 3) { //自定义
            image = [UIImage imageNamed:@"bqqjj1s"];
        }
        self.iconView.image = image;
    }
}

@end




