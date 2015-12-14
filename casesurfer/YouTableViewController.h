//
//  YouTableViewController.h
//  casesurfer
//
//  Created by Osvaldo on 29-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface YouTableViewController : UITableViewController

@property (weak, nonatomic) IBOutlet UIImageView *avatarImage;
@property (weak, nonatomic) IBOutlet UIButton *guidelines;

- (IBAction)logOut:(id)sender;
- (IBAction)termsOfUse:(id)sender;
- (IBAction)about:(id)sender;
- (IBAction)help:(id)sender;
- (IBAction)notifications:(id)sender;
- (IBAction)profile:(id)sender;
- (IBAction)guidelines:(id)sender;



@end
