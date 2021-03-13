#import "DDYPhotoView.h"
#import "DDYKeyboardConfig.h"
#import "DDYPhotoCell.h"
#import <Photos/Photos.h>
#import "DDYAuthorityManager.h"
#import "Masonry.h"

static NSString *cellID = @"DDYKeyboardPhotoCellID";

@interface DDYPhotoView()<UICollectionViewDataSource, UICollectionViewDelegate, PHPhotoLibraryChangeObserver>
/** 数据源数组 */
@property (nonatomic, strong) NSMutableArray *dataArray;
/** 展示视图 */
@property (nonatomic, strong) UICollectionView *collectionView;
/** 相册按钮 */
@property (nonatomic, strong) UIButton *albumButton;
/** 编辑按钮 */
@property (nonatomic, strong) UIButton *editButton;
/** 原图按钮 */
@property (nonatomic, strong) UIButton *orignalButton;
/** 发送按钮 */
@property (nonatomic, strong) UIButton *sendButton;
/** 无数据提示 */
@property (nonatomic, strong) UILabel *tipLabel;
/** 无权限时前往设置 */
@property (nonatomic, strong) UIButton *settingButton;
/** 分割线 */
@property (nonatomic, strong) UIView *lineView;

@end

@implementation DDYPhotoView

#pragma mark - lazyLoad getter
#pragma mark 数据源数组getter
- (NSMutableArray *)dataArray {
    if (!_dataArray) {
        _dataArray = [NSMutableArray array];
    }
    return _dataArray;
}

#pragma mark collectionView getter
- (UICollectionView *)collectionView {
    if (!_collectionView) {
        UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
        layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
        layout.sectionInset = UIEdgeInsetsMake(0, 5, 0, 5);
        layout.minimumInteritemSpacing = 5;
        
        _collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:layout];
        _collectionView.delegate = self;
        _collectionView.dataSource = self;
        _collectionView.backgroundColor = kbBgMidColor;
        _collectionView.showsHorizontalScrollIndicator = NO;
        [_collectionView registerClass:[DDYPhotoCell class] forCellWithReuseIdentifier:cellID];
    }
    return _collectionView;
}

#pragma mark 相册按钮 getter
- (UIButton *)albumButton {
    if (!_albumButton) {
        _albumButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_albumButton setTitle:@"相册" forState:UIControlStateNormal];
        [_albumButton setTitleColor:kbPhotoTextColor forState:UIControlStateNormal];
        [_albumButton setTitleColor:DDY_LightGray forState:UIControlStateDisabled];
        [_albumButton.titleLabel setFont:[UIFont boldSystemFontOfSize:kbPhotoFont]];
        [_albumButton addTarget:self action:@selector(handleAlbum:) forControlEvents:UIControlEventTouchUpInside];
        [_albumButton setEnabled:NO];
    }
    return _albumButton;
}

#pragma mark 编辑按钮 getter
- (UIButton *)editButton {
    if (!_editButton) {
        _editButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_editButton setTitle:@"编辑" forState:UIControlStateNormal];
        [_editButton setTitleColor:kbPhotoTextColor forState:UIControlStateNormal];
        [_editButton setTitleColor:DDY_LightGray forState:UIControlStateDisabled];
        [_editButton.titleLabel setFont:[UIFont boldSystemFontOfSize:kbPhotoFont]];
        [_editButton addTarget:self action:@selector(handleEdit:) forControlEvents:UIControlEventTouchUpInside];
        [_editButton setEnabled:NO];
    }
    return _editButton;
}

#pragma mark 原图按钮 getter
- (UIButton *)orignalButton {
    if (!_orignalButton) {
        _orignalButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_orignalButton setTitle:@"原图" forState:UIControlStateNormal];
        [_orignalButton setTitleColor:kbPhotoTextColor forState:UIControlStateNormal];
        [_orignalButton setTitleColor:kbPhotoTextColor forState:UIControlStateSelected];
        [_orignalButton setTitleColor:DDY_LightGray forState:UIControlStateDisabled];
        [_orignalButton setImage:[UIImage imageNamed:@"DDYPhoto.bundle/selectN"] forState:UIControlStateNormal];
        [_orignalButton setImage:[UIImage imageNamed:@"DDYPhoto.bundle/selectS"] forState:UIControlStateSelected];
        [_orignalButton.titleLabel setFont:[UIFont boldSystemFontOfSize:kbPhotoFont]];
        [_orignalButton addTarget:self action:@selector(handleOrignal:) forControlEvents:UIControlEventTouchUpInside];
        [_orignalButton ddy_SetStyle:DDYBtnStyleImgLeft padding:3.];
    }
    return _orignalButton;
}

