//
//  LILoginVC.h
//  LinkedInIos
//
//  Created by Marcel Falliere on 06/09/13.
//  Copyright (c) 2013 Marcel Falliere. All rights reserved.
//

#import "LILoginVC.h"


@implementation LILoginVC

@synthesize webView, cancelButton, activityIndicator;

#pragma mark UIViewController lifecycle

- (void)viewDidLoad
{
    webView.delegate = self;
    [cancelButton addTarget:self action:@selector(cancel:) forControlEvents:UIControlEventTouchUpInside];
    cancelButton.titleLabel.font = [UIFont fontWithName:@"Asap-Regular" size:12.0f];
    [activityIndicator startAnimating];
    [super viewDidLoad];
}

-(void)viewDidAppear:(BOOL)animated {
    NSString* clientId = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"LISignIn-clientId"];
    NSString* redirect = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"LISignIn-redirect"];
    NSString* url = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/authorization?response_type=code&client_id=%@&scope=r_basicprofile&state=98736462387648865723467923367125391283&redirect_uri=%@", clientId, redirect];
    NSURL* nsUrl = [NSURL URLWithString:url];
    NSURLRequest* request = [NSURLRequest requestWithURL:nsUrl cachePolicy:NSURLRequestReloadIgnoringLocalAndRemoteCacheData timeoutInterval:30];
    [webView loadRequest:request];
}

#pragma mark business stuff

-(void)cancel:(id)sender {
    [self dismissViewControllerAnimated:YES completion:^{
        [[LISignIn sharedInstance].delegate finishedLIAuthentificationWithError:[NSError errorWithDomain:@"canceled" code:0 userInfo:nil]];
    }];
}

-(void)fetchTokenWithCode:(NSString*)code {
    NSString* clientId = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"LISignIn-clientId"];
    NSString* clientSecret = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"LISignIn-clientSecret"];
    NSString* redirect = [[[NSBundle mainBundle] infoDictionary]valueForKey:@"LISignIn-redirect"];
    NSString* tokenUrl = [NSString stringWithFormat:@"https://www.linkedin.com/uas/oauth2/accessToken?grant_type=authorization_code&code=%@&redirect_uri=%@&client_id=%@&client_secret=%@", code, redirect,  clientId, clientSecret];
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:[NSURL URLWithString:tokenUrl]] ;
    request.HTTPMethod=@"POST";
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        NSURLResponse *response;
        NSError *error = nil;
        NSData *receivedData = [NSURLConnection sendSynchronousRequest:request
                                                     returningResponse:&response
                                                                 error:&error];
        if (error) {
            [self dismissViewControllerAnimated:YES completion:^{
                [[LISignIn sharedInstance].delegate finishedLIAuthentificationWithError:error];
            }];
            return;
        }
        
        NSString *responeString = [[NSString alloc] initWithData:receivedData encoding:NSUTF8StringEncoding];
        if ([responeString rangeOfString:@"expires_in"].location!=NSNotFound && [responeString rangeOfString:@"access_token"].location!=NSNotFound) {
            NSError* jsonError = nil;
            NSDictionary* receivedJson = [NSJSONSerialization JSONObjectWithData:receivedData options:kNilOptions error:&error];
            
            if (jsonError!=nil) {
                [self dismissViewControllerAnimated:YES completion:^{
                    [[LISignIn sharedInstance].delegate finishedLIAuthentificationWithError:jsonError];
                }];
            } else {
                NSString* accessToken = [receivedJson valueForKey:@"access_token"];
                LIAuthentication* auth = [LIAuthentication authenticationWithToken:accessToken];
                //if ([LISignIn sharedInstance].shouldFetchLinkedInUserInfos) {
                    [auth fetchUserInfos];
                //}
                [[LISignIn sharedInstance]setAuth:auth];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self dismissViewControllerAnimated:YES completion:^{
                        [[LISignIn sharedInstance].delegate finishedLIAuthentificationWithError:nil];
                    }];
                });
            }
        }
        
    });
}

#pragma mark UIWebViewDelegate protocol

- (void)webViewDidFinishLoad:(UIWebView *)webView {
    [activityIndicator stopAnimating];
}


- (void)webViewDidStartLoad:(UIWebView *)webView {
    [activityIndicator startAnimating];
}

- (BOOL)webView:(UIWebView*)webView shouldStartLoadWithRequest:(NSURLRequest*)request navigationType:(UIWebViewNavigationType)navigationType {
    NSString *url = [[request URL]absoluteString];
    if ([url rangeOfString:@"http://linkedin_oauth/success?code="].location != NSNotFound) {
        [activityIndicator startAnimating];
        NSString *codeAndState = [url substringFromIndex:@"http://intactprojects-lisignin/?code=".length-2];
        int stateIndex = [codeAndState rangeOfString:@"&state="].location;
        NSString* code = [codeAndState substringToIndex:stateIndex];
        [self fetchTokenWithCode:code];
    }
    
    return YES;
}

@end
