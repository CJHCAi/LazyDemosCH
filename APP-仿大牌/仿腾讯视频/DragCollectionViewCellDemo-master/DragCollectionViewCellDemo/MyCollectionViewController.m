//
//  MyCollectionViewController.m
//  DragCollectionViewCellDemo
//
//  Created by 孙宁 on 16/4/5.
//  Copyright © 2016年 孙宁. All rights reserved.
//

#import "MyCollectionViewController.h"
#import "MyCollectionViewCell.h"
#import "MyCollectionReusableView.h"
#import "FooterCollectionReusableView.h"
#import "Macro.h"

@interface MyCollectionViewController ()

@property (nonatomic, strong)UILongPressGestureRecognizer *longPress;
@property (nonatomic, strong)UITapGestureRecognizer *tap;
@property (nonatomic, strong)NSMutableArray *allChannel;
@property (nonatomic, strong)NSMutableArray *commonChannel;
@property (nonatomic, strong)NSMutableArray *otherChannel;

@property (nonatomic, assign)BOOL isEdit;
@property (nonatomic, assign)BOOL isTopY;
@property (nonatomic, assign)BOOL isBottomY;

@end

@implementation MyCollectionViewController

static NSString * const reuseIdentifier = @"Cell";
static NSString * const headerIdentifier = @"Header";
static NSString * const footerIdentifier = @"Footer";
- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    
    self.collectionView.backgroundColor = [UIColor lightGrayColor];
    // Register cell classes
    [self.collectionView registerClass:[MyCollectionViewCell class] forCellWithReuseIdentifier:reuseIdentifier];
    [self.collectionView registerClass:[MyCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:headerIdentifier];
    [self.collectionView registerClass:[FooterCollectionReusableView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:footerIdentifier];
    
    
    self.allChannel = [[NSMutableArray alloc] initWithCapacity:17];
    for (int i = 0; i < 17; i++) {
        [self.allChannel addObject:[UIImage imageNamed:[NSString stringWithFormat:@"%d.jpg",i]]];
    }
    self.commonChannel = [NSMutableArray arrayWithArray:self.allChannel];
    self.otherChannel = [NSMutableArray arrayWithCapacity:17];
    
    
    self.longPress = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPressAction:)];
    self.tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tapAction:)];
    //    [self.collectionView addGestureRecognizer:self.longPress];
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
    [button setFrame:CGRectMake(0, 0, 50, 30)];
    [button setTitle:@"Edit" forState:UIControlStateNormal];
    [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [button addTarget:self action:@selector(buttonItemAction:) forControlEvents:UIControlEventTouchUpInside];
    button.tag = 1000;
    
    UIBarButtonItem *buttonItem = [[UIBarButtonItem alloc] initWithCustomView:button];
    self.navigationItem.rightBarButtonItem = buttonItem;
    
}

- (void)buttonItemAction:(UIButton *)button
{
    if (button.tag == 1000) {
        button.tag = 1001;
        [button setTitle:@"Finish" forState:UIControlStateNormal];
        self.isEdit = YES;
        [self.collectionView addGestureRecognizer:self.longPress];
        [self.collectionView addGestureRecognizer:self.tap];
        [self.tap requireGestureRecognizerToFail:self.longPress];
        [self.collectionView reloadData];
    }
    else {
        button.tag = 1000;
        [button setTitle:@"Edit" forState:UIControlStateNormal];
        self.isEdit = NO;
        [self.collectionView removeGestureRecognizer:self.longPress];
        [self.collectionView removeGestureRecognizer:self.tap];
        [self.tap requireGestureRecognizerToFail:self.longPress];
        [self.collectionView reloadData];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
#pragma mark <UICollectionViewDelegateFlowLayout>

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForHeaderInSection:(NSInteger)section
{
    if (self.isEdit) {
        
        return CGSizeMake(KScreenWidth, 30);
    }
    else {
        
        return CGSizeZero;
    }
}

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout referenceSizeForFooterInSection:(NSInteger)section
{
    if (section == 1 && self.isEdit && self.otherChannel.count == 0) {
        
        return CGSizeMake(KScreenWidth, 60);
    }
    else {
        
        return CGSizeZero;
    }
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    
    if ([kind isEqualToString: UICollectionElementKindSectionHeader] && self.isEdit){
        
        MyCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:headerIdentifier forIndexPath:indexPath];
        if (indexPath.section == 0) {
            view.label.text = @"已定制频道（点击取消定制或拖拽排序）";
        }
        else if (indexPath.section == 1) {
            view.label.text = @"更多频道（点击定制频道）";
        }
        return view;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter] && self.isEdit && self.otherChannel.count == 0) {
        
        FooterCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        view.label.text = @"更多频道,敬请期待";
        return view;
    }
    else if ([kind isEqualToString:UICollectionElementKindSectionFooter] && self.isEdit && self.otherChannel.count != 0) {
        
        FooterCollectionReusableView *view = [collectionView dequeueReusableSupplementaryViewOfKind :kind withReuseIdentifier:footerIdentifier forIndexPath:indexPath];
        view.label.text = @"";
        return view;
    }
    else {
        return [FooterCollectionReusableView new];
    }
    
    
}
#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    if (self.isEdit) {
        
        return 2;
    }
    else {
        
        return 1;
    }
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    if (self.isEdit) {
        if (section == 0) {
            return self.commonChannel.count;
        }
        else if (section == 1) {
            return self.otherChannel.count;
        }
        else {
            return 0;
        }
    }
    else {
        return self.allChannel.count;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MyCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    cell.userInteractionEnabled = NO;
    
    if (self.isEdit) {
        
        if (indexPath.section == 0) {
            cell.imageView.image = [self.commonChannel objectAtIndex:indexPath.row];
        }
        else if (indexPath.section == 1) {
            cell.imageView.image = [self.otherChannel objectAtIndex:indexPath.row];
        }
    }
    else {
        cell.imageView.image = (UIImage *)[self.allChannel objectAtIndex:indexPath.row];
    }
    
    return cell;
}

