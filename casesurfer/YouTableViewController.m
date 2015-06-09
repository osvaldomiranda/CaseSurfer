//
//  YouTableViewController.m
//  casesurfer
//
//  Created by Osvaldo on 29-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "YouTableViewController.h"
#import "ViewController.h"
#import "session.h"

@interface YouTableViewController ()

@end

@implementation YouTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.avatarImage.layer setMasksToBounds:YES];
    [self.avatarImage.layer setCornerRadius:55.0f];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
  
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {

    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    return 7;
}

- (IBAction)logOut:(id)sender {
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@" LogOut ? "
                                                    message:@" "
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    alert.tag = 1;
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (alertView.tag == 1) {
        if (buttonIndex != 0)  // 0 ==  cancel button
        {
            
            Session *mySession = [[Session alloc] init];
            [mySession destroy];
            
            UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
            ViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Landing"];
            
            cController.hidesBottomBarWhenPushed =  YES;
            [self.navigationController pushViewController:cController animated:YES];
        }
    }
}
@end
