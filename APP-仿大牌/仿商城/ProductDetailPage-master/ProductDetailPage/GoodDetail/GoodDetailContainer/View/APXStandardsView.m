//
//  APXStandardsView.m
//  ZhongHeBao
//
//  Created by 云无心 on 16/12/30.
//  Copyright © 2016年 zhbservice. All rights reserved.
//

#import "APXStandardsView.h"
#import "ZHBStandardViewCollectionViewCell.h"
#import "ZHBStandardViewCollectionReusableHeaderView.h"
#import "ZHBProdictDetailInfoModel.h"
#import "UICollectionViewLeftAlignedLayout.h"

#define kLineColor       ColorWithHex(0xf1f2f6)

static CGFloat const  kMainImgViewWidth          = 88; // img宽度

static CGFloat const  kMinCellWidth              = 74; //cell 最小宽度
static CGFloat const  kMaxCellWidth              = 300; // cell最大宽度
static CGFloat const  kShowHeaderHeight          = 103; // 顶部高度
static CGFloat const  kCollectionCellHeight      = 30; // collection高度
static CGFloat const  kCollectionCellTextPadding = 15; // collectionCell左右间距
static CGFloat const  kBottomButtonViewHeight    = 50; // 底部button


static NSString * const  kHeaderCollectionCell                            = @"HeaderCollectionCell";
static NSString * const  kZHBStandardViewCollectionViewCommonCell         = @"ZHBStandardViewCollectionViewCommonCell";
static NSString * const  kZHBStandardViewCollectionViewNumControlCell     = @"ZHBStandardViewCollectionViewNumControlCell";

@interface APXStandardsView ()

@property (nonatomic, strong) UICollectionView *mainCollectionView;

@property (nonatomic, strong) UIButton *addToShopCarBtn;
@property (nonatomic, strong) UIButton *buyButton;
@property (nonatomic, strong) UILabel *summationLabel;
@property (nonatomic, strong) UILabel *sumLabel; // 合计二字

@end

@implementation APXStandardsView
@synthesize buyNum = _buyNum;

- (instancetype)init
{
    if (self = [super init]) {
       
        [self buildViews];
    }
    return self;
}

- (void)buildViews
{
    self.frame = CGRectMake(0, 0, StandardViewWidth, StandardViewHeight);
    self.backgroundColor = [UIColor whiteColor];
    
    if(_buyNum == 0){
        _buyNum = 1;
    }
    [self setupContentView];
    [self setupContentConstraints];
}

- (void)setupContentView
{
    [self addSubview:self.mainImgView];
    [self addSubview:self.priceLab];
    [self addSubview:self.discountPriceLab];
    [self addSubview:self.mainCollectionView];
}

- (void)setupContentConstraints
{
    [self.mainImgView mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.size.mas_equalTo(CGSizeMake(kMainImgViewWidth, kMainImgViewWidth));
        make.leading.mas_equalTo(self.mas_trailing).offset(15.f);
        make.top.mas_equalTo(self.mas_top).offset(15);
    }];

    [self.priceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(self.mainImgView.mas_trailing).offset(15);
        make.centerY.mas_equalTo(self.mainImgView);
        make.height.mas_equalTo(33);
    }];
    
    [self.discountPriceLab mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.leading.mas_equalTo(self.priceLab.mas_trailing).offset(10);
        make.centerY.mas_equalTo(self.priceLab);
    }];
    
    // 删除按钮shut_down01
    UIButton *dismissBtn = [[UIButton alloc] init];
    [dismissBtn setImage:[UIImage imageNamed:@"goodDetail_standard_cancelBtn"] forState:UIControlStateNormal];
    [dismissBtn addTarget:self action:@selector(dismissBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:dismissBtn];
    [dismissBtn mas_makeConstraints:^(MASConstraintMaker *make) {
        
        make.trailing.mas_equalTo(self.mas_trailing);
        make.top.mas_equalTo(self.mas_top);
        make.size.mas_equalTo(CGSizeMake(40, 40));
    }];
}



