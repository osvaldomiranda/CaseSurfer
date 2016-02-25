//
//  UpdateCaseTableView.h
//  casesurfer
//
//  Created by Osvaldo on 11-09-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HorizontalGrid.h"
#import "rollUpdateViewController.h"



@interface UpdateCaseTableView : UITableViewController <horizontalGridDelegate, rollUpdateDelegate>

@property (nonatomic, retain) HorizontalGrid *scrollView;


@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtPatient;
@property (nonatomic, assign) NSMutableArray *photos;
@property (weak, nonatomic) NSString *selectedGender;
@property (weak, nonatomic) NSString *selectedAlbum;
@property (weak, nonatomic) NSString *selectedAge;
@property (weak, nonatomic) NSString *caseId;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblAlbum;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (nonatomic, retain) NSMutableArray *albums;
@property (nonatomic, retain) NSMutableArray *albumIds;
@property (nonatomic, retain) NSMutableDictionary *medCase;
@property (nonatomic, assign) int newImageCount;

@property (nonatomic, retain) NSMutableArray *delImages;
@property (nonatomic, retain) NSMutableArray *originalImages;
@property (nonatomic, retain) NSMutableArray *uploadNewImages;
@property (nonatomic, retain) NSMutableArray *photosUpload;

@property (weak, nonatomic) IBOutlet UIView *viewImages;

- (IBAction)tapGender:(id)sender;
- (IBAction)tapAlbum:(id)sender;
- (IBAction)tapAge:(id)sender;
- (IBAction)updateCase:(id)sender;
- (IBAction)createAlbum:(id)sender;
- (IBAction)addImage:(id)sender;
@end
