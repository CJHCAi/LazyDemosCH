//
//  FacebookImagePicker.h
//  FavorExchange
//
//  Created by Akshit on 15/02/14.
//  Copyright (c) 2014 Sujal Bandhara. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "FacebookAlbumCell.h"
#import "FacebookImagePicker.h"

@protocol FBImagePickerDelegate <NSObject>

@required

-(void)imagePickingFinishedWithImage: (NSMutableArray *)arrayRealImages;

@end

@interface FacebookAlbumPicker : UIViewController <UITableViewDataSource, UITableViewDelegate, FBImagePickerControllerDelegate, FBImagePickerControllerDelegate>

/**
 *  Delegate of Current class
 */
@property NSObject <FBImagePickerDelegate> *delegate;

/**
 *  Contains dictionary of count of photos in album, album's name, created date & album id of the current user
 */
@property (strong, nonatomic) NSArray *arrayAlbumDetails;

/**
 *  Tells that how many images are already selected for Adding in Exchange Card
 */
@property (assign, readwrite) int intAlreadySelectedImagesCount;

/**
 *  Table view which displays album list with details
 */
@property (strong, nonatomic) IBOutlet UITableView *tblFacebookAlbumList;

@end
