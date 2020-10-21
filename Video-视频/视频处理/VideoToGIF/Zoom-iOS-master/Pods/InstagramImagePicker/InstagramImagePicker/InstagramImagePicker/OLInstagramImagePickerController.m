//
//  InstagramImagePickerViewController.m
//  Ps
//
//  Created by Deon Botha on 09/12/2013.
//  Copyright (c) 2013 dbotha. All rights reserved.
//

#import "OLInstagramImagePickerController.h"
#import "OLInstagramMediaRequest.h"
#import "OLInstagramImage.h"
#import "OLInstagramImagePickerCell.h"
#import "OLInstagramLoginWebViewController.h"
#import "OLInstagramImagePickerConstants.h"
#import <PECropViewController.h>


#import <NXOAuth2.h>

static const BOOL kDebugForceLogin = NO; // if YES then the user will always be presented with the login view controller first regardless of their authentication state

static NSString *const kSupplementaryViewFooterReuseIdentifier = @"co.oceanlabs.ps.kSupplementaryViewHeaderReuseIdentifier";
static NSString *const kImagePickerCellReuseIdentifier = @"co.oceanlabs.ps.kImagePickerCellReuseIdentifier";

@interface InstagramSupplementaryView : UICollectionReusableView
@end

@interface OLInstagramImagePickerViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (nonatomic, strong) NSArray/*<OLInstagramImage>*/ *selected;
@property (nonatomic, strong) NSMutableArray/*<OLInstagramImage>*/ *selectedImagesInFuturePages; // selected images that don't yet occur in collectionView.indexPathsForSelectedItems as the user needs to load more instagram pages first
@property (nonatomic, assign) BOOL startImageLoadingOnViewDidLoad;
@property (nonatomic, weak) IBOutlet UICollectionView *collectionView;
@property (nonatomic, weak) IBOutlet UIActivityIndicatorView *loadingIndicator;
@property (nonatomic, strong) NSMutableArray *media;
@property (nonatomic, strong) OLInstagramMediaRequest *inProgressMediaRequest;
@property (nonatomic, strong) OLInstagramMediaRequest *nextMediaRequest;
@property (nonatomic, strong) NSArray *overflowMedia; // We can only insert multiples of 4 images each request, overflow must be saved and inserted on a subsequent request.
- (void)startImageLoading;
@end

@interface OLInstagramImagePickerController () <OLInstagramLoginWebViewControllerDelegate>
@property (nonatomic, strong) OLInstagramLoginWebViewController *loginVC;
@property (nonatomic, strong) OLInstagramImagePickerViewController *imagePickerVC;

- (void)flipToInstagramLoginController;
- (void)flipToImagePickerController;
@end

@implementation OLInstagramImagePickerViewController

- (id)init {
    if (self = [super init]) {
        self.media = [[NSMutableArray alloc] init];
        self.selectedImagesInFuturePages = [[NSMutableArray alloc] init];
        self.overflowMedia = @[];
    }
    
    return self;
}

-(void)showTheThing:(UITapGestureRecognizer *)thisTap{
    //NSLog(@"LOG THE THING SPONSE");
    PECropViewController *controller = [[PECropViewController alloc] init];
    OLInstagramImagePickerCell *cell = (OLInstagramImagePickerCell *)thisTap.view;
    NSData *data = [NSData dataWithContentsOfURL:cell.fullURL];
    UIImage *image = [UIImage imageWithData:data];
    controller.keepingCropAspectRatio = YES;
    
    controller.delegate = self;
    controller.image = image;
    
    //controller.image =
    //controller.image = self.selectedImagesInFuturePages[0];
    //controller.image = self.selectedImagesInFuturePages[0];
    [self showViewController:controller sender:self];
}