#pragma mark 发送按钮 getter
- (UIButton *)sendButton {
    if (!_sendButton) {
        _sendButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_sendButton setTitle:@"发送" forState:UIControlStateNormal];
        [_sendButton setTitleColor:kbPhotoTextColor forState:UIControlStateNormal];
        [_sendButton setTitleColor:DDY_LightGray forState:UIControlStateDisabled];
        [_sendButton.titleLabel setFont:[UIFont boldSystemFontOfSize:kbPhotoFont-2]];
        [_sendButton setBackgroundColor:kbBgBigColor];
        [_sendButton addTarget:self action:@selector(handleSend:) forControlEvents:UIControlEventTouchUpInside];
        [_sendButton setEnabled:NO];
    }
    return _sendButton;
}

#pragma mark 无数据提示 getter
- (UILabel *)tipLabel {
    if (!_tipLabel) {
        _tipLabel = [[UILabel alloc] init];
        [_tipLabel setFont:[UIFont systemFontOfSize:kbPhotoFont]];
        [_tipLabel setTextAlignment:NSTextAlignmentCenter];
        [_tipLabel setTextColor:DDY_Small_Black];
        [_tipLabel setContentHuggingPriority:UILayoutPriorityRequired forAxis:UILayoutConstraintAxisHorizontal];
        [self.collectionView addSubview:_tipLabel];
    }
    return _tipLabel;
}

#pragma mark 无权限时前往设置 getter
- (UIButton *)settingButton {
    if (!_settingButton) {
        _settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_settingButton setTitle:@"前往设置" forState:UIControlStateNormal];
        [_settingButton setTitleColor:kbPhotoTextColor forState:UIControlStateNormal];
        [_settingButton addTarget:self action:@selector(handleSetting:) forControlEvents:UIControlEventTouchUpInside];
        [_settingButton setHidden:YES];
        [self.collectionView addSubview:_settingButton];
    }
    return _settingButton;
}

#pragma mark 分割线 getter
- (UIView *)lineView {
    if (!_lineView) {
        _lineView = [[UIView alloc] init];
        _lineView.backgroundColor = kbBgBigColor;
    }
    return _lineView;
}

+ (instancetype)viewWithFrame:(CGRect)frame {
    return [[self alloc] initWithFrame:frame];
}

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = kbBgSmallColor;
        [self addSubview:self.collectionView];
        [self addSubview:self.lineView];
        [self addSubview:self.albumButton];
        [self addSubview:self.editButton];
        [self addSubview:self.orignalButton];
        [self addSubview:self.sendButton];
        
        [DDYAuthorityManager ddy_AlbumAuthAlertShow:NO success:^{
            [self loadPhotoData];
            [[PHPhotoLibrary sharedPhotoLibrary] registerChangeObserver:self];
            self.settingButton.hidden = YES;
        } fail:^(PHAuthorizationStatus authStatus) {
            self.settingButton.hidden = NO;
        }];
    }
    return self;
}

- (void)reset {
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        for (DDYPhotoModel *photoModel in self.dataArray) {
            if (photoModel.selected) {
                photoModel.selected = NO;
            }
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.collectionView reloadData];
        });
    });
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    [self.collectionView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.top.right.mas_equalTo(self);
        make.height.mas_equalTo(self).offset(-40);
    }];
    [self.lineView mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.collectionView.mas_bottom);
        make.height.mas_equalTo(0.5);
    }];
    [self.albumButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self).offset(15);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(100);
        make.height.mas_equalTo(30);
    }];
    [self.editButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.albumButton.mas_right).offset(15);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(100);
        make.height.mas_equalTo(30);
    }];
    [self.orignalButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.mas_equalTo(self.editButton.mas_right).offset(15);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(5);
        make.width.lessThanOrEqualTo(100);
        make.height.mas_equalTo(30);
    }];
    [self.sendButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.right.mas_equalTo(self).offset(-15);
        make.top.mas_equalTo(self.collectionView.mas_bottom).offset(5);
        make.width.mas_greaterThanOrEqualTo(50);
        make.height.mas_equalTo(30);
    }];
    [self.tipLabel mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.centerY.mas_equalTo(self.collectionView.mas_centerY).offset(-5);
    }];
    [self.settingButton mas_updateConstraints:^(MASConstraintMaker *make) {
        make.left.right.mas_equalTo(self);
        make.top.mas_equalTo(self.tipLabel.mas_bottom).offset(5);
    }];
    
    self.albumButton.enabled = self.settingButton.hidden;
    self.tipLabel.text = self.settingButton.hidden ? @"暂无数据" : @"要允许访问您的照片，请在设置中授权";
}

