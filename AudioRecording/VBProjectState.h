//
//  VBProjectState.h
//  AudioRecording
//
//  Created by victor on 4/12/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VBProjectState : NSObject

@property(strong,nonatomic) NSArray* sampleList;

-(VBProjectState*) initWithSampleList: (NSArray*) sl;

-(NSDictionary*)dictionary;

@end
