//
//  NewGroupViewController.m
//  casesurfer
//
//  Created by Osvaldo on 19-07-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "NewGroupViewController.h"
#import "UIAlertView+Block.h"
#import "NSString+Validation.h"
#import "Group.h"


@interface NewGroupViewController ()

@end

@implementation NewGroupViewController

- (void)viewDidLoad {
    [super viewDidLoad];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}


- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)create:(id)sender {
    [self createGroup:self];
}


- (IBAction)createGroup:(id)sender {
    
    if (![self.txtGroupName.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Group Name."];
    } else {

        NSDictionary *groupData = @{@"name": self.txtGroupName.text, @"group_user_ids": @""};
        
        NSMutableDictionary *groupParams =  @{@"group" : groupData}.mutableCopy;
        
        Group *group = [[Group alloc] initWithParams:groupParams];
        
        [group save:groupParams withSession:YES Success:^(NSMutableDictionary *items) {
            
            [self back:self];
 
        } Error:^(NSError *error) {
        }];

    }
}

@end
