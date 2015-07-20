//
//  NewGroupViewController.h
//  casesurfer
//
//  Created by Osvaldo on 19-07-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewGroupViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *txtGroupName;

- (IBAction)back:(id)sender;
- (IBAction)create:(id)sender;

@end
