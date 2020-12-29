//
//  HKCellImagePickView.m
//  HongKZH_IOS
//
//  Created by hkzh on 2018/7/20.
//  Copyright © 2018年 hkzh. All rights reserved.
//

#import "HKCellImagePickView.h"

@interface HKCellImagePickView () <UICollectionViewDelegate,UICollectionViewDataSource,UINavigationControllerDelegate, UIImagePickerControllerDelegate,UIActionSheetDelegate>

@property (nonatomic, weak) UICollectionView *collectionView;

@end

@implementation HKCellImagePickView

#pragma mark 初始化方法

//#define DEFAULT_LEFT_MARGIN   15        //默认距离左边距离15

//- (instancetype)init {
//    return [self initWithImages:nil leftMargin:DEFAULT_LEFT_MARGIN delegate:nil];
//}

- (NSMutableArray<UIImage *> *)pickImages {
    NSMutableArray *pickImages = [NSMutableArray array];
    NSMutableArray *realImgs = [NSMutableArray array];
    if ([self.images count] > 1) {
        pickImages = [NSMutableArray arrayWithArray:self.images];
        [pickImages removeLastObject];
    }
    for (id image in pickImages) {
        if ([image isKindOfClass:[UIImage class]]) {
            [realImgs addObject:image];
        }
    }
    return realImgs;
}

- (instancetype)initWithImages:(NSMutableArray *)images  leftMargin:(CGFloat)leftMargin delegate:(UIViewController *)delegate{
    if (self = [super init]) {
        self.images = images;
        self.leftMargin = leftMargin;
        self.delegate = delegate;
        [self setUpUI];
    }
    return self;
}

+ (instancetype)cellImagePickViewWithImages:(NSMutableArray *)images leftMargin:(CGFloat)leftMargin delegate:(UIViewController *)delegate {
    HKCellImagePickView *view = [[HKCellImagePickView alloc] initWithImages:images leftMargin:leftMargin delegate:delegate];
    return view;
}

- (void)setImages:(NSMutableArray *)images {
    if (images == nil) {
        images = [NSMutableArray array];
        //插入默认图
        UIImage *defaultImage = [UIImage imageNamed:@"fbsp2jiat"];
        [images addObject:defaultImage];
    } else {
//        if ([images count] == 0) {
//            //插入默认图
//            UIImage *defaultImage = [UIImage imageNamed:@"fbsp2jiat"];
//            [images addObject:defaultImage];
//        }
        //插入默认图
        UIImage *defaultImage = [UIImage imageNamed:@"fbsp2jiat"];
        [images addObject:defaultImage];
    }
    _images = images;
}

//添加子控件
- (void)setUpUI {
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
    [collectionView registerClass:[HKCellImagePickCell class] forCellWithReuseIdentifier:NSStringFromClass([HKCellImagePickCell class])];
    //布局 CollectionView
    [collectionView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.equalTo(self).offset(self.leftMargin);
        make.right.equalTo(self).offset(-self.leftMargin);
        make.top.centerY.equalTo(self);
    }];
}

#pragma mark UICollectionViewDataSource, UICollectionViewDelegate

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.images.count;
}

//是否是默认图
- (BOOL)isDefaultImage:(UIImage *)image
{
    return [image isEqual:self.images[self.images.count-1]];
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    HKCellImagePickCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:NSStringFromClass([HKCellImagePickCell class]) forIndexPath:indexPath];
    
//    UIImage *img = self.images[indexPath.row];
//    cell.imgView.image = img;
    id img = self.images[indexPath.row];
    if ([img isKindOfClass:[UIImage class]]) {
        //是否是默认图,默认图不可删除
        if (![self isDefaultImage:img]) {
            cell.canEdit = YES;
        }else{
            cell.canEdit = NO;
        }
        cell.imgView.image = img;
    } else if ([img isKindOfClass:[HKEditResumeDataImgs class]]) {
        HKEditResumeDataImgs *obj = (HKEditResumeDataImgs *)img;
        cell.imageData = obj;
    }
