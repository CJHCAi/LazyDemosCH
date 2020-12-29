//
//  LoginViewController.m
//  backPacker
//
//  Created by 聂 亚杰 on 13-6-1.
//  Copyright (c) 2013年 聂 亚杰. All rights reserved.
//

#import "LoginViewController.h"
#import <QuartzCore/QuartzCore.h>
#import "JSONKit.h"
@interface LoginViewController ()

@end

@implementation LoginViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

-(void)initURL{
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"url" ofType:@"plist"];
    NSDictionary *dic = [[NSDictionary alloc]initWithContentsOfFile:plistPath];
    NSString *ipPath = [dic objectForKey:@"baseIp"];
    NSString *loginString = [dic objectForKey:@"loginURL"];
    
    self.loginBaseURLString = [NSString stringWithFormat:@"%@%@",ipPath,loginString];
}

-(void)requestData{
    
    NSString *urlString = [NSString stringWithFormat:@"%@?email=%@&password=%@",self.loginBaseURLString,[self.userEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding],self.userPassWord];
    NSLog(@"loginURL:%@",urlString);
    ASIHTTPRequest *request = [ASIHTTPRequest requestWithURL:[NSURL URLWithString:urlString]];
    request.defaultResponseEncoding = NSUTF8StringEncoding;
    [request setDelegate:self];
    [request startAsynchronous];
    
}
- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view.
    [self initURL];
}

#pragma ASIHttpRequest Delegate
-(void)requestFinished:(ASIHTTPRequest *)request{
    NSString *response = [request responseString];
    NSLog(@"response:%@",response);
    NSMutableDictionary *loginData =[response objectFromJSONString];
    if (loginData == nil) {
        NSLog(@"访问出错");
        return;
    }
    NSString *error = [loginData objectForKey:@"errorMsg"];
    NSLog(@"error:%@",error);
    if ([[error stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceCharacterSet]] length]==0) {
        self.userEmail = [loginData objectForKey:@"email"];
        self.userId = [NSString stringWithFormat:@"%@",[loginData objectForKey:@"id"]];
        
        NSUserDefaults *saveDefaults = [NSUserDefaults standardUserDefaults];
        [saveDefaults setValue:@"1" forKey:@"hasLogin"];
        [saveDefaults setValue:self.userEmail forKey:@"userEmail"];
        [saveDefaults setValue:self.userPassWord forKey:@"userPassWord"];
        [saveDefaults setValue:self.userId forKey:@"userId"];
        [self.parentViewController.navigationController popViewControllerAnimated:YES];

    }else{
        NSLog(@"errorMsg:%@",error);
    }
    
    
}
-(void)requestFailed:(ASIHTTPRequest *)request{
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return 2;
    }else{
        return 1;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell;
    if (indexPath.section == 0) {
        static NSString *CellIdentifier = @"loginTextCell";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        
        
    }else{
        static NSString *CellIdentifier = @"loginButtonCell";
        cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    }
    
    // Configure the cell...
    [self configureCell:cell atIndexPath:indexPath];
    return cell;
}

- (void)configureCell:(UITableViewCell *)cell atIndexPath:(NSIndexPath*)indexPath{
    
    
    if (indexPath.section == 0) {
        UITextField *textF = (UITextField *)[[cell contentView]viewWithTag:1];
        textF.autocapitalizationType = UITextAutocapitalizationTypeNone;
        [textF addTarget:self action:@selector(textFieldWithText:) forControlEvents:UIControlEventEditingChanged];
        
        switch (indexPath.row) {
            case 0:
                textF.placeholder = @"邮箱";
                textF.keyboardType = UIKeyboardTypeEmailAddress;
                [textF setTag:1];
                break;
            case 1:
                textF.placeholder = @"密码";
                textF.keyboardType = UIKeyboardTypeASCIICapable;
                textF.secureTextEntry = YES;
                [textF setTag:2];
                
                break;
            default:
                break;
        }
    }else{
        
    }
}

- (void)textFieldWithText:(UITextField *)textField
{
    switch (textField.tag) {
        case 1:
            self.userEmail = textField.text;
            break;
        case 2:
            self.userPassWord = textField.text;
            break;

        default:
            break;
    }
}

-(IBAction)lButtonPressed:(id)sender{
    [self requestData];

}
- (IBAction)editDidEnd:(id)sender {
    [sender resignFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
