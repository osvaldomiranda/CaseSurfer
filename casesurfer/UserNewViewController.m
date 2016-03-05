//
//  UserNewViewController.m
//  casesurfer
//
//  Created by Osvaldo on 25-04-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "UserNewViewController.h"
#import "User.h"

@interface UserNewViewController ()

@end

@implementation UserNewViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:FALSE];
}



- (IBAction)save:(id)sender {
    
   NSDictionary *user = @{@"name": self.name.text,
                           @"email": @"osvaldo@gmail.com",
                           @"password": @"pass",
                           @"password_confirmation": @"pass"};
    
    NSMutableDictionary *userParams =  @{@"user" : user }.mutableCopy;
    
    User *u = [[User alloc] initWithParams:userParams];
    
    [u save];
  
  
    //[self foo];
    
}

-(void) foo{
  /*  [User find:2 Success:^(NSMutableDictionary *items) {
        User *u = [[User alloc] initWithParams:items];
        
        NSLog(@"%@", [u getByKey:@"name"]);
        
    } Error:^(NSError *error) {
    }];
   */
}

@end
