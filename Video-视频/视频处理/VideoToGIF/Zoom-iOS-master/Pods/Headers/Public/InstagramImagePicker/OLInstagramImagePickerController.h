//
//  InstagramImagePickerViewController.h
//  Ps
//
//  Created by Deon Botha on 09/12/2013.
//  Copyright (c) 2013 dbotha. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <PECropViewController.h>

@class OLInstagramImagePickerController;

/**
 The OLInstagramImagePickerControllerDelegate protocol defines methods that your delegate object must implement to interact with the image picker interface. 
 The methods of this protocol notify your delegate when the user completes picking, cancels the picker operation or if an error arises (i.e. due to network
 connectivity issues, etc).
 */
@protocol OLInstagramImagePickerControllerDelegate <NSObject>

/**
 Tells the delegate that the image picking operation failed with an error.
 
 @param imagePicker The OLInstagramImagePickerController picker instance that you instantiated to facilitate the picking operation
 @param error An NSError object describing the issue
 */
- (void)instagramImagePicker:(OLInstagramImagePickerController *)imagePicker didFailWithError:(NSError *)error;

/**
 Tells the delegate that the user finished picking images from their instagram collection.
 
 @param imagePicker The OLInstagramImagePickerController picker instance that you instantiated to facilitate the picking operation
 @param images An array of OLInstagramImage objects representing the images the user picked. If the user picked no images this array will be empty.
 */
- (void)instagramImagePicker:(OLInstagramImagePickerController *)imagePicker didFinishPickingImages:(NSArray/*<OLInstagramImage>*/ *)images;

/**
 Tells the delegate that the user did cancel picking images
 
 @param imagePicker The OLInstagramImagePickerController picker instance that you instantiated to facilitate the picking operation
 */
- (void)instagramImagePickerDidCancelPickingImages:(OLInstagramImagePickerController *)imagePicker;
@end

/** 
 The OLInstagramImagePickerController class provides a simple UI for a user to pick photos from their Instagram account. It
 provides an image picker interface that matches the iOS SDK's UIIMagePickerController. It takes care of all
 authentication (via OAuth2) with Instagram as and when necessary. It will automatically renew auth tokens or prompt 
 the user to re-authorize the app if needed.
 */
@interface OLInstagramImagePickerController : UINavigationController <PECropViewControllerDelegate>


/** 
 Initialises a new OLInstagramImagePickerController object instance. The underlying Instagram API requests will be made using
 the supplied client id & secret. You can find these details (or register a new client) at 
 http://instagram.com/developer/clients/manage/ .
 
 @param clientId Your Instagram client id found
 @param secret The associated secret for the clientId
 @param redirectURI The redirect uri scheme of the app
 @return Returns an initialised instance of OLInstagramImagePickerController
 */
- (id)initWithClientId:(NSString *)clientId secret:(NSString *)secret redirectURI:(NSString *)URI;

/**
 Holds the currently user selected images in the picker UI. Setting this property will result in the corresponding images in the picker UI updating.
 */
@property (nonatomic, copy) NSArray/*<OLInstagramImage>*/ *selected;

/**
 The image picker’s delegate object.
 */
@property (nonatomic, weak) id<UINavigationControllerDelegate, OLInstagramImagePickerControllerDelegate> delegate;

@end
