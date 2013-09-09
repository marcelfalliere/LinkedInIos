//
//  LIAuthentication.h
//  LinkedInIos
//
//  Created by Marcel Falliere on 06/09/13.
//  Copyright (c) 2013 Marcel Falliere. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LIAuthentication : NSObject <NSXMLParserDelegate> {
    NSMutableString* currentString;
}

@property (retain) NSString* _token;
@property (retain) NSString* userFirstName;
@property (retain) NSString* userLastName;
@property (retain) NSString* userPictureUrl;

+(LIAuthentication*)authentication;
+(LIAuthentication*)authenticationWithToken:(NSString*)token;
-(void)fetchUserInfos;
@end
