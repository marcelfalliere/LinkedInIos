//
//  ViewController.h
//  LinkedInIos-sample
//
//  Created by Marcel Falliere on 09/09/13.
//  Copyright (c) 2013 Marcel Falliere. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LISignIn.h"

@interface ViewController : UIViewController <LISignInDelegate>

@property (nonatomic, retain) IBOutlet UIButton* buttonSignIn;
@property (nonatomic, retain) IBOutlet UILabel* labelStatus;
@property (nonatomic, retain) IBOutlet UILabel* labelUserFirstName;
@property (nonatomic, retain) IBOutlet UILabel* labelUserLastName;
@property (nonatomic, retain) IBOutlet UILabel* labelUserPictureUrl;

-(void)signIn:(id*)sender;

-(void)notLoggedIn;
-(void)loggedIn;
-(void)loggedInError;

@end