#pragma mark - GestureAction

- (void)tapAction:(UITapGestureRecognizer *)tap
{
    CGPoint location = [tap locationInView:self.collectionView];
    
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    if (indexPath.section == 0 && indexPath.row == 0) {
        return;
    }
    
    if (indexPath.section == 0) {
        
        NSIndexPath *secondSectionIndexPath = [NSIndexPath indexPathForRow:self.otherChannel.count inSection:indexPath.section + 1];
        
        [self.otherChannel addObject:[self.commonChannel objectAtIndex:indexPath.row]];
        [self.commonChannel removeObjectAtIndex:indexPath.row];
        [self.allChannel removeAllObjects];
        [self.allChannel addObjectsFromArray:self.commonChannel];
        [self.allChannel addObjectsFromArray:self.otherChannel];
        
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:secondSectionIndexPath];
        if (self.otherChannel.count == 0 || self.otherChannel.count == 1) {
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }
    }
    else if (indexPath.section == 1) {
        
        NSIndexPath *firstSectionIndexPath = [NSIndexPath indexPathForRow:self.commonChannel.count inSection:indexPath.section - 1];
        [self.commonChannel addObject:[self.otherChannel objectAtIndex:indexPath.row]];
        [self.otherChannel removeObjectAtIndex:indexPath.row];
        [self.allChannel removeAllObjects];
        [self.allChannel addObjectsFromArray:self.commonChannel];
        [self.allChannel addObjectsFromArray:self.otherChannel];
        
        [self.collectionView moveItemAtIndexPath:indexPath toIndexPath:firstSectionIndexPath];
        if (self.otherChannel.count == 0 || self.otherChannel.count == 1) {
            [self.collectionView reloadSections:[NSIndexSet indexSetWithIndex:1]];
        }
    }
}

