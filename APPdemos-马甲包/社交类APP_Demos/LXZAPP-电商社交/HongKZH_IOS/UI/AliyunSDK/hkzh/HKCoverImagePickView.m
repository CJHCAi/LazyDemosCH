//
//  HKCoverImagePickView.m
//  HongKZH_IOS
//
//  Created by hongkzh on 2018/7/27.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCoverImagePickView.h"

@interface HKCoverImagePickView()<HKCellCoverImagePickCellDelegate, UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic, strong) UIImageView *imageView;

@property (nonatomic, strong) UIView *bottomView;

@property (nonatomic, strong) UICollectionView *collectionView;

@property (nonatomic, strong) UIButton *confirmButton;

@property (nonatomic,strong) HKCellCoverImagePickCell *selectedCell;

@property (nonatomic, assign) NSInteger state;  //判断当前状态，如果是截屏完成就是1

@property (nonatomic, strong)  UIButton *cancelButton;

@property (nonatomic, strong) UIView *line;

@property (nonatomic, strong) UILabel *tipLabel;

@end

@implementation HKCoverImagePickView

- (void)dealloc {
    DLog(@"%s",__func__);
}

#pragma mark 懒加载

/**
 显示选中封面的视图

 @return 封面视图
 */
- (UIImageView *)imageView {
    if (!_imageView) {
        UIImageView *imgView = [[UIImageView alloc] init];
        _imageView = imgView;
        _imageView.hidden = YES;
    }
    return _imageView;
}


/**
 选择图片的视图

 @return 视图
 */
- (UIView *)bottomView {
    if (!_bottomView) {
        UIView *bottomView = [[UIView alloc] init];
        bottomView.backgroundColor = [UIColor whiteColor];
        _bottomView = bottomView;
    }
    return _bottomView;
}

- (UIButton *)cancelButton {
    if (!_cancelButton) {
        //添加bottomView的子视图
        UIButton *cancelButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                              frame:CGRectZero
                                                              taget:self
                                                             action:@selector(cancelButtonClick:)
                                                         supperView:nil];
        [cancelButton setTitle:@"取消" forState:UIControlStateNormal];
        [cancelButton setTitleColor:UICOLOR_HEX(0x666666) forState:UIControlStateNormal];
        [cancelButton.titleLabel setFont:PingFangSCRegular15];
        _cancelButton = cancelButton;
    }
    return _cancelButton;
}

- (UIButton *)confirmButton {
    if (!_confirmButton) {
        //添加bottomView的子视图
        UIButton *confirmButton = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                               frame:CGRectZero
                                                               taget:self
                                                              action:@selector(confirmButtonClick:)
                                                          supperView:nil];
        [confirmButton setTitle:@"截屏" forState:UIControlStateNormal];
        [confirmButton.titleLabel setFont:PingFangSCMedium15];
        [confirmButton setTitleColor:UICOLOR_HEX(0x333333) forState:UIControlStateNormal];
       
        _confirmButton = confirmButton;
    }
    return _confirmButton;
}

- (UIView *)line {
    if (!_line) {
        //线
        UIView *line = [[UIView alloc] init];
        _line = line;
        line.backgroundColor = UICOLOR_HEX(0xcccccc);
    }
    return _line;
}

- (UILabel *)tipLabel {
    if (!_tipLabel) {
        //tip
        UILabel *tipLabel = [HKComponentFactory labelWithFrame:CGRectZero
                                                     textColor:UICOLOR_HEX(0x999999) textAlignment:NSTextAlignmentCenter
                                                          font:PingFangSCRegular11
                                                          text:@"滑动可选择一张封面"
                                                    supperView:nil];
        _tipLabel = tipLabel;
    }
    return _tipLabel;
}

- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.itemSize = CGSizeMake(48, 48);
        layout.minimumInteritemSpacing = 0;
        // 设置最小行间距
        layout.minimumLineSpacing = 2;
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
        [collectionView registerClass:[HKCellCoverImagePickCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCellCoverImagePickCell class])];
        _collectionView = collectionView;
    }
    return _collectionView;
}

- (instancetype)init {
    if (self = [super init]) {
        [self setUpUI];
    }
    return self;
}

- (void)setUpUI {
    self.state = 0;
    [self addSubview:self.imageView];
    [self addSubview:self.bottomView];
    [self addSubview:self.collectionView];
    
    [self.bottomView addSubview:self.cancelButton];
    [self.bottomView addSubview:self.confirmButton];
    [self.bottomView addSubview:self.line];
    [self.bottomView addSubview:self.tipLabel];
}

