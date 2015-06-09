//
//  UserNewViewController.h
//  casesurfer
//
//  Created by Osvaldo on 25-04-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UserNewViewController : UIViewController

@property (weak, nonatomic) IBOutlet UITextField *name;
- (IBAction)save:(id)sender;

@end
