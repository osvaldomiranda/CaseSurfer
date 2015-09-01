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
#import "Share.h"
#import "Notification.h"

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
    cController.userId = self.userId;
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
    NSDictionary *shareData = @{@"medcase_id":[NSString stringWithFormat:@"%d", self.caseId] ,
                                @"status": @"approved"
                                  };
    NSMutableDictionary *shareParams =  @{@"share" : shareData}.mutableCopy;
    Share *share = [[Share alloc] initWithParams:shareParams];
    [share update:[self.notificableId intValue] params:shareParams Success:^(NSMutableDictionary *items) {
    } Error:^(NSError *error) {
    }];
}


- (IBAction)ignoreAction:(id)sender{
    NSMutableDictionary *notificationParams =  @{}.mutableCopy;
    Notification *notification = [[Notification alloc] initWithParams:notificationParams];
    [notification delete:[self.notificationId intValue] params:notificationParams Success:^(NSMutableDictionary *items) {
    } Error:^(NSError *error) {
    }];
}

@end
