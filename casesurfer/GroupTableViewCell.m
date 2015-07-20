//
//  GroupTableViewCell.m
//  casesurfer
//
//  Created by Osvaldo on 11-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "GroupTableViewCell.h"
#import "GroupMembersViewController.h"

@implementation GroupTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)GroupMembersAction:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    GroupMembersViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"GroupMembers"];
    cController.members = self.users;
    cController.groupName = self.lblGroupName.text;
    
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[[self callerViewController] navigationController] pushViewController:cController animated:YES];
    
    
}

@end
