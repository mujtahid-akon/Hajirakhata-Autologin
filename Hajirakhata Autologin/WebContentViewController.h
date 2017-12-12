//
//  WebContentViewController.h
//  Hajirakhata
//
//  Created by Mujtahid Akon on 10/12/17.
//  Copyright © 2017 Mujtahid Akon. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WebContentViewController : UIViewController<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webContent;
- (IBAction)goBackwardPage:(id)sender;
- (IBAction)goForwardPage:(id)sender;
- (IBAction)refreshWebpage:(id)sender;
- (IBAction)stopWebpage:(id)sender;

@end