- (void)cropViewController:(PECropViewController *)controller didFinishCroppingImage:(UIImage *)croppedImage
{
    //[controller dismissViewControllerAnimated:YES completion:NULL];
    
    NSArray *myArray = [[NSArray alloc]
                        initWithObjects:croppedImage,
                        nil];
    self.selected = [myArray copy];
    //[self.delegate photoViewControllerDoneClicked:self];
    
    //self.imageView.image = croppedImage;
    [self onButtonDoneClicked];
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.navigationController.navigationBar.barTintColor = [UIColor colorWithRed:41.0/256.0 green:41.0/256.0 blue:41.0/256.0 alpha:1.0];//[UIColor darkGrayColor];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:20.0/256.0 green:236.0/256.0 blue:153.0/256.0 alpha:1.0];//[UIColor darkGrayColor];
    self.navigationController.navigationBar.translucent = NO;
    self.title = NSLocalizedString(@"My Instagram Photos", @"");
    [self.navigationController.navigationBar
     setTitleTextAttributes:@{NSForegroundColorAttributeName : [UIColor whiteColor]}];
    
    self.navigationItem.titleView.tintColor = [UIColor whiteColor];
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:87.0/256.0 green:87.0/256.0 blue:87.0/256.0 alpha:1.0];
    [[UIApplication sharedApplication] setStatusBarStyle:UIStatusBarStyleLightContent];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Cancel", @"") style:UIBarButtonItemStylePlain target:self action:@selector(onButtonDoneClicked)];
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:NSLocalizedString(@"Logout", @"") style:UIBarButtonItemStylePlain target:self action:@selector(onButtonLogoutClicked)];
    
    CGFloat itemSize = MIN([UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width)/4.0 - 1.0;
    
    UICollectionViewFlowLayout *layout  = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize                     = CGSizeMake(itemSize, itemSize);
    layout.sectionInset                 = UIEdgeInsetsMake(9.0, 0, 0, 0);
    layout.minimumInteritemSpacing      = 1.0;
    layout.minimumLineSpacing           = 1.0;
    layout.footerReferenceSize          = CGSizeMake(0, 0);
    self.collectionView.collectionViewLayout = layout;
    self.collectionView.allowsMultipleSelection = NO;
    
    [self.collectionView registerClass:[InstagramSupplementaryView class] forSupplementaryViewOfKind:UICollectionElementKindSectionFooter withReuseIdentifier:kSupplementaryViewFooterReuseIdentifier];
    [self.collectionView registerClass:[OLInstagramImagePickerCell class] forCellWithReuseIdentifier:kImagePickerCellReuseIdentifier];
    
    if (self.startImageLoadingOnViewDidLoad) {
        [self startImageLoading];
    }

    // Hide the back button and set custom title view that looks the same as the default. The reason for this is because by default
    // when this view is pushed onto the navigation stack these items would animate, we actually don't want that behaviour as our
    // push view controller transition is a flip of the screen.
    [self.navigationItem setHidesBackButton:YES];
    UILabel *title = [[UILabel alloc] init];
    title.text = self.title;
    title.font = [UIFont boldSystemFontOfSize:title.font.pointSize];
    [title sizeToFit];
    title.textColor = [UIColor whiteColor];
    self.navigationItem.titleView = title;
}

- (void)startImageLoading {
    self.loadingIndicator.hidden = NO;
    self.media = [[NSMutableArray alloc] init];
    self.nextMediaRequest = [[OLInstagramMediaRequest alloc] init];
    self.overflowMedia = @[];
    [self.collectionView reloadData];
    [self loadNextPage];
}

