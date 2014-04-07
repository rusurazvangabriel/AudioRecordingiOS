//
//  EventObject.h
//  AnimationTest2
//
//  Created by LaboratoriOS Cronian Academy on 02/04/14.
//  Copyright (c) 2014 Lab1. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EventObject : NSObject

@property (weak, nonatomic) UIButton *Button;

@property (weak, nonatomic) NSString *sampleNameAndExtension;

@property int channelId;

@property BOOL triggered;

-(instancetype) initWithSampleName: (NSString *) sampleNameAndExtension andChannelId: (int) channelId andButton: (UIButton *) button;

@end
