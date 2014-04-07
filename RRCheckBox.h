//
//  RRCheckBox.h
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 02/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface RRCheckBox : UIButton

@property(assign,nonatomic) BOOL checked;

- (id)initWithCoordinates:(CGPoint)point;

@end
