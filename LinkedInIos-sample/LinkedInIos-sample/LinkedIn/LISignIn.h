//
//  LISignIn.h
//  LinkedInIos
//
//  Created by Marcel Falliere on 06/09/13.
//  Copyright (c) 2013 Marcel Falliere. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LIAuthentication.h"

@protocol LISignInDelegate
- (void)finishedLIAuthentificationWithError:(NSError *)error;
@end

@interface LISignIn : NSObject

@property (nonatomic, assign) id<LISignInDelegate> delegate;
@property (assign) BOOL shouldFetchLinkedInUserInfos;
@property (nonatomic, retain) LIAuthentication* auth;

+ (LISignIn*) sharedInstance;
- (void) authenticateFrom:(UIViewController*)currentVC;

@end




