//
//  ListCaseTableViewCell.m
//  casesurfer
//
//  Created by Osvaldo on 01-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "ListCaseTableViewCell.h"
#import "CaseViewController.h"

@implementation ListCaseTableViewCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (IBAction)caseAction:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    CaseViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"Case"];
    
    [cController.navigationController setNavigationBarHidden:NO];
    cController.hidesBottomBarWhenPushed = YES;
    cController.caseId = self.caseId;
    [[[self callerViewController] navigationController] pushViewController:cController animated:YES];
    
    
}

@end
