//
//  FacebookImagePicker.m
//  FavorExchange
//
//  Created by Akshit on 17/02/14.
//  Copyright (c) 2014 Sujal Bandhara. All rights reserved.
//

#import "FacebookImagePicker.h"
#import <FacebookSDK/FacebookSDK.h>
#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>
#import "UIImageView+WebCache.h"


@interface FacebookImagePicker ()

@end

@implementation FacebookImagePicker

@synthesize arrayFacebookImagesForAlbum;

#pragma mark - UIViewController methods

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.
    
    self.arraySelectedPhotos = [NSMutableArray arrayWithCapacity:0];
    
    [FBRequestConnection startWithGraphPath:[self.strAlbumID stringByAppendingString:@"?fields=photos"]
                                 parameters:nil
                                 HTTPMethod:@"GET"
                          completionHandler:^(
                                              FBRequestConnection *connection, id result, NSError *error)
     {
         NSLog(@"%@",result);
         
         self.arrayFacebookImagesForAlbum = result[@"photos"][@"data"];
         
         if (self.arrayFacebookImagesForAlbum.count == 0)
         {
             NSLog(@"Either the user does not have any photos in selected album or something bad happen.");
         }
         else
         {
             [self.clnPhotos reloadData];
         }
     }];
    
    [self setTitle:self.strAlbumName];
    
    [self.clnPhotos registerClass:[UICollectionViewCell class] forCellWithReuseIdentifier:@"cell"];
    [self.clnPhotos setAllowsMultipleSelection:YES];
    
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc] init];
    
    layout.minimumInteritemSpacing = 0;
    layout.itemSize = CGSizeMake(80, 80);
    layout.minimumLineSpacing = 0;
    
    [self.clnPhotos setCollectionViewLayout:layout animated:YES];
    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemDone target:self action:@selector(onDoneClick)];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Class specific methods & IBActions

-(void)onDoneClick
{
    NSMutableArray *arraySelectedRealImages = [NSMutableArray arrayWithCapacity:0];
    
    UIActivityIndicatorView *viewActivity = [[UIActivityIndicatorView alloc] initWithFrame:self.view.bounds];
    
    [self.view addSubview:viewActivity];
    
    for (int i=0; i<self.arraySelectedPhotos.count; i++)
    {
        UIImageView *imgViewTemp = [[UIImageView alloc] initWithFrame:CGRectZero];
        [self.view addSubview:imgViewTemp];
        
        NSURL *urlPhoto;
        
        NSArray *arrayImagesHD = self.arraySelectedPhotos[i][@"images"];
        
        if (arrayImagesHD.count > 0)
        {
            urlPhoto = [NSURL URLWithString:self.arraySelectedPhotos[i][@"images"][0][@"source"]];
        }
        else
        {
            urlPhoto = [NSURL URLWithString:self.arraySelectedPhotos[i][@"picture"]];
        }
        
        [imgViewTemp setImageWithURL:urlPhoto completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType)
         {
             [arraySelectedRealImages addObject:image];
             
             if (i == self.arraySelectedPhotos.count - 1)
             {
                 [self.delegate imagePickerControllerdidFinishPickingImage:arraySelectedRealImages];
                 
                 [self.navigationController dismissViewControllerAnimated:YES completion:nil];
             }
         }];
    }
}

#pragma mark - UICollectionView datasource & delegate methods

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    UICollectionViewCell *objCell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    [[objCell.contentView viewWithTag:111] removeFromSuperview];
    [[objCell.contentView viewWithTag:222] removeFromSuperview];
    
    UIImageView *imgViewPicture = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, 79, 79)];
    //    [imgViewPicture setTag:111];
    [objCell.contentView addSubview:imgViewPicture];
    
    CGSize sizeOfImageSelectedStatus = CGSizeMake(25, 25);
    
    UIImageView *imgViewSelectedStatus = [[UIImageView alloc] initWithFrame:CGRectMake(objCell.frame.size.width - sizeOfImageSelectedStatus.width, 10, 25, 25)];
    [imgViewSelectedStatus setTag:222];
    [imgViewSelectedStatus setImage:[UIImage imageNamed:@"checked.png"]];
    [objCell.contentView addSubview:imgViewSelectedStatus];
    
    if ([self.arraySelectedPhotos containsObject:self.arrayFacebookImagesForAlbum[indexPath.row]])
    {
        [imgViewSelectedStatus setHidden:NO];
    }
    else
    {
        [imgViewSelectedStatus setHidden:YES];
    }
    
    [imgViewPicture setImageWithURL:[NSURL URLWithString:self.arrayFacebookImagesForAlbum[indexPath.item][@"picture"]]];
    
    return objCell;
}

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.arrayFacebookImagesForAlbum.count;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    if (![self.arraySelectedPhotos containsObject:self.arrayFacebookImagesForAlbum[indexPath.row]])
    {
        [self.arraySelectedPhotos addObject:self.arrayFacebookImagesForAlbum[indexPath.row]];
    }
    else
    {
        [self.arraySelectedPhotos removeObject:self.arrayFacebookImagesForAlbum[indexPath.row]];
    }
    
    [self.clnPhotos reloadItemsAtIndexPaths:[NSArray arrayWithObject:indexPath]];
}

@end
