//
//  DFTextVideoLineCell.m
//  DFTimelineView
//
//  Created by CaptainTong on 15/11/13.
//  Copyright © 2015年 Datafans, Inc. All rights reserved.
//

#import "DFTextVideoLineCell.h"
#import "DFTextVideoLineItem.h"
#import <MLLabel+Size.h>
#import "AppDelegate.h"



#import "NSString+MLExpression.h"

#import "DFFaceManager.h"

#define TextFont [UIFont systemFontOfSize:14]

#define TextLineHeight 1.2f

#define TextImageSpace 10

#define VideoMaxWidth (BodyMaxWidth)*0.85

@interface DFTextVideoLineCell()
@property (strong, nonatomic) MLLinkLabel *textContentLabel;
@property(nonatomic,strong)MHGalleryItem *videoItem;



@property(strong,nonatomic)UICollectionView *view;

@end


@implementation DFTextVideoLineCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        
        [self initCell];
    }
    return self;
}

-(void)initCell{
    if (_textContentLabel == nil) {
        
        _textContentLabel =[[MLLinkLabel alloc] initWithFrame:CGRectZero];
        _textContentLabel.font = TextFont;
        _textContentLabel.numberOfLines = 0;
        _textContentLabel.adjustsFontSizeToFitWidth = NO;
        _textContentLabel.textInsets = UIEdgeInsetsZero;
        
        _textContentLabel.dataDetectorTypes = MLDataDetectorTypeAll;
        _textContentLabel.allowLineBreakInsideLinks = NO;
        _textContentLabel.linkTextAttributes = nil;
        _textContentLabel.activeLinkTextAttributes = nil;
        _textContentLabel.lineHeightMultiple = TextLineHeight;
        _textContentLabel.linkTextAttributes = @{NSForegroundColorAttributeName: HighLightTextColor};
        
        
        [_textContentLabel setDidClickLinkBlock:^(MLLink *link, NSString *linkText, MLLinkLabel *label) {
            NSString *tips = [NSString stringWithFormat:@"Click\nlinkType:%ld\nlinkText:%@\nlinkValue:%@",(unsigned long)link.linkType,linkText,link.linkValue];
            NSLog(@"%@", tips);
        }];
        
        
        [self.bodyView addSubview:_textContentLabel];
    }
    
    if (_view == nil) {
        
        
        
        UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
        
        [layout setScrollDirection:UICollectionViewScrollDirectionHorizontal];
        layout.itemSize=CGSizeMake(VideoMaxWidth, 150.0);
        //cell间距
        layout.minimumInteritemSpacing = 5.0f;
        //cell行距
        layout.minimumLineSpacing = 1.0f;
        
        CGFloat x, y , width, height;
        
        x = 0;
        y = 0;
        width = VideoMaxWidth;
        height = width;
        
        _view = [[UICollectionView alloc] initWithFrame:CGRectMake(x, y, width, height) collectionViewLayout:layout];
        //_view.backgroundColor=[UIColor blackColor];
        
        [_view registerClass:[MHMediaPreviewCollectionViewCell class] forCellWithReuseIdentifier:@"MHMediaPreviewCollectionViewCell"];
        //_view.autoresizingMask=UIViewAutoresizingFlexibleHeight|UIViewAutoresizingFlexibleWidth;
        _view.delegate=self;
        _view.dataSource=self;
        _view.userInteractionEnabled=YES;
        [self.bodyView addSubview:_view];
    }

}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    UICollectionViewCell *cell =nil;
    
    NSString *cellIdentifier = @"MHMediaPreviewCollectionViewCell";
    cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    //cell.backgroundColor=[UIColor blackColor];
    [self makeOverViewDetailCell:(MHMediaPreviewCollectionViewCell*)cell];
    
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    MHGalleryController *gallery = [MHGalleryController galleryWithPresentationStyle:MHGalleryViewModeImageViewerNavigationBarShown];
    
    NSArray *items=@[self.videoItem];
    UIImageView *imageView = [(MHMediaPreviewCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath] thumbnail];
    
    gallery.galleryItems = items;
    gallery.presentingFromImageView = imageView;
    gallery.presentationIndex = indexPath.row;
    gallery.galleryDelegate = self;
    gallery.autoplayVideos=YES;
    
    __weak MHGalleryController *blockGallery = gallery;
    gallery.finishedCallback=^(NSInteger currentIndex,UIImage *image,MHTransitionDismissMHGallery *interactiveTransition,MHGalleryViewMode viewMode){
        if (viewMode == MHGalleryViewModeOverView) {
            [blockGallery dismissViewControllerAnimated:YES completion:^{
                //[self setNeedsStatusBarAppearanceUpdate];
            }];
        }else{
            NSIndexPath *newIndexPath = [NSIndexPath indexPathForRow:currentIndex inSection:0];
            CGRect cellFrame  = [[collectionView collectionViewLayout] layoutAttributesForItemAtIndexPath:newIndexPath].frame;
            [collectionView scrollRectToVisible:cellFrame
                                       animated:NO];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                [collectionView reloadItemsAtIndexPaths:@[newIndexPath]];
                [collectionView scrollToItemAtIndexPath:newIndexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:NO];
                
                MHMediaPreviewCollectionViewCell *cell = (MHMediaPreviewCollectionViewCell*)[collectionView cellForItemAtIndexPath:newIndexPath];
                
                [blockGallery dismissViewControllerAnimated:YES dismissImageView:cell.thumbnail completion:^{
                    
                    //[self setNeedsStatusBarAppearanceUpdate];
                    
                    MPMoviePlayerController *player = interactiveTransition.moviePlayer;
                    
                    player.controlStyle = MPMovieControlStyleEmbedded;
                    player.view.frame = cell.bounds;
                    player.scalingMode = MPMovieScalingModeAspectFill;
                    [cell.contentView addSubview:player.view];
                }];
            });
        }
    };
    
    [[self getCurrentVC] presentMHGalleryController:gallery animated:YES completion:nil];
    
}

