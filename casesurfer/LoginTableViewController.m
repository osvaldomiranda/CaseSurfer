//
//  LoginTableViewController.m
//  casesurfer
//
//  Created by Osvaldo on 04-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "LoginTableViewController.h"
#import "FeedViewController.h"
#import "Definitions.h"
#import "UIAlertView+Block.h"
#import "NSString+Validation.h"

@interface LoginTableViewController ()

@end

@implementation LoginTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.mySession = [[Session alloc] init];
    
    NSString *myEmail = [self.mySession getEmail];
    [self.email setText:myEmail];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:FALSE];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 5;
}

- (IBAction)login:(id)sender {
    
    if (![self.password.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@" "];
    } else if (![self.email.text isValidEmail]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Email."];
    } else {
        NSDictionary *userData = @{@"email": self.email.text,
                                   @"password": self.password.text};
        NSMutableDictionary *userParams =  @{@"sessions" : userData}.mutableCopy;
        [self.mySession login:userParams Success:^(NSMutableDictionary *items) {
            [self whenLogin];
        } Error:^(NSError *error) {
            [self accessDenied];
        }];
    }
}

-(void) whenLogin{
    [[NSNotificationCenter defaultCenter] postNotificationName:loginObserver
                                                        object:nil];
}


-(void) accessDenied{
    [UIAlertView alertViewOopsWithmessage:@"Invalid email or password."];
}

@end
