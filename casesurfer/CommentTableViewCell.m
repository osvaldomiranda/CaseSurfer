//
//  CommentTableViewCell.m
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CommentTableViewCell.h"
#import "UserViewController.h"


@implementation CommentTableViewCell
@synthesize callerViewController;

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}



- (IBAction)tapUser:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    UserViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"User"];
    
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    [[[self callerViewController] navigationController] pushViewController:cController animated:YES];
}
@end
