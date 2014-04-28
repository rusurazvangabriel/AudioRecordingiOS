//
//  RRSampleAddButton.h
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 24/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRSampleAddButton : UIButton
@property(assign,nonatomic) NSString *sampleName;
- (id)initWithFrame:(CGRect)frame andSampleName:(NSString *)sampleName;
@end
