//
//  FeedCaseTableViewCell.h
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedCaseTableViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id callerViewController;
@property (weak, nonatomic) IBOutlet UIImageView *userAvatar;
@property (weak, nonatomic) IBOutlet UILabel *userName;
@property (weak, nonatomic) IBOutlet UILabel *caseName;
@property (weak, nonatomic) IBOutlet UIImageView *caseImage;
@property (assign, nonatomic) int caseId;


- (IBAction)userAction:(id)sender;
- (IBAction)caseAction:(id)sender;

@end