-(BOOL)galleryController:(MHGalleryController *)galleryController shouldHandleURL:(NSURL *)URL{
    return YES;
}

-(NSInteger)numberOfItemsInGallery:(MHGalleryController *)galleryController{
    return 10;
}

-(MHGalleryItem *)itemForIndex:(NSInteger)index{
    // You also have to set the image in the Testcell to get the correct Animation
    //    return [MHGalleryItem.alloc initWithImage:nil];
    return [MHGalleryItem itemWithImage:MHGalleryImage(@"twitterMH")];
}

-(UIInterfaceOrientationMask)supportedInterfaceOrientations{
    return UIInterfaceOrientationMaskPortrait;
}

-(void)updateWithItem:(DFTextVideoLineItem*)item{
    [super updateWithItem:item];
    
    self.videoItem=[[MHGalleryItem alloc]initWithURL:item.videoUrl galleryType:MHGalleryTypeVideo];
    
    CGSize textSize = [MLLinkLabel getViewSize:item.attrText maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];
    
    _textContentLabel.attributedText = item.attrText;
    [_textContentLabel sizeToFit];
    
    _textContentLabel.frame = CGRectMake(0, 0, BodyMaxWidth, textSize.height);
    
    CGFloat viewHeight=150.0;
    CGFloat x, y, width, height;
    x = _view.frame.origin.x;
    y = CGRectGetMaxY(_textContentLabel.frame)+TextImageSpace;
    width = _view.frame.size.width;
    height = viewHeight;
    _view.frame=CGRectMake(x, y, width, height);
    
    [self updateBodyView:(textSize.height+viewHeight+TextImageSpace)];
}

+(CGFloat)getCellHeight:(DFTextVideoLineItem *)item{
    
    if (item.attrText == nil) {
        item.attrText  = [item.text expressionAttributedStringWithExpression:[[DFFaceManager sharedInstance] sharedMLExpression]];
    }
    
    CGSize textSize = [MLLinkLabel getViewSize:item.attrText maxWidth:BodyMaxWidth font:TextFont lineHeight:TextLineHeight lines:0];
    
    CGFloat height = [DFBaseLineCell getCellHeight:item];
    
    CGFloat viewHeight=150.0;
    
    return (height+textSize.height+viewHeight+TextImageSpace);
}

-(void)makeOverViewDetailCell:(MHMediaPreviewCollectionViewCell*)cell{
    cell.thumbnail.contentMode=UIViewContentModeScaleAspectFill;
    cell.thumbnail.image=nil;
    cell.galleryItem=self.videoItem;
}

//获取当前屏幕显示的viewcontroller
- (UIViewController *)getCurrentVC
{
    UIViewController *result = nil;
    
    UIWindow * window = [[UIApplication sharedApplication] keyWindow];
    if (window.windowLevel != UIWindowLevelNormal)
    {
        NSArray *windows = [[UIApplication sharedApplication] windows];
        for(UIWindow * tmpWin in windows)
        {
            if (tmpWin.windowLevel == UIWindowLevelNormal)
            {
                window = tmpWin;
                break;
            }
        }
    }
    
    UIView *frontView = [[window subviews] objectAtIndex:0];
    id nextResponder = [frontView nextResponder];
    
    if ([nextResponder isKindOfClass:[UIViewController class]]){
        result = nextResponder;
    }
    else{
        result = window.rootViewController;
    }
    NSLog(@"result:%@",result);
    return result;
}

@end