- (void)longPressAction:(UILongPressGestureRecognizer *)longPress
{
    UIGestureRecognizerState state = longPress.state;
    
    CGPoint location = [longPress locationInView:self.collectionView];
    NSIndexPath *indexPath = [self.collectionView indexPathForItemAtPoint:location];
    
    static UICollectionViewCell *firstCell = nil;
    static UICollectionViewCell *lastCell = nil;
    static float topY;
    static float bottomY;
    
    NSIndexPath *firstIndexPath = [NSIndexPath indexPathForRow:0 inSection:indexPath.section];
    firstCell = [self.collectionView cellForItemAtIndexPath:firstIndexPath];
    if (firstCell && self.isTopY == NO) {
        //        NSInteger numberOfSection = [self.collectionView numberOfItemsInSection:indexPath.section];
        topY = firstCell.frame.origin.y;
        self.isTopY = YES;
    }
    else if(location.y <= topY) {
        location.y = topY;
    }
    
    NSInteger numberOfSection = [self.collectionView numberOfItemsInSection:indexPath.section];
    NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:numberOfSection - 1 inSection:indexPath.section];
    lastCell = [self.collectionView cellForItemAtIndexPath:lastIndexPath];
    if (lastCell && self.isBottomY == NO) {
        
        bottomY = lastCell.frame.origin.y + lastCell.frame.size.height;
        self.isBottomY = YES;
    }
    else if(self.isBottomY == YES) {
        if (location.y >= bottomY) {
            location.y = bottomY;
        }
    }
    
    static UIView *snapshot = nil;
    static NSIndexPath *sourceIndexPath = nil;
    
    switch (state) {
            
        case UIGestureRecognizerStateBegan:
        {
            if (indexPath.section == 1 || (indexPath.section == 0 && indexPath.row == 0)) {
                return;
            }
            
            if (indexPath) {
                sourceIndexPath = indexPath;
                
                MyCollectionViewCell *cell = (MyCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:indexPath];
                if (!cell) {
                    return;
                }
                snapshot = [self customSnapshotFromView:cell];
                
                __block CGPoint center = cell.center;
                snapshot.center = center;
                
                [self.collectionView addSubview:snapshot];
                
                [UIView animateWithDuration:0.25 animations:^{
                    
                    //                    center.y = location.y;
                    //                    center.x = location.x;
                    //                    snapshot.center = center;
                    
                    snapshot.transform = CGAffineTransformMakeScale(1.05, 1.05);
                    snapshot.alpha = 0.98;
                    cell.alpha = 0;
                    cell.hidden = YES;
                }];
                
            }
        }
            break;
            
        case UIGestureRecognizerStateChanged:
        {
            CGPoint center = snapshot.center;
            center.x = location.x;
            center.y = location.y;
            snapshot.center = center;
            
            if (indexPath.section != sourceIndexPath.section) {
                return;
            }
            if (indexPath && indexPath.row != 0 && ![indexPath isEqual:sourceIndexPath]) {
                
                long fabs = indexPath.row - sourceIndexPath.row;
                if (fabs < 0) {
                    NSIndexPath *currentIndexPath = sourceIndexPath;
                    for (int i = 0; i < -fabs; i++) {
                        NSIndexPath *lastIndexPath = [NSIndexPath indexPathForRow:sourceIndexPath.row - i - 1 inSection:sourceIndexPath.section];
                        [self.commonChannel exchangeObjectAtIndex:lastIndexPath.row withObjectAtIndex:currentIndexPath.row];
                        [self.collectionView moveItemAtIndexPath:lastIndexPath toIndexPath:currentIndexPath];
                        [self.allChannel removeAllObjects];
                        [self.allChannel addObjectsFromArray:self.commonChannel];
                        [self.allChannel addObjectsFromArray:self.otherChannel];
                        currentIndexPath = lastIndexPath;
                        
                    }
                }
                else {
                    
                    NSIndexPath *currentIndexPath = sourceIndexPath;
                    for (int i = 0; i < fabs; i++) {
                        NSIndexPath *nextIndexPath = [NSIndexPath indexPathForRow:sourceIndexPath.row +i + 1 inSection:sourceIndexPath.section];
                        [self.commonChannel exchangeObjectAtIndex:nextIndexPath.row withObjectAtIndex:currentIndexPath.row];
                        [self.collectionView moveItemAtIndexPath:nextIndexPath toIndexPath:currentIndexPath];
                        [self.allChannel removeAllObjects];
                        [self.allChannel addObjectsFromArray:self.commonChannel];
                        [self.allChannel addObjectsFromArray:self.otherChannel];
                        currentIndexPath = nextIndexPath;
                    }
                }
                
                sourceIndexPath = indexPath;
            }
        }
            break;
            
        case UIGestureRecognizerStateEnded:
        {
            [snapshot removeFromSuperview];
            snapshot = nil;
            MyCollectionViewCell *cell = (MyCollectionViewCell *)[self.collectionView cellForItemAtIndexPath:sourceIndexPath];
            
            cell.hidden = NO;
            cell.alpha = 1;
            
            self.isTopY = NO;
            self.isBottomY = NO;
        }
            break;
            
        default:
            break;
    }
}


- (UIView *)customSnapshotFromView:(UIView *)inputView {
    
    // Make an image from the input view.
    UIGraphicsBeginImageContextWithOptions(inputView.bounds.size, NO, 0);
    [inputView.layer renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    // Create an image view.
    UIView *snapshot = [[UIImageView alloc] initWithImage:image];
    snapshot.layer.masksToBounds = NO;
    snapshot.layer.cornerRadius = 0.0;
    snapshot.layer.shadowOffset = CGSizeMake(-5.0, 0.0);
    snapshot.layer.shadowRadius = 5.0;
    snapshot.layer.shadowOpacity = 0.4;
    
    return snapshot;
}
#pragma mark <UICollectionViewDelegate>

/*
 // Uncomment this method to specify if the specified item should be highlighted during tracking
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
 }
 */

/*
 // Uncomment this method to specify if the specified item should be selected
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
 return YES;
 }
 */

/*
 // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
 - (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
 }
 
 - (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
 }
 
 - (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
 }
 */

@end
