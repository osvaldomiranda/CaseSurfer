//
//  UserViewController.m
//  casesurfer
//
//  Created by Osvaldo on 16-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "UserViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController
@synthesize userAvatar;

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [userAvatar.layer setMasksToBounds:YES];
    [userAvatar.layer setCornerRadius:70.0f];


    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



- (IBAction)back:(id)sender {
      [self.navigationController popViewControllerAnimated:YES];
}

@end
