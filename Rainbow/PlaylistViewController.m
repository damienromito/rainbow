//
//  PlaylistTableViewController.m
//  Rainbow
//
//  Created by Damien Romito on 25/12/2013.
//  Copyright (c) 2013 Damien Romito. All rights reserved.
//

#import "PlaylistViewController.h"


@implementation PlaylistViewController


- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        
        [self.view setBackgroundColor:BLUE_COLOR];
        self.title = @"Rainbow Songs";
        
    }
    return self;
}

- (void)viewWillAppear:(BOOL)animated
{
    
    [super viewWillAppear:animated];
    
    self.navigationController.navigationBar.titleTextAttributes = [NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName];
    [self.navigationController.navigationBar setBackgroundImage:[UIImage imageNamed:@"header_bg"] forBarMetrics:UIBarMetricsDefault];
    [self.navigationController.navigationBar setTranslucent:NO];
    if ([self respondsToSelector:@selector(edgesForExtendedLayout)])
    {
        self.edgesForExtendedLayout = UIRectEdgeNone;
        self.extendedLayoutIncludesOpaqueBars=NO;
    }
    
    [self reloadJson];

}


- (void)viewDidLoad
{
    [super viewDidLoad];

    
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"  " style:UITableViewCellStyleDefault target:self action:@selector(reloadJson)];
    /////////////////////////// TABLEVIEW ///////////////////////////
    
    
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, self.view.bounds.origin.y, 320, self.view.bounds.size.height - 80) style:UITableViewStylePlain ];
    self.tableView.autoresizingMask = UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleHeight;
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView setBackgroundColor:RGBCOLOR(235, 230, 219)];
    [self.tableView setSeparatorInset:UIEdgeInsetsZero];
    [self.view addSubview:self.tableView];
    
    UIImageView *hello = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"hello"]];
    [hello setFrame:CGRectMake(80, -150, hello.frame.size.width, hello.frame.size.height)];
    [self.tableView addSubview:hello];
    
    //HEADER MESSAGE
    
    headerMessage = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 320, 100)];
    [headerMessage setTextColor:RGBCOLOR(64, 62, 69)];
    [headerMessage setFont:[UIFont boldSystemFontOfSize:15]];
    headerMessage.numberOfLines = 3;
    [headerMessage setTextAlignment:NSTextAlignmentCenter];
    self.tableView.tableHeaderView = headerMessage;
    
    
    
    /////////////////////////// PLAYER ///////////////////////////
    UIView *player = [[UIView alloc] initWithFrame:CGRectMake(0, self.view.bounds.size.height - 80, 320, 100)];
    player.autoresizingMask = UIViewAutoresizingFlexibleTopMargin;
    [player setBackgroundColor:RGBCOLOR(140, 192, 187)];
    [self.view addSubview:player];
    
    playButton = [[UIButton alloc] initWithFrame:CGRectMake(20, 20, 42, 42)];
    [playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
    [playButton addTarget:self action:@selector(playTrackButton) forControlEvents:UIControlEventTouchUpInside];
    [player addSubview:playButton];
    
    trackLabel = [[UILabel alloc] initWithFrame:CGRectMake(80, 25, 230, 30)];
    [trackLabel setBackgroundColor:CLEAR_COLOR];
    [trackLabel setTextColor:WHITE_COLOR];
    [player addSubview:trackLabel];
    
    /////////////////////////// INIT ///////////////////////////
    

    
}

- (void) reloadJson
{
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0ul);
    dispatch_async(queue, ^{
        
        NSURL * url = [[NSURL alloc] initWithString:@"http://www.romito.fr/public/rainbow_songs.json"];
        
        NSData *data = [[NSData alloc]initWithContentsOfURL:url];
        dispatch_sync(dispatch_get_main_queue(), ^{
            
            NSError *localError = nil;
            
            NSString *message = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&localError] objectForKey:@"message"];
            [headerMessage setText:[NSString stringWithFormat:@"\"%@\"",message]];
            
            tracks = [[NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&localError] objectForKey:@"tracks"];
            currentIndex = 0;
            [self.tableView reloadData];
            [self loadCurrentTrack];
            
            
        });
    });
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark - Table view data source

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 75;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    return tracks.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString* cellIdentifier= @"Cell";
    
    TrackCell *cell = [self.tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (cell == nil)
    {
        cell = [[TrackCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
        
    [cell setTrack:[tracks objectAtIndex:indexPath.row]];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    currentIndex = indexPath.row;
    currentTrack = [tracks objectAtIndex:currentIndex];
    [self changeTrack];
}


#pragma -mark Track Interactions

- (void) changeTrack
{
    [trackLabel setText:@"loading"];
    isPlaying = YES;
    [self updatePlayButtonState];

    if (youtubeWebView == nil)
    {
        youtubeWebView = [[PlayerYoutubeView alloc] initWithTrack:[currentTrack objectForKey:@"youtube_id"]];
        youtubeWebView.delegate = self;
        [self.view addSubview:youtubeWebView];
    }
    else
    {
        [youtubeWebView changeTrack:[currentTrack objectForKey:@"youtube_id"]];
    }
    
}

- (void) loadCurrentTrack
{
    currentTrack = [tracks objectAtIndex:currentIndex];
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:currentIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionMiddle];
    [self changeTrack];
    
}

- (void) updatePlayButtonState
{
    if(isPlaying)
    {
        [playButton setImage:[UIImage imageNamed:@"pause_button"] forState:UIControlStateNormal];
    }
    else
    {
        [playButton setImage:[UIImage imageNamed:@"play_button"] forState:UIControlStateNormal];
    }
}

#pragma -mark Player Action

- (void) playTrackButton{
    if(isPlaying)
    {
        isPlaying = NO;
    }
    else
    {
        isPlaying = YES;
    }
    [self updatePlayButtonState];

    if (isPlaying) {
        [youtubeWebView playTrack];
    }else{
        [youtubeWebView pauseTrack];
    }
    
}

#pragma -mark PlayerYoutube Delegate

- (void)trackYoutubeEnded
{
    if(currentIndex < tracks.count)
    {
        currentIndex ++;
        [self loadCurrentTrack];
    }
    else
    {
        return;
    }
}

- (void) trackYoutubePlay
{
    [trackLabel setText:[NSString stringWithFormat:@"%@ - %@",[currentTrack objectForKey:@"author"], [currentTrack objectForKey:@"title"]]];
    
}


@end
