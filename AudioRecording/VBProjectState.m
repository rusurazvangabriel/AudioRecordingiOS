//
//  VBProjectState.m
//  AudioRecording
//
//  Created by victor on 4/12/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "VBProjectState.h"

@interface VBProjectState ()

/*

 // eventual o sa folosim si asta, nu?
@property(strong, nonatomic) NSString* name;

*/

@end


@implementation VBProjectState

-(VBProjectState*) initWithSampleList: (NSArray*) sl
{
    self = [super init];
    self.sampleList = sl;
    return self;
}

-(NSArray*) getSampleList
{
    return self.sampleList;
}

-(NSDictionary*)dictionary {
    NSDictionary *dictonary = [NSDictionary dictionaryWithObjectsAndKeys:self.sampleList, @"sampleList", nil];
    return dictonary;
}

@end