//
//  LIAuthentication.h
//  InstarLink
//
//  Created by Marcel Falliere on 06/09/13.
//  Copyright (c) 2013 Marcel Falliere. All rights reserved.
//

#import "LISignIn.h"
#import "LILoginVC.h"
#import "AppDelegate.h"

@implementation LISignIn

@synthesize delegate, auth, shouldFetchLinkedInUserInfos;

+(LISignIn*) sharedInstance {
    static LISignIn *sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedInstance = [[LISignIn alloc] init];
    });
    return sharedInstance;
}

- (void) authenticateFrom:(UIViewController*)currentVC {
    LILoginVC* loginVC = [[LILoginVC alloc]initWithNibName:@"LILoginVC" bundle:nil];
    [currentVC presentViewController:loginVC animated:true completion:^{ }];
}

@end
