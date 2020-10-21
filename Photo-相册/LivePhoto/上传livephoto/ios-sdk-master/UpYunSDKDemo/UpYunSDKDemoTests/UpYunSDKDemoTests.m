//
//  UpYunSDKDemoTests.m
//  UpYunSDKDemoTests
//
//  Created by 林港 on 16/1/28.
//  Copyright © 2016年 upyun. All rights reserved.
//

#import <XCTest/XCTest.h>
#import "UpYun.h"
#import "NSString+NSHash.h"

@interface UpYunSDKDemoTests : XCTestCase
@property UpYun *upyun;
@end

@implementation UpYunSDKDemoTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
    _upyun = [[UpYun alloc]init];
    _upyun.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"success %@", responseData);
    };
    _upyun.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        
        NSLog(@"error %@", message);
    };
    _upyun.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"percent %f", percent);
    };
    
    _upyun.bucket = @"test654123";
    _upyun.passcode = @"0/8/1gPFWUQWGcfjFn6Vsn3VWDc=";
//    _upyun.uploadMethod = UPMutUPload;
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];
}

- (void)testFormPolicy {
    NSString *json = @"{\"bucket\":\"demobucket\",\"expiration\":1409200758,\"save-key\":\"/img.jpg\"}";
    XCTAssert([[json Base64encode] isEqual:@"eyJidWNrZXQiOiJkZW1vYnVja2V0IiwiZXhwaXJhdGlvbiI6MTQwOTIwMDc1OCwic2F2ZS1rZXkiOiIvaW1nLmpwZyJ9"], @"Pass");
}

- (void)testFormSignature {
    NSString *json = @"{\"bucket\":\"demobucket\",\"expiration\":1409200758,\"save-key\":\"/img.jpg\"}";
    NSString *passkey = @"cAnyet74l9hdUag34h2dZu8z7gU=";
    
    NSString *signature = [NSString stringWithFormat:@"%@%@%@", [json Base64encode], @"&", passkey];
    
    XCTAssert([[signature MD5] isEqual:@"646a6a629c344ce0e6a10cadd49756d4"], @"Pass");
}

- (void)testMutPolicy {
    NSString *json = @"{\"path\":\"/demo.png\",\"expiration\":1409200758,\"file_blocks\":1,\"file_size\":653252,\"file_hash\":\"b1143cbc07c8e768d517fa5e73cb79ca\"}";
    XCTAssert([[json Base64encode] isEqual:@"eyJwYXRoIjoiL2RlbW8ucG5nIiwiZXhwaXJhdGlvbiI6MTQwOTIwMDc1OCwiZmlsZV9ibG9ja3MiOjEsImZpbGVfc2l6ZSI6NjUzMjUyLCJmaWxlX2hhc2giOiJiMTE0M2NiYzA3YzhlNzY4ZDUxN2ZhNWU3M2NiNzljYSJ9"], @"Pass");
}

- (void)testMutSignature {
    NSMutableDictionary *mutDic = [[NSMutableDictionary alloc]init];
    [mutDic setObject:@"/demo.png" forKey:@"path"];
    [mutDic setObject:@"1409200758" forKey:@"expiration"];
    [mutDic setObject:@"1" forKey:@"file_blocks"];
    [mutDic setObject:@"b1143cbc07c8e768d517fa5e73cb79ca" forKey:@"file_hash"];
    [mutDic setObject:@"653252" forKey:@"file_size"];
    
    NSString *passkey = @"cAnyet74l9hdUag34h2dZu8z7gU=";
    NSString *policy = @"";
    NSArray *keys = [[mutDic allKeys] sortedArrayUsingSelector:@selector(compare:)];
    for (NSString * key in keys) {
        NSString * value = mutDic[key];
        policy = [NSString stringWithFormat:@"%@%@%@", policy, key, value];
    }
    policy = [policy stringByAppendingString:passkey];
    XCTAssert([[policy MD5] isEqual:@"a178e6e3ff4656e437811616ca842c48"], @"Pass");
}

