//
//  ViewController.m
//  WeChatPhotoPicker
//
//  Created by Mac on 16/5/30.
//  Copyright © 2016年 Mac. All rights reserved.
//

#import "ViewController.h"
#import "XMNPhotoPickerFramework/XMNPhotoPickerFramework.h"
#import "MediaUtils.h"
#import "PromptController.h"
@implementation CollectionCell

@end

@interface ViewController ()<UICollectionViewDataSource, UICollectionViewDelegateFlowLayout>
@property (nonatomic, strong) NSMutableArray<XMNAssetModel*>* models;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.models = [NSMutableArray array];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)clear:(UIBarButtonItem *)sender {
    
    NSMutableArray* indexPathes = [NSMutableArray array];
    for (int i = 0; i < self.models.count; i++) {
        NSIndexPath* indexPath = [NSIndexPath indexPathForItem:i inSection:0];
        [indexPathes addObject:indexPath];
    }
    
    [self.models removeAllObjects];
    
    [self.collectionView deleteItemsAtIndexPaths:indexPathes];
    
//    [self.collectionView reloadData];
}

- (IBAction)getPictuer:(UIBarButtonItem *)sender {
    XMNPhotoPickerController* picker = [[XMNPhotoPickerController alloc] initWithMaxCount:9 delegate:nil];
    
    
    __weak typeof(self) weakSelf = self;
//    选择照片后回调
    [picker setDidFinishPickingPhotosBlock:^(NSArray<UIImage *> * _Nullable images, NSArray<XMNAssetModel *> * _Nullable assets) {
        NSLog(@"picker images :%@ \n\n assets:%@",images,assets);
        [weakSelf.models addObjectsFromArray:assets];
        [weakSelf.collectionView reloadData];
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
//    选择视频后回调
    [picker setDidFinishPickingVideoBlock:^(UIImage * _Nullable image, XMNAssetModel * _Nullable asset) {
        
        [weakSelf compressVideo:asset.asset];
        
        
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
        
    }];
    
//    点击取消
    [picker setDidCancelPickingBlock:^{
        [self dismissViewControllerAnimated:YES completion:^{
            
        }];
    }];
    
    [self presentViewController:picker animated:YES completion:^{
        
    }];
}

-(void)compressVideo:(PHAsset*)asset{
    [PromptManager showJPGHUDWithMessage:@"视频压缩中…" inView:self.navigationController.view];
    [MediaUtils writePHVedio:asset toPath:nil block:^(NSURL *url) {
        if (!url) {
            NSLog(@"写入失败");
            [PromptManager dismissJPGHUD];
        }else{
            NSLog(@"写入完毕 %@", url);
            
            [MediaUtils convertVideoQuailtyWithInputURL:url outputURL:nil completeHandler:^(AVAssetExportSession *exportSession, NSURL* compressedOutputURL) {
                [PromptManager dismissJPGHUD];
                if (exportSession.status == AVAssetExportSessionStatusCompleted) {
                    NSLog(@"压缩成功");
    
                    [PromptManager showSuccessJPGHUDWithMessage:@"压缩成功" intView:self.view time:1];
                    [MediaUtils deleteFileByPath:url.path];
                    
                    if ([MediaUtils getFileSize:compressedOutputURL.path] > 1024 * 1024 * 5) {
                        NSLog(@"压缩后还是大于5M");
                    }
                    
                    
                }else{ NSLog(@"压缩失败"); }
                
            }];
        }
    }];
}


#pragma mark -
#pragma mark - UICollectionViewDataSource
-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.models.count;
}

-(UICollectionViewCell*)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    CollectionCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    XMNAssetModel* model = self.models[indexPath.item];
    cell.imageView.image = model.thumbnail;
    
    return cell;
}

#pragma mark -
#pragma mark - UICollectionViewDelegateFlowLayout
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    CGFloat width = (collectionView.frame.size.width - 40) / 4.0;

    return CGSizeMake(width, width);
}


@end
