//
//  DownloadedSamples.h
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 10/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface DownloadedSamples : NSObject

@property(nonatomic,assign) NSString *sampleName;
@property(nonatomic,assign) NSString *sampleUrl;
@property(nonatomic,assign) NSString *sampleHash;
- (id)initWithSampleName:(NSString *)name andSampleUrl:(NSString *)url andHash:(NSString *)hash;
@end