- (void)testUploadFilePath {
    __weak UpYun *upyun = _upyun;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Upload!"];
    
    upyun.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"success %@", responseData);
        NSLog(@"response %@", response);
        XCTAssertNotNil(response);
        [expectation fulfill];
    };
    upyun.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        NSLog(@"error %@", message);
    };
    upyun.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"percent %f", percent);
    };
    
    upyun.bucket = @"test654123";
    upyun.passcode = @"0/8/1gPFWUQWGcfjFn6Vsn3VWDc=";
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"image.jpg"];
    [_upyun uploadFile:filePath saveKey:@"/test2.png"];

    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testUploadFileData {
    __weak UpYun *upyun = _upyun;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Upload!"];
    
    upyun.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"success %@", responseData);
        NSLog(@"response %@", response);
        XCTAssertNotNil(response);
        [expectation fulfill];
    };
    upyun.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        NSLog(@"error %@", message);
    };
    upyun.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"percent %f", percent);
    };
    
    upyun.bucket = @"test654123";
    upyun.passcode = @"0/8/1gPFWUQWGcfjFn6Vsn3VWDc=";
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"fileTest.file"];
    NSData *fileData = [NSData dataWithContentsOfFile:filePath];
    [upyun uploadFile:fileData saveKey:@"/txt"];
    
    
    [self waitForExpectationsWithTimeout:10 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testUploadImageData {
    __weak UpYun *upyun = _upyun;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Upload!"];
    
    upyun.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"success %@", responseData);
        NSLog(@"response %@", response);
        XCTAssertNotNil(response);
        [expectation fulfill];
    };
    upyun.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        NSLog(@"error %@", message);
    };
    upyun.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"percent %f", percent);
    };
    
    upyun.bucket = @"test654123";
    upyun.passcode = @"0/8/1gPFWUQWGcfjFn6Vsn3VWDc=";
    [upyun uploadFile:[UIImage imageNamed:@"image.jpg"] saveKey:@"/txt"];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testSaveKey {
    __weak UpYun *upyun = _upyun;
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Upload!"];
    upyun.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"success %@", responseData);
        NSLog(@"response %@", response);
        XCTAssertNotNil(response);
        [expectation fulfill];
    };
    upyun.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        NSLog(@"error %@", message);
    };
    upyun.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"percent %f", percent);
    };
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"image.jpg"];
    [_upyun uploadFile:filePath saveKey:@"/{year}/{mon}/{filename}{.suffix}"];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testNoFile {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Upload!"];
    __block UpYun *uy = _upyun;
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"response body %@", responseData);
    };
    uy.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        NSLog(@"error %@", message);
        XCTAssert(message != nil);
        [expectation fulfill];
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"%f", percent);
    };
    uy.uploadMethod = UPMutUPload;
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"image1333.jpg"];
    [uy uploadFile:filePath saveKey:@"/test2.png"];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testNoData {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Upload!"];
    __block UpYun *uy = _upyun;
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"response body %@", responseData);
    };
    uy.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        NSLog(@"error %@", message);
        XCTAssert(message != nil);
        [expectation fulfill];
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"%f", percent);
    };
    [uy uploadFile:nil saveKey:@"/test2.png"];
    
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}


- (void)testWrongBucket {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Upload!"];
    __block UpYun *uy = _upyun;
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"success %@", responseData);
        NSLog(@"response %@", response);
        XCTAssertNotNil(response);
    };
    uy.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        NSLog(@"error %@", message);
        XCTAssert(message != nil);
        [expectation fulfill];
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"%f", percent);
    };
    uy.passcode = @"0/8/1gPFWUQWGcfjFn6Vsn3VWDc=";
    uy.bucket = @"test6541233";

    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"image.jpg"];
    [uy uploadFile:filePath saveKey:@"/test2.png"];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testWrongPasscode {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Upload!"];
    __block UpYun *uy = _upyun;
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"success %@", responseData);
        NSLog(@"response %@", response);
        XCTAssertNotNil(response);
    };
    uy.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        NSLog(@"error %@", message);
        XCTAssert(message != nil);
        [expectation fulfill];
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"%f", percent);
    };
    uy.passcode = @"vcVus6Xo+nn51sJmGjqsW8rTpKs=ppppo";
    uy.bucket = @"test86400";
    NSString *resourcePath = [[NSBundle mainBundle] resourcePath];
    NSString *filePath = [resourcePath stringByAppendingPathComponent:@"image.jpg"];
    [uy uploadFile:filePath saveKey:@"/test2.png"];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}

- (void)testParams {
    XCTestExpectation *expectation = [self expectationWithDescription:@"Testing Async Upload!"];
    __block UpYun *uy = _upyun;
    uy.successBlocker = ^(NSURLResponse *response, id responseData) {
        NSLog(@"success %@", responseData);
        NSLog(@"response %@", response);
        XCTAssertNotNil(response);
        [expectation fulfill];
    };
    uy.failBlocker = ^(NSError * error) {
        NSString *message = [error.userInfo objectForKey:@"message"];
        NSLog(@"error %@", message);
        XCTAssert(message != nil);
    };
    uy.progressBlocker = ^(CGFloat percent, int64_t requestDidSendBytes) {
        NSLog(@"%f", percent);
    };
    NSMutableDictionary *paramsDict = [NSMutableDictionary new];
    [paramsDict setObject:@"audio/mp3" forKey:@"content-type"];
    uy.params = paramsDict;
    void * bytes = malloc(123);
    NSData * data = [NSData dataWithBytes:bytes length:123];
    free(bytes);

    [uy uploadFile:data saveKey:@"/test23"];
    [self waitForExpectationsWithTimeout:5.0 handler:^(NSError *error) {
        if(error) {
            XCTFail(@"Expectation Failed with error: %@", error);
        }
    }];
}


@end
