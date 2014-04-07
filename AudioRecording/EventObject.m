//
//  EventObject.m
//  AnimationTest2
//
//  Created by LaboratoriOS Cronian Academy on 02/04/14.
//  Copyright (c) 2014 Lab1. All rights reserved.
//

#import "EventObject.h"

@interface EventObject ()

@end

@implementation EventObject

-(instancetype) initWithSampleName: (NSString *) sampleNameAndExtension andChannelId: (int) channelId andButton: (UIButton *) button {
    self = [super init];
    if (self) {
        self.Button = button;
        self.sampleNameAndExtension = sampleNameAndExtension;
        self.channelId = channelId;
        
        self.triggered = NO;
        
    }
    return self;
    
}


@end