#pragma mark - UICollectionViewDataSource Delegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    [self handleJudge];
    return self.dataArray.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDYPhotoCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellID forIndexPath:indexPath];
    cell.photoModel = self.dataArray[indexPath.row];
    
    __weak __typeof (self)weakSelf = self;
    [cell setSelectBlock:^(DDYPhotoModel *model) {
        __strong __typeof (weakSelf)strongSelf = weakSelf;
        [strongSelf.collectionView reloadData];
    }];
    [cell setSwipeToSendBlock:^(DDYPhotoModel *model) {
        __strong __typeof (weakSelf)strongSelf = weakSelf;
        [strongSelf sendImages:@[model.orignalImage]];
    }];
    return cell;
}

#pragma mark - UICollectionViewDelegateFlowLayout
#pragma mark   定义每个UICollectionView 的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    DDYPhotoModel *model = self.dataArray[indexPath.row];
    return [self handleSizeWithAsset:model.asset];;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    // 预览
    DDYPhotoModel *model = self.dataArray[indexPath.row];
    
}

- (void)loadPhotoData {
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSMutableArray *tempDataArray = [NSMutableArray array];
        for (PHAsset *asset in [DDYPhotoModel latestAsset:20]) {
            DDYPhotoModel *photoModel = [[DDYPhotoModel alloc] init];
            photoModel.asset = asset;
            [tempDataArray addObject:photoModel];
        }
        dispatch_async(dispatch_get_main_queue(), ^{
            self.dataArray = tempDataArray;
            [self.collectionView reloadData];
        });
    });
}

#pragma mark - 监听到相册数据变化
- (void)photoLibraryDidChange:(PHChange *)changeInstance {
    [self loadPhotoData];
}

#pragma mark - 点击事件
#pragma mark 点击相册
- (void)handleAlbum:(UIButton *)button {
    
}

#pragma mark 点击编辑
- (void)handleEdit:(UIButton *)button {
    
}

#pragma mark 点击原图
- (void)handleOrignal:(UIButton *)button {
    button.selected = !button.selected;
}

#pragma mark 点击发送
- (void)handleSend:(UIButton *)button {
    NSMutableArray *imgArray = [NSMutableArray array];
    for (DDYPhotoModel *photoModel in self.dataArray) {
        if (photoModel.isSelected) {
            [imgArray addObject:photoModel.orignalImage];
        }
    }
    [self sendImages:imgArray];
}

#pragma mark 点击前往设置
- (void)handleSetting:(UIButton *)button {
    if (@available(iOS 10.0, *)) {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString] options:@{} completionHandler:nil];
    } else {
        [[UIApplication sharedApplication] openURL:[NSURL URLWithString:UIApplicationOpenSettingsURLString]];
    }
}

#pragma mark - 私有方法
#pragma mark 返回规定尺寸内大小
- (CGSize)handleSizeWithAsset:(PHAsset *)asset {
    CGFloat width  = (CGFloat)asset.pixelWidth;
    CGFloat height = (CGFloat)asset.pixelHeight;
    return CGSizeMake(MIN(self.collectionView.ddy_H * MAX(0.5, width/height), DDYSCREENW*3/4), self.collectionView.ddy_H);
}

#pragma mark 判断
- (void)handleJudge {
    // 提示语
    self.tipLabel.hidden = (self.dataArray.count>0);
    // 发送按钮和编辑按钮状态
    NSInteger selectCount = 0;
    self.sendButton.enabled = NO;
    for (DDYPhotoModel *photoModel in self.dataArray) {
        if (photoModel.selected) {
            self.sendButton.enabled = YES;
            selectCount ++;
        }
    }
    self.editButton.enabled = (selectCount == 1);
}

- (void)sendImages:(NSArray *)imgArray {
    if (self.sendImagesBlock) {
        self.sendImagesBlock(imgArray, self.orignalButton.selected);
    }
    [self reset];
}

@end
