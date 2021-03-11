//
//  ZQAlbumListVC.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/5/25.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import "ZQAlbumListVC.h"
#import "ZQPhotoFetcher.h"
#import "ZQAlbumListCell.h"
#import "ZQAlbumVC.h"
#import "ZQAlbumNavVC.h"
#import <Photos/Photos.h>
#import <PhotosUI/PhotosUI.h>
#import "ZQAlbumModel.h"
#import "ZQPublic.h"
#import "NSString+Size.h"
#import "ViewUtils.h"

@interface ZQAlbumListVC () <UITableViewDelegate, UITableViewDataSource>
@property (nonatomic, strong) UITableView *tableView;


@end
@implementation ZQAlbumListVC


#pragma mark - Life Cycle

- (void)viewDidLoad {
    [super viewDidLoad];
    [self initUI];
    if ([ZQPhotoFetcher authorizationStatusAuthorized]) {
        [self loadAlbums];
    }
    
}

- (void)initUI {
    NSString* title = _LocalizedString(@"OPERATION_CANCEL");
    CGSize s = [title textSizeWithFont:[UIFont systemFontOfSize:17] constrainedToSize:CGSizeMake(999, 999) lineBreakMode:NSLineBreakByWordWrapping];
    UIButton* btnRight = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, s.width+10, 48)];
    [btnRight setTitleColor:ZQChoosePhotoNavBtnColor forState:UIControlStateNormal];
    [btnRight setTitle:title forState:UIControlStateNormal];
    [btnRight addTarget:self action:@selector(cancel) forControlEvents:UIControlEventTouchUpInside];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView:btnRight];
    
    self.navigationItem.title = _LocalizedString(@"PHOTO");
    
    CGFloat topMargin = self.navigationController.navigationBar.frame.size.height + [UIApplication sharedApplication].statusBarFrame.size.height;
    CGRect tableViewFrame = CGRectMake(self.view.frame.origin.x, self.view.frame.origin.y+topMargin, kTPScreenWidth, kTPScreenHeight-topMargin);
    self.tableView = [[UITableView alloc] initWithFrame:tableViewFrame style:(UITableViewStylePlain)];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    [self.view addSubview:self.tableView];
    [self.tableView registerClass:[ZQAlbumListCell class] forCellReuseIdentifier:NSStringFromClass([ZQAlbumListCell class])];
}


- (void)cancel {
    [self.navigationController.presentingViewController dismissViewControllerAnimated:YES completion:nil];
}

- (void)loadAlbums {
    ______WS();
    [ZQPhotoFetcher getAllAlbumsWithType:self.type completion:^(NSArray<ZQAlbumModel *> * _Nonnull albums) {
        wSelf.albums = albums;
        if (albums.count == 0) {
            [wSelf noPhoto];
        }
        
        if (wSelf.dataLoaded) {
            wSelf.dataLoaded(albums);
        }
        [wSelf.tableView reloadData];
        
    }];
}

- (void)noPhoto {
    UILabel *lblNoPhoto = [[UILabel alloc] init];
    lblNoPhoto.textColor = [UIColor colorWithWhite:0.8 alpha:1];
    lblNoPhoto.font = [UIFont systemFontOfSize:17];
    lblNoPhoto.text = _LocalizedString(@"NO_PHOTOS");
    lblNoPhoto.textAlignment = NSTextAlignmentCenter;
    lblNoPhoto.numberOfLines = 0;
    lblNoPhoto.lineBreakMode = NSLineBreakByWordWrapping;
    CGSize size = [lblNoPhoto.text textSizeWithFont:lblNoPhoto.font constrainedToSize:CGSizeMake(kTPScreenWidth-2*ZQSide_X, 999) lineBreakMode:NSLineBreakByWordWrapping];
    lblNoPhoto.size = size;
    [self.tableView addSubview:lblNoPhoto];
    
    lblNoPhoto.frame = CGRectMake((kTPScreenWidth-size.width)/2, (kTPScreenHeight-size.height)/2, size.width, size.height);

}

#pragma mark - UITableViewDelegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.albums.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return AlbumListCellHeight;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    static NSString *idenfitier = @"ZQAlbumListCell class";
    ZQAlbumListCell *cell = [tableView dequeueReusableCellWithIdentifier:idenfitier];
    if (!cell) {
        cell = [[ZQAlbumListCell alloc] initWithStyle:(UITableViewCellStyleDefault) reuseIdentifier:idenfitier];
    }
    [cell setModel:self.albums[indexPath.row] indexPath:indexPath];
    cell.tag = indexPath.row;
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    ZQAlbumNavVC *nav = (ZQAlbumNavVC *)self.navigationController;
    
    ZQAlbumModel *model = self.albums[indexPath.row];
    ZQAlbumVC *vc = [[ZQAlbumVC alloc] init];
    vc.mAlbum = model;
    vc.maxImagesCount = nav.maxImagesCount;
    vc.type = [model.name isEqualToString:_LocalizedString(@"Videos")] ? ZQAlbumTypeVideo : ZQAlbumTypePhoto;
    vc.bSingleSelection = self.bSingleSelection;
    
    [self.navigationController pushViewController:vc animated:YES];
}
@end
