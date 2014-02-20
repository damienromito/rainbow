//
//  PlaylistTableViewController.h
//  Rainbow
//
//  Created by Damien Romito on 25/12/2013.
//  Copyright (c) 2013 Damien Romito. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PlayerYoutubeView.h"
#import "TrackCell.h"

@interface PlaylistViewController : UIViewController<UITableViewDataSource, UITableViewDelegate, PlayerYoutubeDelegate>
{
    NSArray *tracks;
    PlayerYoutubeView *youtubeWebView;
    NSDictionary *currentTrack;
    int currentIndex;
    UILabel *headerMessage ;
    
    //PLAYER
    BOOL isPlaying;
    UIButton *playButton;
    UILabel *trackLabel;
    
}

@property (nonatomic, strong) UITableView *tableView;


@end
