//
//  ViewController.m
//  LinkedInIos-sample
//
//  Created by Marcel Falliere on 09/09/13.
//  Copyright (c) 2013 Marcel Falliere. All rights reserved.
//

#import "ViewController.h"

@implementation ViewController

@synthesize buttonSignIn, labelStatus, labelUserFirstName, labelUserLastName, labelUserPictureUrl;

#pragma mark UIViewController lifecycle

- (void)viewDidLoad
{
    [super viewDidLoad];
    [self notLoggedIn];
    [buttonSignIn addTarget:self action:@selector(signIn:) forControlEvents:UIControlEventTouchUpInside];
}

#pragma mark business stuff

-(void)signIn:(id*)sender {
    [[LISignIn sharedInstance]setDelegate:self];
    [[LISignIn sharedInstance]setShouldFetchLinkedInUserInfos:YES];
    [[LISignIn sharedInstance]authenticateFrom:self];
}

-(void)notLoggedIn {
    labelStatus.text = @"Not signed in";
    labelUserFirstName.text = @"n/c";
    labelUserLastName.text = @"n/c";
    labelUserPictureUrl.text = @"n/c";
}

-(void)loggedIn {
    labelStatus.text = @"Signed in";
    labelUserFirstName.text = [LISignIn sharedInstance].auth.userFirstName;
    labelUserLastName.text = [LISignIn sharedInstance].auth.userLastName;
    labelUserPictureUrl.text = [LISignIn sharedInstance].auth.userPictureUrl;
}

-(void)loggedInError {
    labelStatus.text = @"Sign in error";
    labelUserFirstName.text = @"n/c";
    labelUserLastName.text = @"n/c";
    labelUserPictureUrl.text = @"n/c";
}

#pragma mark LISignInDelegate protocol

- (void)finishedLIAuthentificationWithError:(NSError *)error {
    if (error==nil) {
        [self loggedIn];
    } else {
        [self loggedInError];
    }
}


@end
