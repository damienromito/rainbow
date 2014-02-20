//
//  TrackCell.m
//  Rainbow
//
//  Created by Damien Romito on 26/12/2013.
//  Copyright (c) 2013 Damien Romito. All rights reserved.
//

#import "TrackCell.h"

@implementation TrackCell

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
    }
    return self;
}


- (void) layoutSubviews
{
    [super layoutSubviews];
    
    [self setBackgroundColor:[UIColor whiteColor]];
    
    [self.textLabel setFrame:CGRectMake(15, 20, 320, 20)];
    [self.textLabel setTextColor:RGBCOLOR(64, 62, 69)];
    [self.textLabel setBackgroundColor:[UIColor clearColor]];
    
    [self.detailTextLabel setFrame:CGRectMake(15, 40, 320, 20)];
    [self.detailTextLabel setTextColor:RGBCOLOR(144, 141, 139)];
    [self.detailTextLabel setBackgroundColor:[UIColor clearColor]];

}

- (void) setTrack:(NSDictionary*)track
{
    [self.textLabel setText:[track objectForKey:@"title"]];
    [self.detailTextLabel setText:[track objectForKey:@"author"]];


}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];
    if(selected)
    {
        [self.contentView setBackgroundColor:RGBCOLOR(235, 230, 219)];

    }
}


@end
