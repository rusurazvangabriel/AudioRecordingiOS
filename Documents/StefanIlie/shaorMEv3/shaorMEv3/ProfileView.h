//
//  ProfileView.h
//  shaorMEv3
//
//  Created by LaboratoriOS Cronian Academy on 29/04/15.
//  Copyright (c) 2015 LaboratoriOS Cronian Academy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Parse/Parse.h>

@interface ProfileView : UIViewController{
    
    IBOutlet UIImageView *imgProfile;
    IBOutlet UILabel *lblNume;
    IBOutlet UILabel *lblMail;
    IBOutlet UIButton *btnLogout;
}

@end