#pragma mark - override
// 因为该控件图片有一部分超出父控件,但点击应仍有效,重写此方法
- (UIView *)hitTest:(CGPoint)point withEvent:(UIEvent *)event
{
    // 当前坐标系上的点转换到图片上的点
    CGPoint btnP = [self convertPoint:point toView:self.mainImgView];
    // 判断点在不在按钮上
    if ([self.mainImgView pointInside:btnP withEvent:event]) {
       
        return self.mainImgView;
    }else{
        
        return [super hitTest:point withEvent:event];
    }
}
#pragma mark - self property
- (void)setStandardBottomBtnType:(StandardBottomBtnType)standardBottomBtnType
{
    _standardBottomBtnType = standardBottomBtnType;
    CGFloat bottomH = [UIScreen safeBottomMargin];
    
    switch (standardBottomBtnType) {
        case StandardBottomBtnTypeSlectProperty:{
        

            [self.addToShopCarBtn setTitleColor:ColorWithHex(0xBE824E) forState:UIControlStateNormal];
            self.addToShopCarBtn.backgroundColor = ColorWithHex(0xF9FAFB);

            [self.buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
            self.buyButton.titleLabel.font = [UIFont systemFontOfSize:15.f];
            [self.addToShopCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
            self.addToShopCarBtn.titleLabel.font = [UIFont systemFontOfSize:15.f];
            self.addToShopCarBtn.frame = CGRectMake(0,
                                                    StandardViewHeight - kBottomButtonViewHeight - bottomH,
                                                    StandardViewWidth / 2,
                                                    kBottomButtonViewHeight);
            self.buyButton.frame = CGRectMake(StandardViewWidth / 2 ,
                                              StandardViewHeight - kBottomButtonViewHeight - bottomH,
                                              StandardViewWidth / 2,
                                              kBottomButtonViewHeight);
        }

            break;
            
        case StandardBottomBtnTypeAddToShopCar:{
        
            self.addToShopCarBtn.backgroundColor = ColorWithHex(0xD1A783);
            [self.addToShopCarBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
            
            [self.addToShopCarBtn setTitle:@"确定" forState:UIControlStateNormal];
            self.addToShopCarBtn.titleLabel.font = [UIFont systemFontOfSize:17.f];
            
            self.addToShopCarBtn.frame = CGRectMake(0,
                                                    StandardViewHeight - kBottomButtonViewHeight - bottomH,
                                                    StandardViewWidth,
                                                    kBottomButtonViewHeight);
            self.buyButton.frame = CGRectZero;
        }
            break;
            
        case StandardBottomBtnTypeBuy:{
        
            self.addToShopCarBtn.frame = CGRectZero;
            self.buyButton.backgroundColor = ColorWithHex(0xD1A783);
            [self.buyButton setTitle:@"确定" forState:UIControlStateNormal];
            self.buyButton.titleLabel.font = [UIFont systemFontOfSize:17.f];
            self.buyButton.frame = CGRectMake(0,
                                              StandardViewHeight - kBottomButtonViewHeight - bottomH,
                                              StandardViewWidth,
                                              kBottomButtonViewHeight);
        }
            break;
            
        default:
            break;
    }
}
- (void)setBuyNum:(NSInteger)buyNum
{
    _buyNum = buyNum;
    self.numberChooseControl.currentValue = buyNum;
    NSString *currnetValue = [NSString stringWithFormat:@"%zd",self.numberChooseControl.currentValue];
//    NSString *moneySum = [ZHBBaseMethod calculateTheItemOne:currnetValue MultiplyingByItemTwo:self.detailInfoModel.price];
//    self.summationLabel.text = [NSString stringWithFormat:@"¥%@",moneySum];
}
- (NSInteger)buyNum
{
    _buyNum = self.numberChooseControl.currentValue;
    return _buyNum;
}
- (void)setStandardArr:(NSArray<ZHBProductAttrsInfoModel *> *)standardArr
{
    _standardArr = standardArr;
    
    [self.mainCollectionView reloadData];
}
- (void)setDetailInfoModel:(ZHBProdictDetailInfoModel *)detailInfoModel
{
    _detailInfoModel = detailInfoModel;
    self.priceLab.text = [NSString stringWithFormat:@"¥%@",detailInfoModel.price];
    if (!IsStrEmpty(detailInfoModel.oldPrice)) {
        
        self.discountPriceLab.text = [NSString stringWithFormat:@"¥%@",detailInfoModel.oldPrice];
//        self.discountPriceLab.attributedText = [self.discountPriceLab.text setStrikethroughStyleAttribute:NSMakeRange(0, self.discountPriceLab.text.length)];
    }

    [self.mainImgView yy_setImageWithURL:[NSURL URLWithString:[detailInfoModel.productImages firstObject]] placeholder:nil];
    self.mainImgView.backgroundColor = [UIColor whiteColor];
    self.numberChooseControl.maxNumber = [detailInfoModel.stockNumber integerValue] > 200 ? 200 :[detailInfoModel.stockNumber integerValue];
    self.numberChooseControl.minNumber = [detailInfoModel.stockNumber integerValue] > 0 ? 1 : 0;
    
    NSString *numStr = [NSString stringWithFormat:@"%zd",self.numberChooseControl.currentValue];
//    NSString *moneySum = [ZHBBaseMethod calculateTheItemOne:numStr MultiplyingByItemTwo:self.detailInfoModel.price];
    
//    self.summationLabel.text = [NSString stringWithFormat:@"¥%@",moneySum];
}

#pragma mark - public
- (void)changeStandardViewButtonEnable:(BOOL)enable
{
    self.addToShopCarBtn.userInteractionEnabled = enable;
    self.buyButton.userInteractionEnabled = enable;
    if (enable) {
        if (self.standardBottomBtnType == StandardBottomBtnTypeSlectProperty) {
           
            [self.addToShopCarBtn setBackgroundColor:ColorWithHex(0XF9FAFB)];
        }else{
            [self.addToShopCarBtn setBackgroundColor:ColorWithHex(0xD1A783)];
        }

        [self.buyButton setBackgroundColor:ColorWithHex(0xD1A783)];

    }else{
        [self.addToShopCarBtn setBackgroundColor:ColorWithHex(0xE2E2E4)];
        [self.buyButton setBackgroundColor:ColorWithHex(0xE2E2E4)];

    }
    
}

#pragma mark - clicks
- (void)tapImgAction:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(Standards:imgDidClick:)]) {
        [self.delegate Standards:self imgDidClick:self.mainImgView];
    }
}
- (void)dismissBtnClick:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(Standards:dismissBtnClick:)]) {
        [self.delegate Standards:self dismissBtnClick:sender];
    }
}
- (void)addAddToShopCarButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(Standards:addToShopCarButtonClicked:)]) {
        [self.delegate Standards:self addToShopCarButtonClicked:sender];
    }
}
- (void)buyButtonClicked:(id)sender
{
    if ([self.delegate respondsToSelector:@selector(Standards:buyButtonClicked:)]) {
        [self.delegate Standards:self buyButtonClicked:sender];
    }
}

