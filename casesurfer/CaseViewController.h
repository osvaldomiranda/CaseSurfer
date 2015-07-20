//
//  CaseViewController.h
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalGrid.h"

@interface CaseViewController : UIViewController <horizontalGridDelegate>
@property (weak, nonatomic) IBOutlet UITextView *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;

@property (weak, nonatomic) IBOutlet UILabel *lblData;

@property (nonatomic, retain) HorizontalGrid *scrollView;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, assign) int caseId;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSArray *comments;
@property (weak, nonatomic) IBOutlet UITableView *tblComments;

- (IBAction)comment:(id)sender;
- (IBAction)back:(id)sender;

@end
