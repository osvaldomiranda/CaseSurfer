//
//  CommentViewController.h
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CommentViewController : UIViewController {
    NSMutableArray *comments;
}

@property (nonatomic, assign) int caseId;
@property (weak, nonatomic) IBOutlet UITableView *tblComments;

- (IBAction)send:(id)sender;

@end
