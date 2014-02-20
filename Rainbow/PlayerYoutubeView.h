//
//  playerView.h
//  Whyd
//
//  Created by Damien Romito on 18/12/2013.
//  Copyright (c) 2013 Damien Romito. All rights reserved.
//

#import <UIKit/UIKit.h>

#define PLAYER_ACTION_NEXT @"/next"
#define PLAYER_ACTION_PLAY @"/play"


@interface PlayerYoutubeView : UIView <UIWebViewDelegate>
{
    BOOL pageLoaded;
    NSString* initTrack;
    UIWebView *myWeb;
}

@property (nonatomic, weak) id delegate;

- (id)initWithTrack:(NSString*)track;

- (void) changeTrack:(NSString*)id;
- (void) pauseTrack;
- (void) playTrack;


@end

@protocol PlayerYoutubeDelegate <NSObject>

- (void) trackYoutubeEnded;
- (void) trackYoutubePlay;

@end