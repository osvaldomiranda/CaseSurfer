//
//  ProfileTableViewController.h
//  casesurfer
//
//  Created by Osvaldo on 04-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ProfileTableViewController : UITableViewController

@property (nonatomic, assign) NSMutableDictionary *profile;
@property (nonatomic, assign) int userId;
@property (weak, nonatomic) IBOutlet UITextField *txtName;
@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtEmail;
@property (weak, nonatomic) IBOutlet UITextField *txtTwitter;
@property (weak, nonatomic) IBOutlet UITextField *txtLinkedin;
@property (weak, nonatomic) IBOutlet UITextField *txtBio;
@property (weak, nonatomic) IBOutlet UITextField *txtAofInterest;

- (IBAction)cancel:(id)sender;
- (IBAction)done:(id)sender;

@end