- (void)loadNextPage {
    self.inProgressMediaRequest = self.nextMediaRequest;
    self.nextMediaRequest = nil;
    [self.inProgressMediaRequest fetchMediaWithCompletionHandler:^(NSError *error, NSArray *media, OLInstagramMediaRequest *nextRequest) {
        self.inProgressMediaRequest = nil;
        self.nextMediaRequest = nextRequest;
        self.loadingIndicator.hidden = YES;
        
        if (error) {
            // clear all accounts and redo login...
            if (error.domain == kOLInstagramImagePickerErrorDomain && error.code == kOLInstagramImagePickerErrorCodeOAuthTokenInvalid) {
                // need to renew auth token, start by clearing any accounts. A new one will be created as part of the login process.
                NSArray *instagramAccounts = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"instagram"];
                for (NXOAuth2Account *account in instagramAccounts) {
                    [[NXOAuth2AccountStore sharedStore] removeAccount:account];
                }
                
                [((OLInstagramImagePickerController *) self.navigationController) flipToInstagramLoginController];
            } else {
                OLInstagramImagePickerController *imagePicker = (OLInstagramImagePickerController *) self.navigationController;
                [imagePicker.delegate instagramImagePicker:imagePicker didFailWithError:error];
            }
            
            return;
        }
        
        NSAssert(self.overflowMedia.count < 4, @"oops");
        NSUInteger mediaStartCount = self.media.count;
        [self.media addObjectsFromArray:self.overflowMedia];
        if (nextRequest != nil) {
            // only insert multiple of 4 images so we fill complete rows
            NSInteger overflowCount = (self.media.count + media.count) % 4;
            [self.media addObjectsFromArray:[media subarrayWithRange:NSMakeRange(0, media.count - overflowCount)]];
            self.overflowMedia = [media subarrayWithRange:NSMakeRange(media.count - overflowCount, overflowCount)];
        } else {
            // we've exhausted all the users images so show the remainder
            [self.media addObjectsFromArray:media];
            self.overflowMedia = @[];
        }
        
        // Insert new items
        NSMutableArray *addedItemPaths = [[NSMutableArray alloc] init];
        for (NSUInteger itemIndex = mediaStartCount; itemIndex < self.media.count; ++itemIndex) {
            [addedItemPaths addObject:[NSIndexPath indexPathForItem:itemIndex inSection:0]];
        }
        
        [self.collectionView insertItemsAtIndexPaths:addedItemPaths];
        ((UICollectionViewFlowLayout *) self.collectionView.collectionViewLayout).footerReferenceSize = CGSizeMake(0, nextRequest == nil ? 0 : 44);
        
        // If any of the items in the newly loaded page were previously selected then make them selected
        NSMutableArray *selectedItemsInThisPage = [[NSMutableArray alloc] init];
        for (NSUInteger itemIndex = mediaStartCount; itemIndex < self.media.count; ++itemIndex) {
            OLInstagramImage *image = self.media[itemIndex];
            if ([self.selectedImagesInFuturePages indexOfObject:image] != NSNotFound) {
                [selectedItemsInThisPage addObject:image];
                [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
            }
        }
        [self.selectedImagesInFuturePages removeObjectsInArray:selectedItemsInThisPage];
    }];
}

- (void)onButtonLogoutClicked {
    NSHTTPCookie *cookie;
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    NSArray *cookies = [NSArray arrayWithArray:[storage cookies]];
    for (cookie in cookies) {
        if ([cookie.domain containsString:@"instagram.com"]) {
            [storage deleteCookie:cookie];
        }
    }
    
    NSArray *instagramAccounts = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"instagram"];
    for (NXOAuth2Account *account in instagramAccounts) {
        [[NXOAuth2AccountStore sharedStore] removeAccount:account];
    }
    
    [((OLInstagramImagePickerController *) self.navigationController) flipToInstagramLoginController];
}

- (void)onButtonDoneClicked {
    [self.inProgressMediaRequest cancel];
    OLInstagramImagePickerController *picker = (OLInstagramImagePickerController *) self.navigationController;
    [picker.delegate instagramImagePicker:picker didFinishPickingImages:self.selected];
}

- (NSArray *)selected {
    NSMutableArray *selectedItems = [[NSMutableArray alloc] init];
    NSArray *selectedPaths = self.collectionView.indexPathsForSelectedItems;
    for (NSIndexPath *path in selectedPaths) {
        OLInstagramImage *instagramImage = [self.media objectAtIndex:path.row];
        [selectedItems addObject:instagramImage];
    }
    
    [selectedItems addObjectsFromArray:self.selectedImagesInFuturePages];
    
    return selectedItems;
}

- (void)setSelected:(NSArray *)selected {
    // clear currently selected
    for (NSIndexPath *path in self.collectionView.indexPathsForSelectedItems) {
        [self.collectionView deselectItemAtIndexPath:path animated:NO];
    }

    // select any items in the collection view as appropriate, any items that have yet to be downloaded (due to the user not scrolling far enough)
    // are stored for selecting later when we fetch future pages.
    NSMutableArray *selectedImagesInFuturePages = [[NSMutableArray alloc] init];
    for (OLInstagramImage *image in selected) {
        NSUInteger itemIndex = [self.media indexOfObject:image];
        if (itemIndex == NSNotFound) {
            [selectedImagesInFuturePages addObject:image];
        } else {
            [self.collectionView selectItemAtIndexPath:[NSIndexPath indexPathForItem:itemIndex inSection:0] animated:NO scrollPosition:UICollectionViewScrollPositionNone];
        }
    }
    
    self.selectedImagesInFuturePages = selectedImagesInFuturePages;
}

