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
@property (weak, nonatomic) IBOutlet UILabel *lblTitle;
@property (weak, nonatomic) IBOutlet UILabel *lblData;
@property (weak, nonatomic) IBOutlet UILabel *lblDescription;
@property (nonatomic, retain) HorizontalGrid *scrollView;
@property (nonatomic, retain) UIImage *selectedImage;
@property (nonatomic, assign) int caseId;

- (IBAction)comment:(id)sender;
- (IBAction)back:(id)sender;

@end
