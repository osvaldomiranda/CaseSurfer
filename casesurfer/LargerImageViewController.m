//
//  LargerImageViewController.m
//  casesurfer
//
//  Created by Osvaldo on 27-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "LargerImageViewController.h"

@interface LargerImageViewController ()

@end

@implementation LargerImageViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.displayImage.image = self.originalImage;
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}
@end
