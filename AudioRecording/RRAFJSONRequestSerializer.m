//
//  RRAFJSONRequestSerializer.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 16/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RRAFJSONRequestSerializer.h"

@implementation RRAFJSONRequestSerializer

- (NSURLRequest *)requestBySerializingRequest:(NSURLRequest *)request
                               withParameters:(id)parameters
                                        error:(NSError *__autoreleasing *)error {
    NSMutableURLRequest *mutableRequest = [[super requestBySerializingRequest:request withParameters:parameters error:error] mutableCopy];
    [mutableRequest setValue:@"application/vnd.mycom.mycom-csc+json" forHTTPHeaderField:@"Content-Type"];
    return mutableRequest;
}

@end
