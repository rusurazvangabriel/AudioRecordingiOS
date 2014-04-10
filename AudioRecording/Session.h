//
//  Session.h
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 10/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Session : NSObject

@property(readonly, copy) NSString *sessionId;

- (id)initWithSessionID:(NSString*)userID;
@end
