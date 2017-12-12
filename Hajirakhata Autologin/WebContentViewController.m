//
//  WebContentViewController.m
//  Hajirakhata
//
//  Created by Mujtahid Akon on 10/12/17.
//  Copyright © 2017 Mujtahid Akon. All rights reserved.
//

#import "WebContentViewController.h"
#import "UserInfo.h"

@interface WebContentViewController ()
@property UserInfo * userInfo;
@property (weak, nonatomic) IBOutlet UIView *loadingView;

@end

@implementation WebContentViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.loadingView.layer.cornerRadius = 10;
    self.loadingView.alpha = .9;
    self.webContent.delegate = self;
    

    self.userInfo = [UserInfo readData];
    // Do any additional setup after loading the view.
    NSString *urlString;
    if(self.userInfo){
        urlString = [ NSString stringWithFormat:@"http://hajirakhata.revesoft.com/Login.do?username=%@&password=%@",self.userInfo.username,self.userInfo.password];
    }
    else urlString = @"http://hajirakhata.revesoft.com/Login.do";
    NSURL *url = [NSURL URLWithString:urlString];
    NSURLRequest * urlRequest = [NSURLRequest requestWithURL:url];
    [self.webContent loadRequest:urlRequest];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (void) webViewDidStartLoad:(UIWebView *)webView{
    NSLog(@"loadingView is loading...");
    [self.loadingView setHidden:NO];
}

- (void) webViewDidFinishLoad:(UIWebView *)webView{
    NSLog(@"loadingView is unloading...");
    [self.loadingView setHidden:YES];
}

- (IBAction)goBackwardPage:(id)sender {
    if ([self.webContent canGoBack]) {
        [self.webContent goBack];
    }
}

- (IBAction)goForwardPage:(id)sender {
    if ([self.webContent canGoForward]) {
        [self.webContent goForward];
    }
}

- (IBAction)refreshWebpage:(id)sender {
    [self.webContent reload];
}

- (IBAction)stopWebpage:(id)sender {
    if ([self.webContent isLoading]) {
        [self.webContent stopLoading];
        [self.loadingView setHidden:YES];
    }
}

@end
