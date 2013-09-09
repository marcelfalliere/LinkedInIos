//
//  LIAuthentication.m
//  LinkedInIos
//
//  Created by Marcel Falliere on 06/09/13.
//  Copyright (c) 2013 Marcel Falliere. All rights reserved.
//

#import "LIAuthentication.h"
#import "LISignIn.h"

@implementation LIAuthentication
@synthesize _token, userFirstName, userLastName, userPictureUrl;

+(LIAuthentication*)authenticationWithToken:(NSString*)token {
    LIAuthentication* instance = [[self alloc]init];
    instance._token=token;
    return instance;
}

+(LIAuthentication*)authentication {
    return [[self alloc]init];
}

-(void)fetchUserInfos {
    NSString* url = [NSString stringWithFormat:@"https://api.linkedin.com/v1/people/~:(first-name,last-name,picture-url)?oauth2_access_token=%@", _token];
    NSURLRequest* request = [NSURLRequest requestWithURL:[NSURL URLWithString:url]];
    
    dispatch_queue_t queue = dispatch_queue_create("linkedin_parsing", NULL);
    dispatch_async(queue, ^{
        NSURLResponse *response;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:&error];

        if (error==nil) {
            NSXMLParser* xmlParser = [[NSXMLParser alloc]initWithData:receivedData];
            [xmlParser setDelegate:self];
            [xmlParser parse];
        } else {
            // Xml parser error
        }
    });
}

#pragma mark NSXMLParserDelegate protocol

-(void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict {
    currentString = [[NSMutableString alloc]init];
}

-(void)parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    [currentString appendString:string];
}

-(void)parser:(NSXMLParser *)parser didEndElement:(NSString *)elementName namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementName isEqualToString:@"first-name"]) {
        userFirstName = currentString;
    }
    if ([elementName isEqualToString:@"last-name"]) {
        userLastName = currentString;
    }
    if ([elementName isEqualToString:@"picture-url"]) {
        userPictureUrl = currentString;
    }
    currentString=nil;
}

-(void)parserDidEndDocument:(NSXMLParser *)parser {
    [[LISignIn sharedInstance].delegate finishedLIAuthentificationWithError:nil];
}


@end
