//
//  CreateCaseTableViewController.h
//  casesurfer
//
//  Created by Osvaldo on 27-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CreateCaseTableViewController : UITableViewController<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *txtTitle;
@property (weak, nonatomic) IBOutlet UITextField *txtDescription;
@property (weak, nonatomic) IBOutlet UITextField *txtPatient;
@property (nonatomic, assign) NSMutableArray *photos;
@property (weak, nonatomic) NSString *selectedGender;
@property (weak, nonatomic) NSString *selectedAlbum;
@property (weak, nonatomic) NSString *selectedAge;
@property (weak, nonatomic) IBOutlet UILabel *lblGender;
@property (weak, nonatomic) IBOutlet UILabel *lblAlbum;
@property (weak, nonatomic) IBOutlet UILabel *lblAge;
@property (nonatomic, retain) NSMutableArray *albums;

- (IBAction)addAlbum:(id)sender;
- (IBAction)tapGender:(id)sender;
- (IBAction)tapAlbum:(id)sender;
- (IBAction)tapAge:(id)sender;
- (IBAction)createCase:(id)sender;

@end
