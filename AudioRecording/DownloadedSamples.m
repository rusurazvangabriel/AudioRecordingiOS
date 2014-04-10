//
//  DownloadedSamples.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 10/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "DownloadedSamples.h"

@implementation DownloadedSamples

- (id)initWithSampleName:(NSString *)name andSampleUrl:(NSString *)url andHash:(NSString *)hash
{
    self = [super init];
    if(self)
    {
        self.sampleName = name;
        self.sampleUrl = url;
        self.sampleHash = hash;
    }
    return self;
}

@end