//    @weakify(self);
    cell.deleteButtonClicked = ^(UIImage *image, HKEditResumeDataImgs *imageData) {
//        @strongify(self);
        if (imageData && imageData.imgSrc) {
            if (self.deleteNetImageBlock) {
                self.deleteNetImageBlock(imageData);
            }
        } else if (image && imageData == nil){
            [self.images removeObject:image];
            [self.collectionView reloadData];
        }
    };
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (indexPath.row == self.images.count - 1) {
        [self choosePic];
    }
}

//选择图片
- (void)choosePic
{
    //自定义消息框
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择"
                                                       delegate:self
                                              cancelButtonTitle:@"取消"
                                         destructiveButtonTitle:nil
                                              otherButtonTitles:@"拍照",@"从相册选择", nil];
    //显示消息框
    [sheet showInView:self.delegate.view];
}

#pragma mark -消息框代理实现-
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    // 判断系统是否支持相机
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    imagePickerController.delegate = self; //设置代理
    //    imagePickerController.allowsEditing = YES;
    
    if (buttonIndex == 0) {
        //拍照
        imagePickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        
        [self.delegate presentViewController:imagePickerController animated:YES completion:nil];
    }else if (buttonIndex == 1){
        //相册
        imagePickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
        [self.delegate presentViewController:imagePickerController animated:YES completion:nil];
    }
    
}

#pragma mark -实现图片选择器代理-（上传图片的网络请求也是在这个方法里面进行，这里我不再介绍具体怎么上传图片）
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^{}];
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage]; //通过key值获取到图片
    
    [self.images insertObject:image atIndex:self.images.count-1];
    
    if (self.CellPickImageBlock) {
        self.CellPickImageBlock([self pickImages]);
    }
    [self.collectionView reloadData];
}

//当用户取消选择的时候，调用该方法
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^{}];
}

@end

#pragma mark - collection item cell

@implementation HKCellImagePickCell

- (instancetype)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        [self initUI];
        [self layoutUI];
    }return self;
}

- (void)initUI
{
    self.backgroundColor = RGB(241, 241, 241);
    
    _imgView = [HKComponentFactory imageViewWithFrame:self.contentView.bounds
                                                image:[UIImage imageNamed:@"morerpic"]
                                           supperView:self.contentView];
    _imgView.contentMode = UIViewContentModeScaleAspectFit;
    _imgView.clipsToBounds = YES;
    
    
    //close button
    _btnClose = [HKComponentFactory buttonWithType:UIButtonTypeCustom
                                             frame:CGRectZero
                                             taget:self
                                            action:@selector(deleteButtonClickedAction)
                                        supperView:self.contentView];
    [_btnClose setImage:[UIImage imageNamed:@"group_close"] forState:UIControlStateNormal];
    
}

- (void)setCanEdit:(BOOL)canEdit
{
    _canEdit = canEdit;
    if (canEdit) {
        _btnClose.hidden= NO;
//        _imgView.layer.borderColor = [UIColor whiteColor].CGColor;
//        _imgView.layer.borderWidth = 0.f;
    }else{
        _btnClose.hidden= YES;
//        _imgView.layer.borderColor = RGB(241,241,241).CGColor;
//        _imgView.layer.borderWidth = 1.f;
    }
}
- (void)setImageData:(HKEditResumeDataImgs *)imageData {
    if (imageData) {
        _imageData = imageData;
        [self.imgView sd_setImageWithURL:[NSURL URLWithString:imageData.imgSrc]];
    }
}

- (void)layoutUI
{
    [_imgView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.left.bottom.right.equalTo(self.contentView);
    }];
    
    //close
    [_btnClose mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self.contentView).offset(5);
        make.right.equalTo(self.contentView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(15, 15));
    }];
}

+ (CGSize)itemSize
{
    return CGSizeMake(70, 70);
}

#pragma mark - action

- (void)deleteButtonClickedAction
{
    if (self.deleteButtonClicked) {
        self.deleteButtonClicked(self.imgView.image, self.imageData);
    }
}

@end



