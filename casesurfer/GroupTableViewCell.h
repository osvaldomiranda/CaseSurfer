//
//  GroupTableViewCell.h
//  casesurfer
//
//  Created by Osvaldo on 11-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface GroupTableViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id callerViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblGroupName;
@property (weak, nonatomic) IBOutlet UILabel *lblGroupMembers;
@property (nonatomic, retain) NSMutableArray *users;

- (IBAction)GroupMembersAction:(id)sender;


@end
