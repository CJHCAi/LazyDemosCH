//
//  ZQPhotoFetcherTests.m
//  PhotoAlbum
//
//  Created by ZhouQian on 16/8/29.
//  Copyright © 2016年 ZhouQian. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "ZQPhotoFetcher.h"
#import "ZQAlbumModel.h"
#import "ZQAlbumNavVC.h"

@interface ZQPhotoFetcherTests : XCTestCase
@property (nonatomic, strong) ZQAlbumModel *mAlbum;
@end

@implementation ZQPhotoFetcherTests

- (void)setUp {
    [super setUp];
    __weak __typeof(self) wSelf = self;
    [ZQPhotoFetcher getAllAlbumsWithType:(ZQAlbumTypePhoto) completion:^(NSArray<ZQAlbumModel *> * _Nonnull albums) {
        XCTAssertNotEqual(albums.count, 0, @"albums counts zero!!!");
        wSelf.mAlbum = [albums firstObject];
    }];
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testGetAllPhotoAlbums {
    [ZQPhotoFetcher getAllAlbumsWithType:(ZQAlbumTypePhoto) completion:^(NSArray<ZQAlbumModel *> * _Nonnull albums) {
        XCTAssertNotEqual(albums.count, 0, @"albums counts zero!!!");
        ZQAlbumModel *model = [albums firstObject];
        XCTAssertNotNil(model.name);
    }];
}
- (void)testGetAllVideoAlbums {
    [ZQPhotoFetcher getAllAlbumsWithType:(ZQAlbumTypeVideo) completion:^(NSArray<ZQAlbumModel *> * _Nonnull albums) {
        XCTAssertNotEqual(albums.count, 0, @"albums counts zero!!!");
        ZQAlbumModel *model = [albums firstObject];
        XCTAssertNotNil(model.name);
        PHAsset *asset = [model.fetchResult firstObject];
        XCTAssertEqual(asset.mediaType, PHAssetMediaTypeVideo, @"Get Video Album only but there's photo");
    }];
}
- (void)testGetAllAlbums {
    [ZQPhotoFetcher getAllAlbumsWithType:(ZQAlbumTypeVideoAndPhoto) completion:^(NSArray<ZQAlbumModel *> * _Nonnull albums) {
        for (ZQAlbumModel *mAlbum in albums) {
            if ([mAlbum.name isEqualToString:_LocalizedString(@"Videos")]) {
                PHAsset *asset = [mAlbum.fetchResult firstObject];
                XCTAssertEqual(asset.mediaType, PHAssetMediaTypeVideo, @"Video Album gets photo");
            }
            else {
                PHAsset *asset = [mAlbum.fetchResult firstObject];
                XCTAssertEqual(asset.mediaType, PHAssetMediaTypeImage, @"Photo Album gets video");
            }
        }
    }];
}
- (void)testGetAllPhotoInOneAlbum {
    [ZQPhotoFetcher getAllPhotosInAlbum:self.mAlbum completion:^(NSArray<ZQPhotoModel *> * _Nonnull photos) {
        XCTAssertNotNil(photos);
        XCTAssertNotEqual(photos.count, 0);
    }];
}

- (void)testPerformanceExample {
    // This is an example of a performance test case.
    [self measureBlock:^{
        // Put the code you want to measure the time of here.
    }];
}

@end
