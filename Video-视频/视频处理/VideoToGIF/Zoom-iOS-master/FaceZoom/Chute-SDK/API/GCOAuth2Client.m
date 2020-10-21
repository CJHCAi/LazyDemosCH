//
//  GCOAuth2.m
//  GetChute
//
//  Created by Aleksandar Trpeski on 4/11/13.
//  Copyright (c) 2013 Aleksandar Trpeski. All rights reserved.
//

#import "GCOAuth2Client.h"
#import "AFJSONRequestOperation.h"
#import "NSDictionary+QueryString.h"
#import "GCClient.h"
#import "GCLog.h"
#import "GCConfiguration.h"

static NSString * const kGCBaseURLString = @"https://getchute.com";
static dispatch_queue_t serialQueue;

static NSString * const kGCScope = @"scope";
static NSString * const kGCScopeDefaultValue = @"all_resources manage_resources profile resources";
static NSString * const kGCType = @"type";
static NSString * const kGCTypeValue = @"web_server";
static NSString * const kGCResponseType = @"response_type";
static NSString * const kGCResponseTypeValue = @"code";
static NSString * const kGCRedirectURI = @"redirect_uri";
static NSString * const kGCRedirectURIDefaultValue = @"http://getchute.com/oauth/callback";
static NSString * const kGCRetainSession = @"retain_session";

static NSString * const kGCOAuth = @"oauth";

NSString * const kGCLoginTypes[] = {
    @"facebook",
    @"instagram",
    @"microsoft_account",
    @"google",
    @"flickr",
    @"twitter",
    @"chute",
    @"foursquare",
    @"dropbox"
};

int const kGCLoginTypeCount = 9;

NSString * const kGCClientID = @"client_id";
NSString * const kGCClientSecret = @"client_secret";
NSString * const kGCCode = @"code";
NSString * const kGCGrantType = @"grant_type";
NSString * const kGCGrantTypeValue = @"authorization_code";

@implementation GCOAuth2Client

+ (instancetype)sharedClient
{
    static GCOAuth2Client *_sharedClient = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        serialQueue = dispatch_queue_create("com.getchute.gcoauth2client.serialqueue", NULL);
        _sharedClient = [[GCOAuth2Client alloc] initWithBaseURL:[NSURL URLWithString:kGCBaseURLString]];
    });
    
    return _sharedClient;
}

- (id)initWithBaseURL:(NSURL *)url
{
    self = [super initWithBaseURL:url];
    
    if (!self) {
        return nil;
    }
    
    [self registerHTTPOperationClass:[AFJSONRequestOperation class]];
    
    [self setDefaultHeader:@"Content-Type" value:@"application/x-www-form-urlencoded"];
    
    clientID = [[GCConfiguration configuration] appId];
    clientSecret = [[GCConfiguration configuration] appSecret];
    redirectURI = kGCRedirectURIDefaultValue;
    scope = kGCScopeDefaultValue;
    
    return self;
}

- (void)verifyAuthorizationWithAccessCode:(NSString *)code success:(void(^)(void))success failure:(void(^)(NSError *error))failure {
    
    GCClient *apiClient = [GCClient sharedClient];
    
    NSDictionary *params = @{
                             kGCClientID:clientID,
                             kGCClientSecret:clientSecret,
                             kGCRedirectURI:redirectURI,
                             kGCCode:code,
                             kGCGrantType:kGCGrantTypeValue,
                             };
    
    NSMutableURLRequest *request = [apiClient requestWithMethod:kGCClientPOST path:@"oauth/token" parameters:params];
        
    AFJSONRequestOperation *operation = [AFJSONRequestOperation JSONRequestOperationWithRequest:request success:^(NSURLRequest *request, NSHTTPURLResponse *response, id JSON){
        
        if([apiClient authorizationToken] == nil){
            [apiClient setAuthorizationHeaderWithToken:[JSON objectForKey:@"access_token"]];
            success();
        }
        else {
            NSString *savedToken = [[[apiClient authorizationToken] componentsSeparatedByString:@" "] objectAtIndex:1];
            GCLogVerbose(@"\n Saved token:%@", savedToken);
            
            NSString *newToken = [JSON objectForKey:@"access_token"];
            GCLogVerbose(@"\n New token:%@",newToken);
            
            if (![savedToken isEqualToString:[JSON objectForKey:@"access_token"]]) {
                GCLogWarning(@"Logged account belongs to another user");
                NSDictionary *userInfo = @{@"new_token":newToken};
                failure ([NSError errorWithDomain:@"Chute" code:302 userInfo:userInfo]);
            }
            else {
                [apiClient setAuthorizationHeaderWithToken:[JSON objectForKey:@"access_token"]];
                success();
            }
                
        }

    } failure:^(NSURLRequest *request, NSHTTPURLResponse *response, NSError *error, id JSON) {
        GCLogWarning(@"URL: %@\n\tError: %@", [[request URL] absoluteString], [error localizedDescription]);
        failure(error);
    }];
    [operation start];
}

- (NSURLRequest *)requestAccessForLoginType:(GCLoginType)loginType {
    
    NSDictionary *params = @{
                             kGCScope:@"",
                             kGCResponseType:kGCResponseTypeValue,
                             kGCClientID:clientID,
                             kGCRedirectURI:kGCRedirectURIDefaultValue,
//                             kGCRetainSession:@"true",
                             };

    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"http://getchute.com/v2/oauth/%@/authorize?%@",
                                                                               kGCLoginTypes[loginType],
                                                                               [params stringWithFormEncodedComponents]]]];
//    [self clearCookiesForLoginType:loginType];
    GCLogVerbose(@"Request description:%@",[request description]);
    return request;
}

/* This method clears cookies for specific loginType. It can and should be used in applications with logout option. In that
 way you give option to a user to login on same service (of the same type) with a different account.*/
- (void)clearCookiesForLoginType:(GCLoginType)loginType {
    NSHTTPCookieStorage *storage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    [[storage cookies] enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSHTTPCookie *cookie = obj;
        NSString* domainName = [cookie domain];
        NSRange domainRange = [domainName rangeOfString:kGCLoginTypes[loginType]];
        
        GCLogVerbose(@"Clear cookies for %@", domainName);
        
        if(domainRange.length > 0)
        {
            [storage deleteCookie:cookie];
        }
    }];
}

@end
