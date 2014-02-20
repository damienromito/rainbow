//
//  playerView.m
//  Whyd
//
//  Created by Damien Romito on 18/12/2013.
//  Copyright (c) 2013 Damien Romito. All rights reserved.
//

#import "PlayerYoutubeView.h"

@implementation PlayerYoutubeView


- (id)initWithTrack:(NSString*)track
{
    self = [super init];
    if (self) {
        initTrack = track;
        myWeb = [[UIWebView alloc] initWithFrame:CGRectMake(0, 0, 320, 0)];
        myWeb.delegate = self;
        myWeb.backgroundColor = [UIColor redColor];
        myWeb.mediaPlaybackRequiresUserAction = NO;
        myWeb.allowsInlineMediaPlayback = YES;
        [self addSubview:myWeb];
        
        
        NSString *htmlFile = [[NSBundle mainBundle] pathForResource:@"youtubePlayer" ofType:@"html"];
        NSString* htmlString = [NSString stringWithContentsOfFile:htmlFile encoding:NSUTF8StringEncoding error:nil];
        [myWeb loadHTMLString:htmlString baseURL:nil];
    }
    return self;
}


- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    if(!pageLoaded)
    {
        NSString * jsCallBack = [NSString stringWithFormat:@"initWithTrack('%@')", initTrack];
        [myWeb stringByEvaluatingJavaScriptFromString:jsCallBack];
        pageLoaded = YES;
    }
}

- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType {
    NSLog(@"REQUEST %@", request.URL);
    if ([[request.URL scheme] isEqual:@"whyd"]) {
        if ([[request.URL path] isEqual:PLAYER_ACTION_PLAY]) {
            [self.delegate trackYoutubePlay];
        }
        else if ([[request.URL path] isEqual:PLAYER_ACTION_NEXT]) {
            [self.delegate trackYoutubeEnded];
        }
        return NO; // Tells the webView not to load the URL
    }
    else {
        return YES; // Tells the webView to go ahead and load the URL
    }
    
    return YES;
}

- (void) changeTrack:(NSString*)id
{
    NSString * jsCallBack = [NSString stringWithFormat:@"changeTrack('%@')", id];
    [myWeb stringByEvaluatingJavaScriptFromString:jsCallBack];

}

- (void) pauseTrack
{
    [myWeb stringByEvaluatingJavaScriptFromString:@"pauseTrack()"];
}

- (void) playTrack
{
    [myWeb stringByEvaluatingJavaScriptFromString:@"playTrack()"];
}

@end
