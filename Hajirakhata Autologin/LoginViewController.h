//
//  LoginViewController.h
//  Hajirakhata Autologin
//
//  Created by Mujtahid Akon on 6/12/17.
//  Copyright © 2017 Mujtahid Akon. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "KeyboardAnimator.h"

@interface LoginViewController : UIViewController
@property (nonatomic, strong) KeyboardAnimator *keyboardAnimator;
@property (weak, nonatomic) IBOutlet UITextField *username;
@property (weak, nonatomic) IBOutlet UITextField *password;
- (IBAction)loginButton:(id)sender;
@end
