//
//  VBSampleForSerialization.m
//  AudioRecording
//
//  Created by victor on 4/12/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "VBSampleForSerialization.h"

@implementation VBSampleForSerialization

-(VBSampleForSerialization*) initWithUrl:(NSURL*) url andChannel:(int) channelId andPosition:(int) xValue
{
    self = [super init];
    self.url = url;
    self.channel = channelId;
    self.xvalue = xValue;    
    return self;
}

-(NSDictionary*)dictionary {
    return [NSDictionary dictionaryWithObjectsAndKeys:self.url, @"url", self.channel, @"channel", self.xvalue, @"xvalue", nil];
}

@end
