//
//  ViewController.m
//  shaorMEv3
//
//  Created by LaboratoriOS Cronian Academy on 01/04/15.
//  Copyright (c) 2015 LaboratoriOS Cronian Academy. All rights reserved.
//

#import "ViewController.h"

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0]

@interface ViewController () <UIImagePickerControllerDelegate>
-(IBAction)uploadMethod:(UIButton *)sender;
-(IBAction)selectImage:(UIButton *)sender;
@property(strong, nonatomic) UIImage *imgSelected;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    // Do any additional setup after loading the view, typically from a nib.
    lblRating.text = [NSString stringWithFormat:@"%d", (int)increment.value];
    self.view.backgroundColor = UIColorFromRGB(0x1abc9c);

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(IBAction)valueChanged:(UIStepper *)sender{
    double value = [sender value];
    [lblRating setText:[NSString stringWithFormat:@"%d", ((int)value%5)+1]];
}

-(void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info{
    _imgSelected = [info objectForKey:UIImagePickerControllerOriginalImage];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

-(IBAction)selectImage:(UIButton *)sender{
    UIImagePickerController *pickerLibrary = [[UIImagePickerController alloc] init];
    pickerLibrary.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    pickerLibrary.delegate = self;
    [self presentModalViewController:pickerLibrary animated:YES];
    
}

-(IBAction)uploadMethod:(UIButton *)sender{
        PFObject *newShaormerie = [PFObject objectWithClassName:@"Shaormerii"];
        newShaormerie[@"name"]=txtName.text;
    
        NSNumberFormatter *f = [[NSNumberFormatter alloc] init];
        f.numberStyle = NSNumberFormatterDecimalStyle;
    
        newShaormerie[@"rating"]=lblRating.text;
        newShaormerie[@"averagePrice"]= [f numberFromString:txtRating.  text];
    
        newShaormerie[@"adress"]=txtAdress.text;
    
    NSData* data = UIImageJPEGRepresentation(_imgSelected, 0.5f);
    PFFile *imageFile = [PFFile fileWithName:txtName.text data:data];
    
         [newShaormerie setObject:imageFile forKey:@"image"];
        [newShaormerie saveInBackgroundWithBlock:^(BOOL succeeded, NSError *error) {
            // adauga validare pt daca exista deja sau nu in lista
            if(succeeded){
                UIAlertView *messageAlert = [[UIAlertView alloc]initWithTitle:@"Succes!" message: @"Ai uploadat shaormeria cu succes!" delegate:nil cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [messageAlert show];
                txtName.text = @"";
                txtAdress.text = @"";
                txtRating.text = @"";
                
            }
            else{
                NSLog(@"NOPE!!!!!!!!!!!!!");
            }
        }];

}

@end
