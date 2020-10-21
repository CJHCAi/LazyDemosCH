//
//  OLFacebookAlbumRequest.m
//  FacebookImagePicker
//
//  Created by Deon Botha on 15/12/2013.
//  Copyright (c) 2013 Deon Botha. All rights reserved.
//

#import "OLFacebookAlbumRequest.h"
#import "OLFacebookAlbum.h"
#import <FacebookSDK/FacebookSDK.h>

@interface OLFacebookAlbumRequest ()
@property (nonatomic, assign) BOOL cancelled;
@property (nonatomic, strong) NSString *after;
@end

@implementation OLFacebookAlbumRequest

+ (void)handleFacebookError:(NSError *)error completionHandler:(OLFacebookAlbumRequestHandler)handler {
    NSString *message;
    if ([FBErrorUtility shouldNotifyUserForError:error]) {
        message = [FBErrorUtility userMessageForError:error];
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryAuthenticationReopenSession) {
        message = @"Your current Facebook session is no longer valid. Please log in again.";
    } else if ([FBErrorUtility errorCategoryForError:error] == FBErrorCategoryUserCancelled) {
        message = @"The app requires authorization to access your Facebook photos to continue. Please open Settings and provide access.";
    } else {
        message = @"Failed to access your Facebook photos. Please check your internet connectivity and try again.";
    }
    
    handler(nil, [NSError errorWithDomain:error.domain code:error.code userInfo:@{NSLocalizedDescriptionKey: message}], nil);
}

- (void)cancel {
    self.cancelled = YES;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
}

- (void)getAlbums:(OLFacebookAlbumRequestHandler)handler {
    
    NSLog(@"WE DUN IT TOGETHER");
    
    __block BOOL runOnce = NO;
    [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
    [FBSession openActiveSessionWithReadPermissions:@[@"public_profile",  @"user_photos"]
                                       allowLoginUI:YES
                                  completionHandler:^(FBSession *session, FBSessionState state, NSError *error) {
                                      
                                      NSLog(@"WE HERE TOO MOFO");

                                      [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                      
                                      if (runOnce || self.cancelled) {
                                          return;
                                      }
                                      
                                      runOnce = YES;
                                      if (error) {
                                          [OLFacebookAlbumRequest handleFacebookError:error completionHandler:handler];
                                      } else if (!FB_ISSESSIONOPENWITHSTATE(state)) {
                                          NSString *message = @"Failed to access your Facebook photos. Please check your internet connectivity and try again.";
                                          handler(nil, [NSError errorWithDomain:@"co.oceanlabs.FacebookImagePicker.kOLErrorDomainFacebookImagePicker" code:100 userInfo:@{NSLocalizedDescriptionKey: message}], nil);
                                      } else {
                                          // connection is open, perform the request
                                          [UIApplication sharedApplication].networkActivityIndicatorVisible = YES;
                                          NSString *graphPath = @"me/albums?limit=100&fields=id,name,count,cover_photo";
                                          if (self.after) {
                                              graphPath = [graphPath stringByAppendingFormat:@"&after=%@", self.after];
                                          }
                                          
                                          
                                          [FBRequestConnection startWithGraphPath:graphPath completionHandler:^(FBRequestConnection *connection,
                                                                                                                                                              id result,
                                                                                                                                                              NSError *error) {
                                              [UIApplication sharedApplication].networkActivityIndicatorVisible = NO;
                                              if (self.cancelled) {
                                                  return;
                                              }
                                              
                                              NSString *parsingErrorMessage = @"Failed to parse Facebook Response. Please check your internet connectivity and try again.";
                                              NSError *parsingError = [NSError errorWithDomain:@"co.oceanlabs.FacebookImagePicker.kOLErrorDomainFacebookImagePicker" code:99 userInfo:@{NSLocalizedDescriptionKey: parsingErrorMessage}];
                                              id data = [result objectForKey:@"data"];
                                              if (![data isKindOfClass:[NSArray class]]) {
                                                  handler(nil, parsingError, nil);
                                                  return;
                                              }
                                              
                                              NSMutableArray *albums = [[NSMutableArray alloc] init];
                                              for (id album in data) {
                                                  if (![album isKindOfClass:[NSDictionary class]]) {
                                                      continue;
                                                  }
                                                  
                                                  id albumId     = [album objectForKey:@"id"];
                                                  id photoCount  = [album objectForKey:@"count"];
                                                  id coverPhoto  = [album objectForKey:@"cover_photo"];
                                                  id name        = [album objectForKey:@"name"];
                                                  
                                                  if (!([albumId isKindOfClass:[NSString class]] && [photoCount isKindOfClass:[NSNumber class]]
                                                        && [coverPhoto isKindOfClass:[NSString class]] && [name isKindOfClass:[NSString class]])) {
                                                      continue;
                                                  }
                                                  
                                                  OLFacebookAlbum *album = [[OLFacebookAlbum alloc] init];
                                                  album.albumId = albumId;
                                                  album.photoCount = [photoCount unsignedIntegerValue];
                                                  album.name = name;
                                                  album.coverPhotoURL = [NSURL URLWithString:[NSString stringWithFormat:@"https://graph.facebook.com/%@/picture?type=small&access_token=%@", album.albumId, session.accessTokenData.accessToken]];
                                                  [albums addObject:album];
                                              }
                                              
                                              // get next page cursor
                                              OLFacebookAlbumRequest *nextPageRequest = nil;
                                              id paging = [result objectForKey:@"paging"];
                                              if ([paging isKindOfClass:[NSDictionary class]]) {
                                                  id cursors = [paging objectForKey:@"cursors"];
                                                  id next = [paging objectForKey:@"next"]; // next will be non nil if a next page exists
                                                  if (next && [cursors isKindOfClass:[NSDictionary class]]) {
                                                      id after = [cursors objectForKey:@"after"];
                                                      if ([after isKindOfClass:[NSString class]]) {
                                                          nextPageRequest = [[OLFacebookAlbumRequest alloc] init];
                                                          nextPageRequest.after = after;
                                                      }
                                                  }
                                              }
                                              
                                              handler(albums, nil, nextPageRequest);
                                          }];
                                      }
                                  }];
    
}

@end
