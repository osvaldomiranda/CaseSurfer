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

@interface UserViewController ()

@end

@implementation UserViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self.userAvatar.layer setMasksToBounds:YES];
    [self.userAvatar.layer setCornerRadius:70.0f];
    
    Session *mySession = [[Session alloc] init];
    User *myUser = [[User alloc] init];
    
    int myUserId = [mySession.getUserId intValue] ;
    
    [myUser find:myUserId Success:^(NSMutableDictionary *items) {
        [self fillUserAvatar:items];
        [self fiilUser: items];
        
    } Error:^(NSError *error) {
    }];
}

- (void) fillUserAvatar:(NSMutableDictionary *) items{
    NSDictionary *p = [items valueForKeyPath:@"profile_pic"];
    NSDictionary *pics = [p valueForKeyPath:@"profile_pic"];
    NSDictionary *thumb = [pics valueForKeyPath:@"normal"];
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@", [thumb valueForKeyPath:@"url"]];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    [self.userAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
}

-(void) fiilUser:(NSMutableDictionary *) items{
    
    NSLog(@"ITEMS %@",items);
    
    self.lblName.text = [items valueForKeyPath:@"name"];
    self.lblTitle.text = [items valueForKeyPath:@"title"];
    self.lblEmail.text = [items valueForKeyPath:@"email"];
  //  self.txtBio.text = [[items valueForKeyPath:@"bios"] stringValue];
  //  self.txtAreasOfInterest.text = [items valueForKeyPath:@"areas_of_interest"];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (IBAction)cancel:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
