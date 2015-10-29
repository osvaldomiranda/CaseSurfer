//
//  CaseDescripViewController.m
//  casesurfer
//
//  Created by Osvaldo on 08-10-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CaseDescripViewController.h"

@interface CaseDescripViewController ()

@end

@implementation CaseDescripViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
     NSLog(@"DESCRIPT %@",self.descripText);
    
    self.txtDescript.text = self.descripText;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}



@end
