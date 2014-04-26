//
//  VBSampleForSerialization.h
//  AudioRecording
//
//  Created by victor on 4/12/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VBSampleForSerialization : NSObject

@property(strong,nonatomic) NSString* name;

@property(nonatomic) int channel;

@property(nonatomic) int xvalue;

-(VBSampleForSerialization*) initWithUrl:(NSString*) name andChannel:(int) channelId andPosition:(int) xValue;

-(NSDictionary*)dictionary;

@end
