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
#import "TermsOfUseViewController.h"
#import "AboutViewController.h"
#import "User.h"
#import "session.h"
#import "UIImageView+WebCache.h"
#import "Definitions.h"

@interface YouTableViewController ()

@end

@implementation YouTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.avatarImage.layer setMasksToBounds:YES];
    [self.avatarImage.layer setCornerRadius:55.0f];
    
    Session *mySession = [[Session alloc] init];
    User *myUser = [[User alloc] init];
    
    int myUserId = [mySession.getUserId intValue] ;
    
    [myUser find:myUserId Success:^(NSMutableDictionary *items) {
        [self fillUserAvatar:items];
    } Error:^(NSError *error) {
    }];
}

- (void) fillUserAvatar:(NSMutableDictionary *) items{
    NSDictionary *p = [items valueForKeyPath:@"profile_pic"];
    NSDictionary *pics = [p valueForKeyPath:@"profile_pic"];
    NSDictionary *thumb = [pics valueForKeyPath:@"normal"];
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@", [thumb valueForKeyPath:@"url"]];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.avatarImage setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
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

- (IBAction)termsOfUse:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    TermsOfUseViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"TermsOfUse"];
    cController.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:cController animated:YES];
}

- (IBAction)about:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    AboutViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"About"];
    cController.hidesBottomBarWhenPushed = TRUE;
    [self.navigationController pushViewController:cController animated:YES];
}

- (IBAction)help:(id)sender {
}

- (IBAction)notifications:(id)sender {
}

- (IBAction)profile:(id)sender {
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
