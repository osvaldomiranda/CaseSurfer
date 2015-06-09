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

- (IBAction)logOut:(id)sender;
@end
