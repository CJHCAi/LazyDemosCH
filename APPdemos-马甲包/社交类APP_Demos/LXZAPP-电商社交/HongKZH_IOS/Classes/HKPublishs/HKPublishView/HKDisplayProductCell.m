//
//  HKDisplayProductCell.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/31.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKDisplayProductCell.h"
#import "HK_UserProductList.h"
@interface HKDisplayProductCell()<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, weak) UICollectionView *collectionView;

@property (nonatomic, strong) UILabel *tipLabel;

@property (nonatomic, strong) UISwitch *switchButton;

@property (nonatomic, strong) NSMutableArray *images;

@end

#define DEFAULT_LEFT_MARGIN   15        //默认距离左边距离15

@implementation HKDisplayProductCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    
    self.tipLabel = [HKComponentFactory labelWithFrame:CGRectZero textColor:RGB(102,102,102) textAlignment:NSTextAlignmentLeft font:PingFangSCRegular14 text:@"展示商品" supperView:self.contentView];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.contentView).offset(15);
        make.top.equalTo(self.contentView).offset(19);
        make.height.mas_equalTo(14);
    }];

    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    UICollectionView *collectionView = [HKComponentFactory collectionViewWithFrame:CGRectZero
                                                                            layout:layout
                                                    showsHorizontalScrollIndicator:NO
                                                      showsVerticalScrollIndicator:NO
                                                                          delegate:self
                                                                        dataSource:self
                                                                        supperView:self];
    self.collectionView = collectionView;
    layout.itemSize = CGSizeMake(70, 70);
    layout.minimumInteritemSpacing = 0;
    // 设置最小行间距
    layout.minimumLineSpacing = 2.5;
    // 设置布局的内边距
    layout.sectionInset = UIEdgeInsetsZero;
    
    // 注册cell
    [collectionView registerClass:[HKDisplayProductInnerCell class] forCellWithReuseIdentifier:NSStringFromClass([HKDisplayProductInnerCell class])];
//    //布局 CollectionView
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(15);
        make.right.equalTo(self).offset(-15);
        make.top.equalTo(self.tipLabel.mas_bottom).offset(15);
        make.height.mas_equalTo(70);
    }];
    
//    self.switchButton = [[UISwitch alloc] init];
//    [self.contentView addSubview:self.switchButton];
//    self.switchButton.on = NO;
//    [self.switchButton mas_makeConstraints:^(MASConstraintMaker *make) {
//        make.right.equalTo(self.contentView).offset(-10);
//        make.bottom.equalTo(self.contentView).offset(-5);
//    }];
}

#pragma mark 数据源

- (NSMutableArray *)images {
    if (!_images) {
        _images = [NSMutableArray array];
    }
    return _images;
}

- (void)setBoothCount:(NSInteger)boothCount {
    _boothCount =boothCount;
    if (self.images) {
        [self.images removeAllObjects];
    }
    
    //先添加商品图片
    if ([self.selectedItems count] >0) {
        for (HKUserProduct *product in self.selectedItems) {
            [[SDWebImageManager sharedManager] loadImageWithURL:[NSURL URLWithString:product.imgSrc] options:0 progress:nil completed:^(UIImage * _Nullable image, NSData * _Nullable data, NSError * _Nullable error, SDImageCacheType cacheType, BOOL finished, NSURL * _Nullable imageURL) {
                [self.images addObject:image];
                if ([self.images count] == [self.selectedItems count]) {
                    dispatch_async(dispatch_get_main_queue(), ^{
                        //添加展位图片
                        for (int i = 0; i < boothCount-self.selectedItems.count; i++) {
                            [self.images addObject:[UIImage imageNamed:@"fbsp2jiat"]];
                        }
                        //添加添加展位图片
                        [self.images addObject:[UIImage imageNamed:@"fabugmzw"]];
                        //刷新cell
                        [self.collectionView reloadData];
                    });
                }
            }];
        }
    } else {
        //添加展位图片
        for (int i = 0; i < boothCount-self.selectedItems.count; i++) {
            [self.images addObject:[UIImage imageNamed:@"fbsp2jiat"]];
        }
        //添加添加展位图片
        [self.images addObject:[UIImage imageNamed:@"fabugmzw"]];
    }
}


#pragma mark UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return [self.images count];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HKDisplayProductInnerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKDisplayProductInnerCell class]) forIndexPath:indexPath];
    cell.image = [self.images objectAtIndex:indexPath.item];
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.item == self.images.count-1) {
        //购买展位
        if (self.buyBoothBlock) {
            self.buyBoothBlock();
        }
    } else {
        //跳转我的商品页面
        if (self.gotoUserProductBlock) {
            self.gotoUserProductBlock();
        }
    }
}



@end


@implementation HKDisplayProductInnerCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self layoutUI];
    }return self;
}

- (void)initUI {
    self.productImageView = [HKComponentFactory imageViewWithFrame:CGRectZero image:nil supperView:self.contentView];
    self.productImageView.userInteractionEnabled = YES;
}

- (void)layoutUI {
    [self.productImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.contentView);
    }];
}

- (void)setImage:(UIImage *)image {
    _image = image;
    if (image) {
        self.productImageView.image = image;
    }
}


@end
