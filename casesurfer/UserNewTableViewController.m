//
//  UserNewTableViewController.m
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "UserNewTableViewController.h"
#import "TermsOfUseViewController.h"
#import "User.h"
#import "Notification.h"
#import "session.h"
#import "NSString+Validation.h"
#import "UIAlertView+Block.h"
#import "Definitions.h"

@interface UserNewTableViewController ()

@end

@implementation UserNewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
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
    return 7;
}


- (IBAction)termsOfUse:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TermsOfUseViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"TermsOfUse"];
    cController.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:cController animated:YES];
}

- (IBAction)signUp:(id)sender {
    if (![self.txtName.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Name."];
    } else if (![self.txtEmail.text isValidEmail]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Email."];
    } else if (![self.txtPassword.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Password."];
    } else if (![self.txtRepeatPassword.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Password Confirmation."];
    } else if (![self.txtPassword.text isEqualToString:self.txtRepeatPassword.text]) {
        [UIAlertView alertViewOopsWithmessage:@"The passwords must be identical."];
    } else if (![self.swAgree isOn]) {
        [UIAlertView alertViewOopsWithmessage:@"You must accept the terms of use."];
    } else {
        NSDictionary *userData = @{@"name": self.txtName.text,
                                   @"email": self.txtEmail.text,
                                   @"password": self.txtPassword.text,
                                   @"password_confirmation": self.txtRepeatPassword.text};
        NSMutableDictionary *userParams =  @{@"user" : userData}.mutableCopy;
        User *user = [[User alloc] initWithParams:userParams];
        [user save:userParams withSession:NO Success:^(NSMutableDictionary *items) {
            Session *session = [[Session alloc] init];
            [session saveToken:[items valueForKeyPath:@"auth_token"]];
            [session saveEmail:[items valueForKeyPath:@"email"]];
            [self whenLogin];
        } Error:^(NSError *error) {
        }];
    }
}

-(void) whenLogin{
    [[NSNotificationCenter defaultCenter] postNotificationName:loginObserver
                                                        object:nil];
}
@end
