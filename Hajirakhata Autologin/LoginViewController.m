//
//  LoginViewController.m
//  Hajirakhata Autologin
//
//  Created by Mujtahid Akon on 6/12/17.
//  Copyright © 2017 Mujtahid Akon. All rights reserved.
//

#import "LoginViewController.h"


@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.keyboardAnimator = [[KeyboardAnimator alloc]initKeyboardAnimatorWithTextField:@[self.username,self.password] withTargetTextField:@[self.password,self.password] AndWhichViewWillAnimated:self.view bottomConstraints:nil nonBottomConstraints:nil];
    [self.keyboardAnimator registerKeyboardEventListener];
    
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

- (IBAction)loginButton:(id)sender {
    [self prepareURL];
    NSLog(@"Pressed login Button\nUsername: %@\nPassword: %@", self.username.text, self.password.text);
}

- (void) prepareURL{
    // Create the URLSession on the default configuration
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    NSURLSession *defaultSession = [NSURLSession sessionWithConfiguration:defaultSessionConfiguration];
    
    // Setup the request with URL
    NSURL *url = [NSURL URLWithString:@"http://hajirakhata.revesoft.com/Login.do"];
    NSMutableURLRequest *urlRequest = [NSMutableURLRequest requestWithURL:url];
    
    // Convert POST string parameters to data using UTF8 Encoding
    NSString *postParams = [NSString stringWithFormat: @"username=%@&password=%@",self.username.text, self.password.text];
    NSData *postData = [postParams dataUsingEncoding:NSUTF8StringEncoding];
    
    // Convert POST string parameters to data using UTF8 Encoding
    [urlRequest setHTTPMethod:@"POST"];
    [urlRequest setHTTPBody:postData];
    
    // Create dataTask
    NSURLSessionDataTask *dataTask = [defaultSession dataTaskWithRequest:urlRequest completionHandler:^(NSData *data, NSURLResponse *response, NSError *error) {
//         Handle your response here
        if (error) {
            NSLog(@"Error Occured!\n%ld\n%@\n",(long)error.code, error.userInfo[@"NSLocalizedDescription"]);
            
            [self showAlertWithTitle:@"Error" andMessage:error.userInfo[@"NSLocalizedDescription"]];
        }//Response has come from server
        else{
            NSHTTPURLResponse *httpResponse = (NSHTTPURLResponse*)response;
//            [self clearAllCookies];
            NSString *responseURL = [httpResponse.URL path];
//            NSLog(@"%@", responseURL);
            if((long)[httpResponse statusCode] == 200 ){
                if ([responseURL localizedCaseInsensitiveContainsString:@"Login.do"]) {
                    //wrong username & password!
                    NSLog(@"Bad Response from server\n%ld" , (long)[httpResponse statusCode]);
                    [self showAlertWithTitle:@"Failed"
                                  andMessage: @"Bad response from server"];
                }else{
                    [self showAlertWithTitle:@"Success" andMessage: [NSString stringWithFormat:@"Login time: %@", @"demo time"]];
                    // TO DO Show success screen!
                }
            }
            else{
                NSLog(@"Failed! Awkward response from server :(\nstatus code: %ld" , (long)[httpResponse statusCode]);
                [self showAlertWithTitle:@"Failed!" andMessage: [NSString stringWithFormat:@"Awkward response from server :("]];
                // TO DO check connection
                //if first time failed, load log in screen again , else provide try again button
            }
            
        }
//        NSLog(@"resp: %@, err: %@", response, error);
    }];
    
    // Fire the request
    [dataTask resume];
}

-(void) showAlertWithTitle: (NSString*) title andMessage: (NSString*) message{
    UIAlertController* alert = [UIAlertController alertControllerWithTitle: title
                                                                   message: message
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault
                                                          handler:^(UIAlertAction * action) {}];
    
    [alert addAction:defaultAction];
    [self presentViewController:alert animated:YES completion:nil];
}
- (void)clearAllCookies {
    NSHTTPCookieStorage *cookieStorage = [NSHTTPCookieStorage sharedHTTPCookieStorage];
    for (NSHTTPCookie *each in cookieStorage.cookies) {
        [cookieStorage deleteCookie:each];
    }
}
@end
