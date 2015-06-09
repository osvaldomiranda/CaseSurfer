//
//  LoginTableViewController.h
//  casesurfer
//
//  Created by Osvaldo on 04-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Session.h"

@interface LoginTableViewController : UITableViewController
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *password;
@property (retain, nonatomic) Session *mySession;


- (IBAction)login:(id)sender;

@end