#pragma mark - api for custom
- (void)standardsViewReload
{
    if(self.mainCollectionView!=nil) {
       [self.mainCollectionView reloadData];
    }
}

#pragma mark - UICollectionViewDataSource && UICollectionViewDelegateFlowLayout

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return self.standardArr.count + 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if(section < self.standardArr.count)
    {
        ZHBProductAttrsInfoModel *standardModel = self.standardArr[section];
        return standardModel.value.count;
    }else{
        return 1;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.standardArr.count)
    {
        ZHBStandardViewCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZHBStandardViewCollectionViewCommonCell forIndexPath:indexPath];
        ZHBProductAttrsInfoModel *productAttrsInfoModel = self.standardArr[indexPath.section];
        ZHBBottonsValueModel *bottonsValue = productAttrsInfoModel.value[indexPath.row];
        
        cell.bottonsValue = bottonsValue;
        
        return cell;

    }else{
        
        // 一个view加一个layer
        UICollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kZHBStandardViewCollectionViewNumControlCell forIndexPath:indexPath];
        [cell.contentView addSubview:self.numberChooseControl];
        
        [cell.contentView addSubview:self.sumLabel];
        [self.sumLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.leading.mas_equalTo(cell.contentView.mas_trailing).offset(15.f);
            make.top.mas_equalTo(self.numberChooseControl.mas_bottom).offset(14);
            make.height.mas_equalTo(20);
        }];
        
        [cell.contentView addSubview:self.summationLabel];
        [self.summationLabel mas_makeConstraints:^(MASConstraintMaker *make) {
            
            make.centerY.mas_equalTo(self.sumLabel.mas_centerY);
            make.leading.mas_equalTo(self.sumLabel.mas_trailing).offset(10);

        }];
        
        
        return cell;
    }
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if(indexPath.section < self.standardArr.count){
        // 代理
        ZHBProductAttrsInfoModel *productAttrsInfoModel = self.standardArr[indexPath.section];
        ZHBBottonsValueModel *BottonsValue = productAttrsInfoModel.value[indexPath.row];
        
        // 新增 无货也可点击 iOS11 fix版本不修改
//        if (!BottonsValue.isNoStock) {
            if([self.delegate respondsToSelector:@selector(Standards:selectedTheStandName:andIndexPtah:)])
            {
                [self.delegate Standards:self selectedTheStandName:BottonsValue.name andIndexPtah:indexPath];
            } 
//        }else{
//            NSLog(@"无货=YES,%@",BottonsValue.name);
//        }
        
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat collectionCellWidth = 0.0f;
    if (indexPath.section < self.standardArr.count) {
        
        ZHBProductAttrsInfoModel *standardModel = self.standardArr[indexPath.section];
        ZHBBottonsValueModel *bottonsValue = standardModel.value[indexPath.row];
        
        NSString *str = bottonsValue.name;
//        CGFloat textWidth = [ZHBBaseMethod WidthWithString:str fontSize:14 height:kCollectionCellHeight];
//        collectionCellWidth = textWidth + kCollectionCellTextPadding * 2;
//
//        collectionCellWidth = collectionCellWidth > kMaxCellWidth ? kMaxCellWidth : collectionCellWidth;
//        collectionCellWidth = collectionCellWidth < kMinCellWidth ? kMinCellWidth : collectionCellWidth;
//        return CGSizeMake(collectionCellWidth, kCollectionCellHeight);
        return CGSizeMake(StandardViewWidth, 100 + 30);
    }else{
        
        return CGSizeMake(StandardViewWidth, 100 + 30);
    }
}

- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section
{
    if (section < self.standardArr.count) {
        
        return UIEdgeInsetsMake(8, 15, 15, 15);
    }else{
        
        return UIEdgeInsetsZero;
    }
}
// header
- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath
{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
                                     
        ZHBStandardViewCollectionReusableHeaderView *header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderCollectionCell forIndexPath:indexPath];
        
        ZHBProductAttrsInfoModel *productAttrsInfoModel = self.standardArr[indexPath.section];
        header.headerTitleLabel.text = productAttrsInfoModel.title;
        
        if (!productAttrsInfoModel.isSelected) {
            header.noChooseLabel.text = [NSString stringWithFormat:@"请选择：%@",productAttrsInfoModel.title];
        }else{
            header.noChooseLabel.text = @"";
        }
        if (indexPath.section == 0 && indexPath.row == 0) {
            header.lineView.hidden = YES;
        }else{
            header.lineView.hidden = NO;
        }
        
        
        reusableView = header;
    }
    return reusableView;
}
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if(section < self.standardArr.count){
        return CGSizeMake(kScreenWidth, 35);
    }
    return CGSizeZero;
}
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 15.0f;
}

#pragma mark - KVO Observe
-(void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary<NSString *,id> *)change context:(void *)context
{
    NSLog(@"keyPath=%@,object=%@,change=%@,context=%@",keyPath,object,change,context);
    
    NSNumberFormatter* numberFormatter = [[NSNumberFormatter alloc] init];
    NSString *numStr = [numberFormatter stringFromNumber:[change objectForKey:@"new"]];
//    NSString *moneySum = [ZHBBaseMethod calculateTheItemOne:numStr MultiplyingByItemTwo:self.detailInfoModel.price];
    
//    self.summationLabel.text = [NSString stringWithFormat:@"¥%@",moneySum];
}


#pragma mark - lazy load
- (UIImageView *)mainImgView
{
    if (!_mainImgView) {
        _mainImgView = [[UIImageView alloc] init];
        _mainImgView.image = [UIImage imageNamed:@"default_image"];
        _mainImgView.contentMode = UIViewContentModeScaleAspectFit;
        UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapImgAction:)];
        [_mainImgView addGestureRecognizer:tap];
        _mainImgView.userInteractionEnabled = YES;
    }
    
    return _mainImgView;
}
- (UILabel *)priceLab
{
    if (!_priceLab) {
        _priceLab = [[UILabel alloc] init];
//        _priceLab.textColor = redSwitchColor;
        _priceLab.font = [UIFont systemFontOfSize:24];
        _priceLab.text = @"¥:";
    }
    return _priceLab;
}
- (UILabel *)discountPriceLab
{
    if (!_discountPriceLab) {
        _discountPriceLab = [[UILabel alloc] init];
        _discountPriceLab.textColor = ColorWithHex(0xA3A3A3);
        _discountPriceLab.font = [UIFont systemFontOfSize:14];
    }
    return _discountPriceLab;
}

