//
//  Session.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 10/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "Session.h"

@interface Session()
@property (readwrite,copy) NSString *userID;
@end

@implementation Session

- (id)initWithSessionID:(NSString*)userID
{
    self = [super init];
    if (self)
    {
        self.userID = userID;
    }
    return self;
}
@end