+ (UIViewController*) topMostController
{
    UIViewController *topController = [UIApplication sharedApplication].keyWindow.rootViewController;
    
    while (topController.presentedViewController) {
        topController = topController.presentedViewController;
    }
    
    return topController;
}

-(void) updateTitleWithSelectedIndexPaths:(NSArray *)indexPaths{
    // Reset title to group name
    if (indexPaths.count == 0)
    {
        self.parentViewController.title = NSLocalizedString(@"Add Photos", @"");
        return;
    }
    
    NSString *format = (indexPaths.count > 1) ? NSLocalizedString(@"%ld Photos Selected", nil) : NSLocalizedString(@"%ld Photo Selected", nil);
    
    self.title = [NSString stringWithFormat:format, (unsigned long) indexPaths.count];
     ((UILabel *)self.navigationItem.titleView).text= self.title;
    [((UILabel *)self.navigationItem.titleView) sizeToFit];
}

#pragma mark - UICollectionViewDataSource methods

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    return self.media.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    OLInstagramImagePickerCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:kImagePickerCellReuseIdentifier forIndexPath:indexPath];
    [cell bind:[self.media objectAtIndex:indexPath.item]];
    
    UITapGestureRecognizer *thisTapped = [[UITapGestureRecognizer alloc]initWithTarget:self action:@selector(showTheThing:)];
    [cell addGestureRecognizer:thisTapped];

    
    return cell;
}

- (UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath {
    InstagramSupplementaryView *v = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:kSupplementaryViewFooterReuseIdentifier forIndexPath:indexPath];
    return v;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    // this is actually the UICollectionView scrollView
    if (self.inProgressMediaRequest == nil && scrollView.contentOffset.y >= self.collectionView.contentSize.height - self.collectionView.frame.size.height) {
        // we've reached the bottom, lets load the next page of instagram images.
        [self loadNextPage];
    }
}

-(void) collectionView:(UICollectionView *)collectionView didDeselectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self updateTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}

-(void) collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self updateTitleWithSelectedIndexPaths:collectionView.indexPathsForSelectedItems];
}

@end

#pragma mark - SupplementaryView

@implementation InstagramSupplementaryView

- (id)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        UIActivityIndicatorView *ai = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhite];
        ai.frame = CGRectMake((frame.size.width - ai.frame.size.width) / 2, (frame.size.height - ai.frame.size.height) / 2, ai.frame.size.width, ai.frame.size.height);
        ai.color = [UIColor grayColor];
        [ai startAnimating];
        [self addSubview:ai];
    }
    
    return self;
}

@end

#pragma mark - OLInstagramImagePickerController implementation

@implementation OLInstagramImagePickerController

@dynamic delegate;

- (id)init {
    NSAssert(NO, @"Please use OLInstagramImagePickerController initWithClientId:secret");
    return nil;
}

- (id)initWithClientId:(NSString *)clientId secret:(NSString *)secret redirectURI:(NSString *)redirectURI {
    static BOOL doneInit = NO;
    if (!doneInit) {
        [[NXOAuth2AccountStore sharedStore] setClientID:clientId
                                                 secret:secret
                                       authorizationURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/authorize"]
                                               tokenURL:[NSURL URLWithString:@"https://api.instagram.com/oauth/access_token/"]
                                            redirectURL:[NSURL URLWithString:redirectURI]
                                         forAccountType:@"instagram"];
    }
    
    NSArray *instagramAccounts = [[NXOAuth2AccountStore sharedStore] accountsWithAccountType:@"instagram"];
    if (kDebugForceLogin) {
        for (NXOAuth2Account *account in instagramAccounts) {
            [[NXOAuth2AccountStore sharedStore] removeAccount:account];
        }
        
        instagramAccounts = @[];
    }
    
    OLInstagramLoginWebViewController *loginVC = [[OLInstagramLoginWebViewController alloc] init];
    loginVC.redirectURI = redirectURI;
    OLInstagramImagePickerViewController *imagePickerVC = [[OLInstagramImagePickerViewController alloc] init];
    
    UIViewController *openingController = nil;
    if (instagramAccounts.count == 0) {
        // user needs to login
        openingController = loginVC;
    } else {
        // user has logged in so jump directly to photos
        openingController = imagePickerVC;
        imagePickerVC.startImageLoadingOnViewDidLoad = YES;
    }
    
    if (self = [super initWithRootViewController:openingController]) {
        [self addInstagramLoginObservers];
        self.loginVC = loginVC;
        self.imagePickerVC = imagePickerVC;
        self.loginVC.delegate = self;
    }
    
    return self;
}