- (UICollectionView *)mainCollectionView
{
    if (!_mainCollectionView) {
        
        UICollectionViewLeftAlignedLayout *flowLayout =[[UICollectionViewLeftAlignedLayout alloc] init];
        flowLayout.minimumInteritemSpacing = 10.f;
        flowLayout.minimumLineSpacing = 15.f;
        _mainCollectionView = [[UICollectionView alloc] initWithFrame:CGRectMake(0,kShowHeaderHeight,StandardViewWidth,StandardViewHeight - kBottomButtonViewHeight - kShowHeaderHeight - [UIScreen safeBottomMargin]) collectionViewLayout:flowLayout];
        [_mainCollectionView registerClass:[ZHBStandardViewCollectionViewCell class] forCellWithReuseIdentifier:kZHBStandardViewCollectionViewCommonCell];
        [_mainCollectionView registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:kZHBStandardViewCollectionViewNumControlCell];
        [_mainCollectionView registerClass:[ZHBStandardViewCollectionReusableHeaderView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:kHeaderCollectionCell];
        _mainCollectionView.delegate = self;
        _mainCollectionView.dataSource = self;
        _mainCollectionView.backgroundColor = [UIColor whiteColor];
    }
    return _mainCollectionView;
}
- (APXNumberControl *)numberChooseControl
{
    if (!_numberChooseControl) {
        _numberChooseControl = [[APXNumberControl alloc] initWithFrame:CGRectMake(0,0,StandardViewWidth,50 + 30)];
        [_numberChooseControl addObserver:self forKeyPath:@"currentValue" options:NSKeyValueObservingOptionNew context:nil];
    }
    return _numberChooseControl;
}
- (UIButton *)addToShopCarBtn
{
    if (!_addToShopCarBtn) {
        _addToShopCarBtn = [[UIButton alloc] init];
        [_addToShopCarBtn setTitle:@"加入购物车" forState:UIControlStateNormal];
        [_addToShopCarBtn setTitleColor:ColorWithHex(0xBE824E) forState:UIControlStateNormal];
        _addToShopCarBtn.backgroundColor = ColorWithHex(0xF9FAFB);
        _addToShopCarBtn.titleLabel.font = [UIFont systemFontOfSize:15];
        [_addToShopCarBtn addTarget:self action:@selector(addAddToShopCarButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_addToShopCarBtn];
    }
    return _addToShopCarBtn;
}
- (UIButton *)buyButton
{
    if (!_buyButton) {
        _buyButton = [[UIButton alloc] init];
        [_buyButton setTitle:@"立即购买" forState:UIControlStateNormal];
        [_buyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
        _buyButton.backgroundColor = ColorWithHex(0xD1A783);
        _buyButton.titleLabel.font = [UIFont systemFontOfSize:15];
        [_buyButton addTarget:self action:@selector(buyButtonClicked:) forControlEvents:UIControlEventTouchUpInside];
        [self addSubview:_buyButton];
    }
    return _buyButton;
}
- (UILabel *)summationLabel
{
    if (!_summationLabel) {
        _summationLabel = [[UILabel alloc] init];
//        _summationLabel.textColor = redSwitchColor;
        _summationLabel.font = [UIFont systemFontOfSize:15];
        _summationLabel.text = @"¥/";
    }
    return _summationLabel;
}
- (UILabel *)sumLabel
{
    if (!_sumLabel) {
        _sumLabel = [[UILabel alloc] init];
        _sumLabel.textColor = ColorWithHex(0x555555);
        _sumLabel.font = [UIFont systemFontOfSize:14];
        _sumLabel.text = @"商品金额：";
    }
    return _sumLabel;
}

- (void)dealloc
{
    NSLog(@"standardsView dealloc");
    [self.numberChooseControl removeObserver:self forKeyPath:@"currentValue"];
}

@end
