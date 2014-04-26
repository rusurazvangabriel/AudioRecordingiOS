//
//  VBSampleForSerialization.m
//  AudioRecording
//
//  Created by victor on 4/12/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "VBSampleForSerialization.h"

@implementation VBSampleForSerialization

-(VBSampleForSerialization*) initWithUrl:(NSString*) name andChannel:(int) channelId andPosition:(int) xValue
{
    self = [super init];
    self.name = name;
    self.channel = channelId;
    self.xvalue = xValue;    
    return self;
}

-(NSDictionary*)dictionary {
    NSDictionary * dict =  [NSDictionary dictionaryWithObjectsAndKeys:self.name, @"url",  [NSNumber numberWithInt:self.channel], @"channel", [NSNumber numberWithInt:self.xvalue], @"xvalue", nil];
    return dict;
}

@end
