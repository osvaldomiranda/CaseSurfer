//
//  CommentTableViewCell.h
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentTableViewCell : UITableViewCell
@property (nonatomic, unsafe_unretained) id callerViewController;

@property (weak, nonatomic) IBOutlet UILabel *lblMessage;
@property (weak, nonatomic) IBOutlet UIButton *btnUserName;
@property (weak, nonatomic) IBOutlet UIImageView *imgUserAvatar;
@property (weak, nonatomic) IBOutlet UILabel *lblTimeAgo;

- (IBAction)tapUser:(id)sender;

@end
