//
//  FeedTableViewCell.m
//  casesurfer
//
//  Created by Osvaldo on 10-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "FeedTableViewCell.h"
#import "UserViewController.h"
#import "CaseViewController.h"

@implementation FeedTableViewCell
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
    
     if (self.caseId != 0) {
         UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         UserViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"User"];
         cController.userId = self.userId;
         cController.hidesBottomBarWhenPushed = YES;
         [[[self callerViewController] navigationController] pushViewController:cController animated:YES];
     }
    

}

- (IBAction)caseAction:(id)sender {
     if (self.caseId != 0) {
         UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
         CaseViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Case"];
         cController.caseId = self.caseId;
         [cController.navigationController setNavigationBarHidden:NO];
         cController.hidesBottomBarWhenPushed = YES;
         [[[self callerViewController] navigationController] pushViewController:cController animated:YES];
     }

}
@end
