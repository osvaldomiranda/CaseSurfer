//
//  CaseViewController.h
//  casesurfer
//
//  Created by Osvaldo on 17-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalGrid.h"

@interface CaseViewController : UIViewController
@property (weak, nonatomic) IBOutlet UITextView *txtTitle;
@property (weak, nonatomic) IBOutlet UITextView *txtDescription;
@property (weak, nonatomic) IBOutlet UILabel *lblData;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, assign) int caseId;
@property (nonatomic, assign) int ownerUser;
@property (nonatomic, strong) NSArray *images;
@property (nonatomic, strong) NSMutableArray *comments;
@property (strong, nonatomic) UIActivityViewController *activityViewController;
@property (weak, nonatomic) IBOutlet UIView *firstView;


@property (weak, nonatomic) IBOutlet UITableView *tblComments;
@property (weak, nonatomic) IBOutlet UIButton *shareButton;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollPrueba;

- (IBAction)comment:(id)sender;
- (IBAction)share:(id)sender;


@end
