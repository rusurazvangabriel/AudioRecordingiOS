//
//  RRTableViewCell.h
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 04/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AudioPlayer.h"
#import "RRSampleListPlayButton.h"

@interface RRTableViewCell : UITableViewCell
@property (nonatomic, weak)  UILabel *nameLabel;
@property (nonatomic, weak)  UILabel *tagsLabel;
@property (nonatomic, assign) NSString *sampleName;
- (id)initWithStyle:(UITableViewCellStyle)style andSampleName:(NSString *)sampleName reuseIdentifier:(NSString *)reuseIdentifier;
@property (nonatomic, strong) AudioPlayer *player;
@property (nonatomic, strong) RRSampleListPlayButton *playButton;

@end
