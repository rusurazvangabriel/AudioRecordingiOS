//
//  RRTableViewCell.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 04/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RRTableViewCell.h"
#import "AudioPlayer.h"
#import "RRSampleListPlayButton.h"
#import "RRSampleListDeleteButton.h"

@implementation RRTableViewCell

- (id)initWithStyle:(UITableViewCellStyle)style andSampleName:(NSString *)sampleName reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        self.sampleName = sampleName;
        self.layer.borderColor = [UIColor darkGrayColor].CGColor;
        self.layer.borderWidth = 0.4f;
        self.layer.cornerRadius = 2.0f;
        self.selectionStyle = UITableViewCellSelectionStyleNone;
        _player = [[AudioPlayer alloc] init];
        
        RRSampleListPlayButton *playButton = [[RRSampleListPlayButton alloc] initWithFrame:CGRectMake(4, 4, 40, 40)];
        playButton.sampleName = sampleName;
        
        UILabel *nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(50,10,200,14)];
        [nameLabel setFont:[UIFont systemFontOfSize:11.0f]];
        nameLabel.text = [_sampleName substringWithRange:NSMakeRange(0, [_sampleName rangeOfString: @"."].location)];
        nameLabel.textColor = [UIColor blackColor];
        
        UILabel *duration = [[UILabel alloc] initWithFrame:CGRectMake(50, 30, 150, 14)];
        duration.text = [NSString stringWithFormat:@"Duration: %f s",[self.player getSampleLengthForSamplename:sampleName]];
        duration.textColor = [UIColor darkGrayColor];
        [duration setFont:[UIFont systemFontOfSize:11.0f]];
        

        [[self contentView] addSubview:nameLabel];
        [[self contentView] addSubview:duration];
        [[self contentView] addSubview:playButton];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


@end
