//
//  ParticipantsTableViewController.h
//  casesurfer
//
//  Created by Osvaldo Miranda on 16/12/15.
//  Copyright © 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ParticipantsTableViewController : UITableViewController{
    NSMutableArray *participants;
}

@property (strong, nonatomic) IBOutlet UITableView *tblParticipants;
@property (nonatomic, assign) int caseId;

@end
