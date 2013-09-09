//
//  LILoginVC.h
//  LinkedInIos
//
//  Created by Marcel Falliere on 06/09/13.
//  Copyright (c) 2013 Marcel Falliere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LISignIn.h"
#import "LIAuthentication.h"

@interface LILoginVC : UIViewController <UIWebViewDelegate> { 
    NSMutableData *receivedData_;
}

@property(nonatomic, retain) IBOutlet UIWebView* webView;
@property(nonatomic, retain) IBOutlet UIButton* cancelButton;
@property(nonatomic, retain) IBOutlet UIActivityIndicatorView* activityIndicator;


-(void)fetchTokenWithCode:(NSString*)code;

@end
