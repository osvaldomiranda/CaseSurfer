//
//  ProfileTableViewController.m
//  casesurfer
//
//  Created by Osvaldo on 04-08-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "ProfileTableViewController.h"

#import "NSString+Validation.h"
#import "Definitions.h"
#import "UIAlertView+Block.h"
#import "User.h"

@interface ProfileTableViewController ()

@end

@implementation ProfileTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
   
    
    [self fillData];
 
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
     self.hidesBottomBarWhenPushed =  YES;
}

- (void) fillData {
    self.txtName.text = [NSString stringWithFormat:@"%@",[self.profile valueForKeyPath:@"name"]];
    self.txtTitle.text = [NSString stringWithFormat:@"%@",[self.profile valueForKeyPath:@"tilte"]];
    self.txtEmail.text = [NSString stringWithFormat:@"%@",[self.profile valueForKeyPath:@"email"]];
    
    self.txtBio.text = [NSString stringWithFormat:@"%@",[self.profile valueForKeyPath:@"bios"]];
    self.txtAofInterest.text = [NSString stringWithFormat:@"%@", [self.profile valueForKeyPath:@"areas_of_interest"]];
    self.txtTwitter.text = [NSString stringWithFormat:@"%@", [self.profile valueForKeyPath:@"twitter"]];
    self.txtLinkedin.text = [NSString stringWithFormat:@"%@", [self.profile valueForKeyPath:@"linkedin"]];
    
    if ([self.txtName.text  isEqual: @"<null>"]) {
        self.txtName.text = @"";
    }
    if ([self.txtTitle.text  isEqual: @"<null>"]) {
        self.txtTitle.text = @"";
    }
    if ([self.txtEmail.text  isEqual: @"<null>"]) {
        self.txtEmail.text = @"";
    }
    if ([self.txtBio.text  isEqual: @"<null>"]) {
        self.txtBio.text = @"";
    }
    if ([self.txtAofInterest.text  isEqual: @"<null>"]) {
        self.txtAofInterest.text = @"";
    }
    if ([self.txtTwitter.text  isEqual: @"<null>"]) {
        self.txtTwitter.text = @"";
    }
    if ([self.txtLinkedin.text  isEqual: @"<null>"]) {
        self.txtLinkedin.text = @"";
    }
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    
    return 8;
}


- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}


- (IBAction)done:(id)sender {
    
    if (![self.txtName.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Name."];
    } else if (![self.txtTitle.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Title."];
    } else if (![self.txtEmail.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Email."];
    } else {
        
        
        NSDictionary *profileData = @{@"name": self.txtName.text,
                                      @"tilte": self.txtTitle.text,
                                      @"email" : self.txtEmail.text,
                                      @"twitter" : self.txtTwitter.text,
                                      @"linkedin" : self.txtLinkedin.text,
                                      @"bios" : self.txtBio.text,
                                      @"areas_of_interest" :self.txtAofInterest.text
                                      };
        
        NSMutableDictionary *profileParams =  @{@"user" : profileData}.mutableCopy;
        
        User *user = [[User alloc] initWithParams:profileParams];
        
        [user update:self.userId params:profileParams Success:^(NSMutableDictionary *items) {
            [UIAlertView alertViewOopsWithmessage:@"Update profile Ok"];
            [self.navigationController popViewControllerAnimated:YES];
        } Error:^(NSError *error) {
        }];
        
    }
    
 
    /*
     "user"=>{"_destroy"=>"false", "twitter"=>"", "linkedin"=>"", "name"=>"osvaldo12", "bios"=>"Prueba de Bios", "areas_of_interest"=>"Prueba de Areas of interest"},
     */
}

@end