- (void)setSelected:(NSArray *)selected {
    self.imagePickerVC.selected = selected;
}

- (NSArray *)selected {
    return self.imagePickerVC.selected;
}

- (BOOL)isShowingLoginController {
    return [self.topViewController isMemberOfClass:[OLInstagramLoginWebViewController class]];
}

- (BOOL)isShowingImagePickerViewController {
    return [self.topViewController isMemberOfClass:[OLInstagramImagePickerViewController class]];
}

- (void)addInstagramLoginObservers {
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInstagramOAuthAuthenticateFail:) name:NXOAuth2AccountStoreDidFailToRequestAccessNotification object:[NXOAuth2AccountStore sharedStore]];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(onInstagramOAuthAccountStoreDidChange:) name:NXOAuth2AccountStoreAccountsDidChangeNotification object:[NXOAuth2AccountStore sharedStore]];
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NXOAuth2AccountStoreDidFailToRequestAccessNotification object:[NXOAuth2AccountStore sharedStore]];
    [[NSNotificationCenter defaultCenter] removeObserver:self name:NXOAuth2AccountStoreAccountsDidChangeNotification object:[NXOAuth2AccountStore sharedStore]];
}

- (void)flipToInstagramLoginController {
    [self flipToViewController:self.loginVC];
}

- (void)flipToImagePickerController {
    NSArray *currentSelected = self.imagePickerVC.selected;
    [self.imagePickerVC startImageLoading];
    self.imagePickerVC.selected = currentSelected;
    [self flipToViewController:self.imagePickerVC];
}

- (void)flipToViewController:(UIViewController *)vc {
    [UIView animateWithDuration:0.75
                     animations:^{
                         [UIView setAnimationCurve:UIViewAnimationCurveEaseInOut];
                         [self setViewControllers:@[vc] animated:NO];
                         [UIView setAnimationTransition:UIViewAnimationTransitionFlipFromRight forView:self.view cache:NO];
                     }];
}

#pragma mark - Instagram Oauth notification callbacks

- (void)onInstagramOAuthAuthenticateFail:(NSNotification *)notification {
    NSString *localizedErrorMessage = NSLocalizedString(@"Failed to log in to Instagram. Please check your internet connectivity and try again", @"");
    [self.delegate instagramImagePicker:self didFailWithError:[NSError errorWithDomain:kOLInstagramImagePickerErrorDomain code:kOLInstagramImagePickerErrorOAuthLoginFailed userInfo:@{NSLocalizedDescriptionKey: localizedErrorMessage}]];
}

- (void)onInstagramOAuthAccountStoreDidChange:(NSNotification *)notification {
    NXOAuth2Account *account = [notification.userInfo objectForKey:NXOAuth2AccountStoreNewAccountUserInfoKey];
    if (account) {
        // a new account has been created
        [self flipToImagePickerController];
    }
}

#pragma mark - OLInstagramLoginWebViewControllerDelegate methods

- (void)instagramLoginWebViewControllerDidCancelLogIn:(OLInstagramLoginWebViewController *)loginController {
    NSAssert([self isShowingLoginController], @"Oops");
    [self.delegate instagramImagePickerDidCancelPickingImages:self];
}

- (void)instagramLoginWebViewControllerDidCompleteSuccessfully:(OLInstagramLoginWebViewController *)loginController {
    // shouldn't need to do anything as we'll soon get one of the OAuth callbacks...
}

- (void)instagramLoginWebViewControllerDidComplete:(OLInstagramLoginWebViewController *)loginController withError:(NSError *)error {
    [self.delegate instagramImagePicker:self didFailWithError:error];
}

@end
