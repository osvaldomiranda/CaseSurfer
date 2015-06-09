//
//  ViewController.h
//  casesurfer
//
//  Created by Osvaldo on 25-04-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController
@property (weak, nonatomic) IBOutlet UIView *bkg_signup;

@property (weak, nonatomic) IBOutlet UIView *bkg_login;

- (IBAction)buttonLogin:(id)sender;
- (IBAction)ButtonSignUp:(id)sender;

@end

