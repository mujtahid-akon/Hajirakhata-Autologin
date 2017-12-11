//
//  LoginViewController.m
//  Hajirakhata Autologin
//
//  Created by Mujtahid Akon on 6/12/17.
//  Copyright © 2017 Mujtahid Akon. All rights reserved.
//

#import "LoginViewController.h"
#import "UserInfo.h"

@interface LoginViewController ()

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
//    [self.button setTitle:@"Log in" forState:UIControlStateNormal];
//    [self.button setTitle:@"Logging in..." forState:UIControlStateDisabled];
    
    UserInfo * info = [UserInfo readData];
    if (info) {
        self.username.text = info.username;
        self.password.text = info.password;
    }
    [self fixTextField];
    

    self.keyboardAnimator = [[KeyboardAnimator alloc]initKeyboardAnimatorWithTextField:@[self.username,self.password] withTargetTextField:@[self.password,self.password] AndWhichViewWillAnimated:self.view bottomConstraints:nil nonBottomConstraints:nil];
    [self.keyboardAnimator registerKeyboardEventListener];
    
    UITapGestureRecognizer *tap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(dismissKeyboard)];
    [self.view addGestureRecognizer:tap];
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
    [self dismissKeyboard];
    [self.button setTitle:@"Logging in..." forState:UIControlStateNormal];
    [self sendData];
    NSLog(@"Pressed login Button\nUsername: %@\nPassword: %@", self.username.text, self.password.text);
    //[self.button setTitle:@"Log in" forState:UIControlStateNormal];
}

- (void) sendData{
    // Create the URLSession on the default configuration
    NSURLSessionConfiguration *defaultSessionConfiguration = [NSURLSessionConfiguration defaultSessionConfiguration];
    defaultSessionConfiguration.timeoutIntervalForRequest = 60;//in seconds; default = 60s
//    defaultSessionConfiguration.timeoutIntervalForResource = //in seconds; default value = 7days;
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
        
        dispatch_async(dispatch_get_main_queue(), ^{
//            NSLog(@"Change button title to login again");
            [self.button setTitle:@"Log in" forState:UIControlStateNormal];
        });
        
        NSLog(@"response: %@\nerr: %@\n", response, error);
        
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
                    NSLog(@"Wrong username or password\n%ld" , (long)[httpResponse statusCode]);
                    [self showAlertWithTitle:@"Failed"
                                  andMessage: @"Wrong username or password!"];
                }else{
                    
                    NSString *dateString = httpResponse.allHeaderFields[@"Date"];
                    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
                    
                    [dateFormatter setLocale:[[NSLocale alloc] initWithLocaleIdentifier:@"en_US"]];
                    dateFormatter.dateFormat =  @"EEE, dd MMM yyyy HH:mm:ss ZZZZ";
                    NSDate *loginDate = [dateFormatter dateFromString:dateString];
                    
                    dateFormatter.timeZone = [NSTimeZone systemTimeZone]; //GMT +6
                    dateFormatter.dateFormat = @"hh:mm:ss a'\n'EEEE dd MMM, yyyy";
                    dateString = [dateFormatter stringFromDate:loginDate];
                    NSLog(@"Success! Login time: %@", dateString);
                    
                    //runs in main thread
                    dispatch_async(dispatch_get_main_queue(), ^{
//                        NSLog(@"data & button fix");
                        [UserInfo writeUsername:self.username.text andPassword:self.password.text]; //store username & password;
                        [self fixTextField];
                    });
                    
                    [self showAlertWithTitle:@"Success"
                                  andMessage: [NSString stringWithFormat:@"Login time: %@", dateString ]];// success alert
                }
            }
            else{
                NSLog(@"Failed! Awkward response from server :(\nstatus code: %ld" , (long)[httpResponse statusCode]);
                [self showAlertWithTitle:@"Failed!" andMessage: [NSString stringWithFormat:@"Awkward response from server :("]];
            }
            
        }
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
- (IBAction)unlockFields:(id)sender {
//    NSLog(@"%d", self.modifySwitch.on);
    [self fixTextField];
}

-(void) fixTextField{
    UserInfo * info = [UserInfo readData];
    if(!self.modifySwitch.on){//modify switch off
        if(info!=nil) {//Userinfo saved in database
            [self.button setTitle:@"Log in" forState:UIControlStateNormal];
            self.username.enabled = NO;
            self.password.enabled = NO;
        }
    }
    else{//modify switch on
        [self.button setTitle:@"Modify" forState:UIControlStateNormal];
        [self.username becomeFirstResponder];
        self.username.enabled = YES;
        self.password.enabled = YES;
    }
}

-(void)dismissKeyboard{
    [self.username resignFirstResponder];
    [self.password resignFirstResponder];
}

- (IBAction)unwindToLogin:(UIStoryboardSegue*) segue{
    
}
@end
