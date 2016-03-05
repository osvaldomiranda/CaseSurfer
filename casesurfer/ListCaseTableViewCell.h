//
//  ListCaseTableViewCell.h
//  casesurfer
//
//  Created by Osvaldo on 01-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ListCaseTableViewCell : UITableViewCell

@property (nonatomic, unsafe_unretained) id callerViewController;
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblData;
@property (weak, nonatomic) IBOutlet UIImageView *caseImage;
@property (assign, nonatomic) int caseId;

- (IBAction)caseAction:(id)sender;
@end
