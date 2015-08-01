//
//  UserViewController.h
//  casesurfer
//
//  Created by Osvaldo on 10-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtBio;
@property (weak, nonatomic) IBOutlet UITextField *txtAreasOfInterest;



- (IBAction)cancel:(id)sender;
@end
