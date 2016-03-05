//
//  UserViewController.h
//  casesurfer
//
//  Created by Osvaldo on 10-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "rollGridChoseImageViewController.h"

@interface UserViewController : UIViewController 

@property (nonatomic, retain) NSMutableDictionary *profile;
@property (nonatomic, assign) int userId;
@property (nonatomic, retain) NSString *twitterUrl;
@property (nonatomic, retain) NSString *linkedinUrl;
@property (weak, nonatomic) IBOutlet UINavigationBar *navBar;
@property (weak, nonatomic) IBOutlet UIView *firstView;

@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblName;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtBio;
@property (weak, nonatomic) IBOutlet UITextField *txtAreasOfInterest;
@property (weak, nonatomic) IBOutlet UIButton *btnEdit;

- (IBAction)edit:(id)sender;
- (IBAction)cancel:(id)sender;
- (IBAction)twitterAction:(id)sender;
- (IBAction)linkedinAction:(id)sender;
- (IBAction)addAvatarImage:(id)sender;
@end
