//
//  Copyright (C) 2015 Google, Inc.
//
//  DFPPPIDViewController.m
//  APIDemo
//
//  Licensed under the Apache License, Version 2.0 (the "License");
//  you may not use this file except in compliance with the License.
//  You may obtain a copy of the License at
//
//      http://www.apache.org/licenses/LICENSE-2.0
//
//  Unless required by applicable law or agreed to in writing, software
//  distributed under the License is distributed on an "AS IS" BASIS,
//  WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
//  See the License for the specific language governing permissions and
//  limitations under the License.
//

#import "DFPPPIDViewController.h"

#import <CommonCrypto/CommonDigest.h>

#import "Constants.h"

/// DFP - PPID
@interface DFPPPIDViewController ()

@property(nonatomic, weak) IBOutlet DFPBannerView *bannerView;

@property(nonatomic, weak) IBOutlet UITextField *usernameTextField;

- (IBAction)loadAd:(id)sender;
/// Handles user taps to hide keyboard.
- (IBAction)screenTapped:(id)sender;

@end

@implementation DFPPPIDViewController

- (void)viewDidLoad {
  [super viewDidLoad];
}

#pragma mark - Actions

- (IBAction)loadAd:(id)sender {
  [self.view endEditing:YES];
  if (self.usernameTextField.text.length) {
    self.bannerView.adUnitID = kDFPPPIDAdUnitID;
    self.bannerView.rootViewController = self;

    DFPRequest *request = [DFPRequest request];
    request.publisherProvidedID =
        [self publisherProvidedIdentifierWithString:self.usernameTextField.text];
    [self.bannerView loadRequest:request];
  } else {
    UIAlertView *alert =
        [[UIAlertView alloc] initWithTitle:@"Load Ad Error"
                                   message:@"Failed to load ad. Username is required."
                                  delegate:nil
                         cancelButtonTitle:@"OK"
                         otherButtonTitles:nil];
    [alert show];
  }
}

- (IBAction)screenTapped:(id)sender {
  [self.view endEditing:YES];
}

/// https://support.google.com/dfp_premium/answer/2880055
- (NSString *)publisherProvidedIdentifierWithString:(NSString *)string {
    //创建用户名的字符串指针UTF8字符串
  const char *stringAsUTF8String = [string UTF8String];
  //创建无符号字符的字节数组。
  unsigned char MD5Buffer[CC_MD5_DIGEST_LENGTH];
  ///创建16字节MD5散列值
  CC_MD5(stringAsUTF8String, (CC_LONG)strlen(stringAsUTF8String), MD5Buffer);
  // NSString MD5值转换为十六进制值。
  NSMutableString *publisherProvidedIdentifier = [[NSMutableString alloc] init];
  for (int i = 0; i < (sizeof(MD5Buffer) / sizeof(MD5Buffer[0])); ++i) {
    [publisherProvidedIdentifier appendFormat:@"%02x", MD5Buffer[i]];
  }
  return publisherProvidedIdentifier;
}

@end
