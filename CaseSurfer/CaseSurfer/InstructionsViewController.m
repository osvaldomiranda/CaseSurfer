//
//  InstructionsViewController.m
//  casesurfer
//
//  Created by Osvaldo Miranda on 23/11/15.
//  Copyright © 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "InstructionsViewController.h"

@interface InstructionsViewController ()

@end

@implementation InstructionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
