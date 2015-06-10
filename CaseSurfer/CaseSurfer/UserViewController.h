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

- (IBAction)cancel:(id)sender;
@end
