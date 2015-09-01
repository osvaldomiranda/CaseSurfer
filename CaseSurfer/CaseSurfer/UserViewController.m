//
//  UserViewController.m
//  casesurfer
//
//  Created by Osvaldo on 10-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "UserViewController.h"
#import "session.h"
#import "User.h"
#import "UIImageView+WebCache.h"
#import "Definitions.h"
#import "ProfileTableViewController.h"
#import "WebViewController.h"
#import "rollGridChoseImageViewController.h"

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self.userAvatar.layer setMasksToBounds:YES];
    [self.userAvatar.layer setCornerRadius:70.0f];
    self.twitterUrl = @"";
    self.linkedinUrl = @"";
    
    if(self.userId == nil){
        Session *mySession = [[Session alloc] init];
        self.userId = [mySession.getUserId intValue];
        self.btnEdit.hidden = FALSE;
        self.firstView.frame = CGRectMake(0, self.firstView.frame.origin.y-64, self.firstView.frame.size.width,self.firstView.frame.size.height);
    }
    else{
        self.btnEdit.hidden = TRUE;
        self.firstView.frame = CGRectMake(0,64, self.firstView.frame.size.width,self.firstView.frame.size.height);
    }
    
    Session *mySession = [[Session alloc] init];
    if (  self.userId == [mySession.getUserId intValue])
    {
        self.btnEdit.hidden = FALSE;
    }
}

- (void)viewDidAppear:(BOOL)animated {
    [super viewDidAppear:animated];

    User *myUser = [[User alloc] init];
    [myUser find:self.userId Success:^(NSMutableDictionary *items) {
        self.profile = items;
        [self fillUserAvatar:items];
        [self fiilUser: items];
        
    } Error:^(NSError *error) {
    }];
    
}


- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    self.hidesBottomBarWhenPushed =  YES;
    [self.navigationController setNavigationBarHidden:FALSE];
}


- (void) fillUserAvatar:(NSMutableDictionary *) items{
    NSDictionary *p = [items valueForKeyPath:@"profile_pic"];
    NSDictionary *pics = [p valueForKeyPath:@"profile_pic"];
    NSDictionary *thumb = [pics valueForKeyPath:@"normal"];
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@%@",DEV_BASE_PATH, [thumb valueForKeyPath:@"url"]];
    
    NSLog(@"userAvatarUrl %@",userAvatarUrl);
    
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.userAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
}

-(void) fiilUser:(NSMutableDictionary *) items{
    
    NSLog(@"%@",items);
    
    self.lblName.text = [NSString stringWithFormat:@"%@",[items valueForKeyPath:@"name"]];
    self.lblTitle.text = [NSString stringWithFormat:@"%@", [items valueForKeyPath:@"tilte"]];
    self.lblEmail.text = [NSString stringWithFormat:@"%@",[items valueForKeyPath:@"email"]];
    self.txtBio.text = [NSString stringWithFormat:@"%@", [items valueForKeyPath:@"bios"]];
    self.txtAreasOfInterest.text = [NSString stringWithFormat:@"%@",  [items valueForKeyPath:@"areas_of_interest"]];
    self.linkedinUrl =[NSString stringWithFormat:@"%@",  [items valueForKeyPath:@"linkedin"]];
    self.twitterUrl =[NSString stringWithFormat:@"%@",  [items valueForKeyPath:@"twitter"]];
    
    if ([self.lblName.text  isEqual: @"<null>"]) {
        self.lblName.text = @"";
    }
    if ([self.lblTitle.text  isEqual: @"<null>"]) {
        self.lblTitle.text = @"";
    }
    if ([self.lblEmail.text  isEqual: @"<null>"]) {
        self.lblEmail.text = @"";
    }
    if ([self.txtAreasOfInterest.text  isEqual: @"<null>"]) {
        self.txtAreasOfInterest.text = @"";
    }
    if ([self.txtBio.text  isEqual: @"<null>"]) {
        self.txtBio.text = @"";
    }
    if ([self.linkedinUrl  isEqual: @"<null>"]) {
        self.linkedinUrl = @"";
    }
    if ([self.twitterUrl  isEqual: @"<null>"]) {
        self.twitterUrl = @"";
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}


- (IBAction)edit:(id)sender {
    Session *mySession = [[Session alloc] init];
    if (  self.userId == [mySession.getUserId intValue]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        ProfileTableViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"SetProfile"];
        
        cController.profile = self.profile;
        cController.userId = self.userId;
        
        [cController.navigationController setNavigationBarHidden:NO];
        cController.hidesBottomBarWhenPushed = YES;
        [[self navigationController] pushViewController:cController animated:YES];
    }
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)twitterAction:(id)sender {
     [self sendToWebUrl:self.twitterUrl];
}

- (IBAction)linkedinAction:(id)sender {
     [self sendToWebUrl:self.linkedinUrl];
}

- (IBAction)addAvatarImage:(id)sender {
    Session *mySession = [[Session alloc] init];
    if (  self.userId == [mySession.getUserId intValue]) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        rollGridChoseImageViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"rollGridChose"];
        cController.callerViewController = self;
        self.hidesBottomBarWhenPushed =  YES;
        [self.navigationController pushViewController:cController animated:YES];


    }
}



- (void) sendToWebUrl:(NSString *) url {
    if ( (url != NULL) && (![url isEqualToString:@""])) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        WebViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Web"];
        
        [cController setUrlLead:url];
        
        cController.hidesBottomBarWhenPushed =  YES;
        [self.navigationController pushViewController:cController animated:YES];
    }
}

@end
