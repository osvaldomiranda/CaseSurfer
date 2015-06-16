//
//  ShareTableViewCell.m
//  casesurfer
//
//  Created by Osvaldo on 15-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "ShareTableViewCell.h"
#import "UserViewController.h"
#import "CaseViewController.h"

@implementation ShareTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];


}

-(void)layoutSubviews
{
    [self.userAvatar.layer setMasksToBounds:YES];
    [self.userAvatar.layer setCornerRadius:17.5f];
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

- (IBAction)aceptAction:(id)sender{

}
- (IBAction)ignoreAction:(id)sender{
    
}

@end
