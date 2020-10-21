//
//  HSImageSidebarViewDelegate.h
//  Sidebar
//
//  Created by BJ Homer on 11/16/10.
//  Copyright 2010 BJ Homer. All rights reserved.
//

#import <UIKit/UIKit.h>
@class HSImageSidebarView;

@protocol HSImageSidebarViewDelegate <NSObject>

#pragma mark -
#pragma mark Delegate methods
@optional
- (void)sidebar:(HSImageSidebarView *)sidebar didTapImageAtIndex:(NSUInteger)anIndex;
- (void)sidebar:(HSImageSidebarView *)sidebar didMoveImageAtIndex:(NSUInteger)oldIndex toIndex:(NSUInteger)newIndex;
- (void)sidebar:(HSImageSidebarView *)sidebar didRemoveImageAtIndex:(NSUInteger)anIndex;

#pragma mark -
#pragma mark Data source methods
@required
- (NSUInteger)countOfImagesInSidebar:(HSImageSidebarView *)sidebar;
- (UIImage *)sidebar:(HSImageSidebarView *)sidebar imageForIndex:(NSUInteger)anIndex;
- (void)invalidateTimer;
- (void)restartTimer;
- (void)frame2;
-(void)cloneArrayObjectAtIndex:(int)index;
-(void)swapIndex1:(int)index1 withIndex2:(int)index2;
//-(void)pauseGif;
-(void)pauseGif:(BOOL)isDelegated;

@end
