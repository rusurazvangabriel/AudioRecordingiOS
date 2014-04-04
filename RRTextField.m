//
//  RRTextField.m
//  AudioRecording
//
//  Created by LaboratoriOS Cronian Academy on 02/04/14.
//  Copyright (c) 2014 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "RRTextField.h"

@implementation RRTextField

- (id)initWithCoordinates:(float)x y:(float)y
{
    self = [super initWithFrame:CGRectMake(x, y, 240, 35)];
    if (self) {
        self.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
        self.layer.borderColor = [UIColor blackColor].CGColor;
        self.layer.borderWidth = 0.6f;
        self.keyboardType = UIKeyboardTypeDefault;
        self.layer.cornerRadius = 5.0f;
        self.layer.shadowRadius = 3.0f;
        self.layer.shadowColor = [UIColor blackColor].CGColor;
        self.layer.shadowOffset = CGSizeMake(2.0f, 3.0f);
        self.layer.shadowOpacity = 0.8f;
        self.layer.masksToBounds = NO;
        self.autocorrectionType = UITextAutocorrectionTypeNo;
    }
    return self;
}

//_fileNameTextField.backgroundColor = [UIColor whiteColor];
//_fileNameTextField.layer.sublayerTransform = CATransform3DMakeTranslation(10, 0, 0);
//_fileNameTextField.layer.cornerRadius = 7.0f;
//_fileNameTextField.layer.shadowRadius = 3.0f;
//_fileNameTextField.layer.borderWidth = 0.3f;
//_fileNameTextField.layer.shadowColor = [UIColor blackColor].CGColor;
//_fileNameTextField.layer.shadowOffset = CGSizeMake(2.0f, 3.0f);
//_fileNameTextField.layer.shadowOpacity = 0.8f;
//_fileNameTextField.layer.masksToBounds = NO;
//


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