-(void)layoutSubviews {
    [super layoutSubviews];
    
    [self.imageView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.width.equalTo(self);
        make.height.equalTo(self).offset(-183);
    }];
    
    [self.bottomView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.bottom.equalTo(self);
        make.height.mas_equalTo(183);
    }];
    
    [self.collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self.bottomView).offset(17);
        make.right.equalTo(self.bottomView).offset(-17);
        make.top.equalTo(self.bottomView).offset(75);
        make.height.mas_equalTo(48);
    }];
    
    [self.cancelButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.top.equalTo(self.bottomView).offset(16);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(18);
    }];
    
    [self.confirmButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.bottomView).offset(16);
        make.right.equalTo(self.bottomView).offset(-16);
        make.width.mas_equalTo(35);
        make.height.mas_equalTo(18);
    }];
    
    [self.line mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.width.equalTo(self.bottomView);
        make.height.mas_equalTo(1);
        make.top.equalTo(self.bottomView).offset(50);
    }];
    
    [self.tipLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.equalTo(self.bottomView);
        make.top.equalTo(self.bottomView).offset(140);
        make.height.mas_equalTo(11);
    }];
}

#pragma mark Actions

- (void)reSetView {
    self.state = 0;
    self.selectedCell = nil;
    [self.confirmButton setTitle:@"截屏" forState:UIControlStateNormal];
}

- (void)cancelButtonClick:(UIButton *)button {
    self.imageView.hidden = YES;
    DLog(@"取消");
    if (self.cancelBlock) {
        self.cancelBlock();
    }
}

- (void)confirmButtonClick:(UIButton *)button {
    DLog(@"%@",button.titleLabel.text);
    if (self.state == 0) {  //截屏
        if (self.snapshotBlock) {
            self.snapshotBlock();
        }
    } else {    //确定
        self.imageView.hidden = YES;
        if (self.confirmblock) {
            self.confirmblock(self.selectedCell.image);
        }
    }
}


#pragma mark set方法重写
/**
 重写set方法，之前选中的cell状态去除再选中

 @param selectedCell 选中的cell
 */
- (void)setSelectedCell:(HKCellCoverImagePickCell *)selectedCell {
    if (_selectedCell) {
        [_selectedCell setSelectItem:NO];
    }
    _selectedCell = selectedCell;
    [UIView animateWithDuration:0.2f animations:^{
        self.imageView.hidden = NO;
    }];
    self.imageView.image = selectedCell.image;
    [_selectedCell setSelectItem:YES];
}

- (void)setImages:(NSMutableArray<UIImage *> *)images {
    _images = images;
    [self.collectionView reloadData];
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HKCellCoverImagePickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCellCoverImagePickCell class]) forIndexPath:indexPath];
    cell.delegate = self;
    
    
    UIImage *img = self.images[indexPath.row];
    cell.image = img;
    return cell;
}
-(void)cellImagePickBlock:(HKCellCoverImagePickCell *)cell{
    self.selectedCell = cell;
    [self.confirmButton setTitle:@"确认" forState:UIControlStateNormal];
    self.state = 1;
    if (self.cellClickBlock) {
        self.cellClickBlock();
    }
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    
}



@end

#pragma mark - collection item cell

@interface HKCellCoverImagePickCell()
@property (nonatomic, weak) UIButton *imageButton;
@end

@implementation HKCellCoverImagePickCell

- (void)dealloc {
    DLog(@"%s",__func__);
}

- (UIButton *)imageButton {
    if (!_imageButton) {
        UIButton *button = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                                        frame:CGRectZero
                                                        taget:self
                                                       action:@selector(buttonClick:) supperView:self.contentView];
        button.layer.borderColor = [UIColor clearColor].CGColor;
        button.layer.borderWidth = 0.f;
        button.alpha = 0.5f;
        _imageButton = button;
        [_imageButton mas_makeConstraints:^(MASConstraintMaker *make) {
            make.edges.equalTo(self.contentView);
        }];
    }
    return _imageButton;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
    
    }
    return self;
}

- (void)buttonClick:(UIButton *)button {
    button.selected = YES;
    [self setButtonStateStyle:button];
    if ([self.delegate respondsToSelector:@selector(cellImagePickBlock:)]) {
        [self.delegate cellImagePickBlock:self];
    }
}

- (void)setButtonStateStyle:(UIButton *)button {
    if (button.selected) {  //选中设置边框和透明度
        button.layer.borderColor = UICOLOR_HEX(0x0092ff).CGColor;
        button.layer.borderWidth = 2.f;
        button.alpha = 1.f;
    } else {
        button.layer.borderColor = [UIColor clearColor].CGColor;
        button.layer.borderWidth = 0.f;
        button.alpha = 0.5f;
    }
}


- (void)setSelectItem:(BOOL)selected {
    self.imageButton.selected = selected;
    [self setButtonStateStyle:self.imageButton];
}


- (void)setImage:(UIImage *)image {
    if (image) {
        _image = image;
        [self.imageButton setImage:image forState:UIControlStateNormal];
        [self.imageButton setImage:image forState:UIControlStateSelected];
    }
}

+ (CGSize)itemSize
{
    return CGSizeMake(48, 48);
}


@end

