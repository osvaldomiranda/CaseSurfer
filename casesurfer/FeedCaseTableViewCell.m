//
//  FeedCaseTableViewCell.m
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "FeedCaseTableViewCell.h"
#import "CaseViewController.h"
#import "UserViewController.h"

@implementation FeedCaseTableViewCell
@synthesize userAvatar;
@synthesize callerViewController;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)layoutSubviews
{
    [userAvatar.layer setMasksToBounds:YES];
    [userAvatar.layer setCornerRadius:17.5f];
}

- (IBAction)userAction:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UserViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"User"];
    cController.hidesBottomBarWhenPushed = YES;
    
    [[[self callerViewController] navigationController] pushViewController:cController animated:YES];
    
}

- (IBAction)caseAction:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CaseViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Case"];
    cController.caseId = self.caseId;
    
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[[self callerViewController] navigationController] pushViewController:cController animated:YES];
    
    
}

@end
