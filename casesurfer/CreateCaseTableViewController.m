//
//  CreateCaseTableViewController.m
//  casesurfer
//
//  Created by Osvaldo on 27-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CreateCaseTableViewController.h"
#import "NewAlbumViewController.h"
#import "MedCase.h"
#import "NSString+Validation.h"
#import "CBCPicker.h"
#import "Definitions.h"
#import "Album.h"
#import "UIAlertView+Block.h"


@interface CreateCaseTableViewController ()

@end

@implementation CreateCaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.albums = [[NSMutableArray alloc] init];
    [self loadAlbums];
}

-(void) loadAlbums{
    Album *myAlbum = [[Album alloc] init];
    NSMutableDictionary *params =  @{}.mutableCopy;
    [myAlbum index:params Success:^(NSArray *items) {
        [self fillAlbumArray: items];
    } Error:^(NSError *error) {
    }];
}

-(void) fillAlbumArray:(NSArray *) items{
    for (id album in items  ) {
        NSString *titleAlbum = [album valueForKeyPath:@"name"];
        [self.albums addObject:titleAlbum];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:FALSE];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self hideAll];
}

- (void) hideAll {
    [self hideKeyboard];
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 9;
}

- (IBAction)addAlbum:(id)sender {

    
}

- (IBAction)createCase:(id)sender {
    if (![self.txtTitle.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Title."];
    } else if (![self.txtPatient.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Pratient."];
    } else if (![self.txtDescription.text isValidText]) {
        [UIAlertView alertViewOopsWithmessage:@"You must place a valid Description."];
    } else if(self.selectedAlbum == nil){
        [UIAlertView alertViewOopsWithmessage:@"You must select an Album."];
    } else if(self.selectedGender == nil){
        [UIAlertView alertViewOopsWithmessage:@"You must select an Gender."];
    } else if(self.selectedAge == nil){
        [UIAlertView alertViewOopsWithmessage:@"You must select an Age."];
    } else {
        MedCase *medCase = [[MedCase alloc] init];
        medCase.title = self.txtTitle.text;
        medCase.album_id = @"2";
        medCase.patient = self.txtPatient.text;
        medCase.patient_age = self.selectedAge;
        medCase.patient_gender = self.selectedGender;
        medCase.descript = self.txtDescription.text;
        medCase.stars = @"0";
        medCase.images = self.photos;
        [medCase create];
        
        [self.navigationController setNavigationBarHidden:TRUE];
        [[NSNotificationCenter defaultCenter] postNotificationName:loginObserver
                                                            object:nil];
        
    }
}

- (void) hideKeyboard {
    [self.txtTitle resignFirstResponder];
    [self.txtPatient resignFirstResponder];
    [self.txtDescription resignFirstResponder];
}

- (void)defineTextFieldDelegates{
    self.txtTitle.delegate = self;
    self.txtPatient.delegate = self;
    self.txtDescription.delegate = self;

}

- (IBAction)tapGender:(id)sender {
    [self hideKeyboard];
    [self performSelector:@selector(scrollTableView) withObject:nil afterDelay:1.0];
    NSArray * genderData = @[@"Male", @"Female"];
    [CBCPicker showPickerWithData: genderData
                     selectedItem:self.selectedGender
                         onCanvas:self.parentViewController.view
                         onSelect:^(NSString *selectedItem) {
                             self.selectedGender = selectedItem;
                             self.lblGender.text = selectedItem;
                             self.lblGender.textColor = [UIColor blackColor];
                         }
                           onNext:^{
                               [self.txtDescription becomeFirstResponder];
                           }];
}

- (IBAction)tapAlbum:(id)sender{
    [self hideKeyboard];
    [self performSelector:@selector(scrollTableView) withObject:nil afterDelay:1.0];
    [CBCPicker showPickerWithData: self.albums
                     selectedItem:self.selectedAlbum
                         onCanvas:self.parentViewController.view
                         onSelect:^(NSString *selectedItem) {
                             self.selectedAlbum = selectedItem;
                             self.lblAlbum.text = selectedItem;
                             self.lblAlbum.textColor = [UIColor blackColor];
                         }
                           onNext:^{
                               [self.txtTitle becomeFirstResponder];
                           }];
}


- (IBAction)tapAge:(id)sender{
    [self hideKeyboard];
    [self performSelector:@selector(scrollTableView) withObject:nil afterDelay:1.0];
    [CBCPicker showPickerWithData: AGES
                     selectedItem:self.selectedAlbum
                         onCanvas:self.parentViewController.view
                         onSelect:^(NSString *selectedItem) {
                             self.selectedAge = selectedItem;
                             self.lblAge.text = selectedItem;
                             self.lblAge.textColor = [UIColor blackColor];
                         }
                           onNext:^{
                               [self.txtTitle becomeFirstResponder];
                           }];
}

- (void)scrollTableView{
    [self.tableView scrollToRowAtIndexPath:[NSIndexPath indexPathForRow:4 inSection:0]
                          atScrollPosition:UITableViewScrollPositionMiddle animated:YES];
}

@end
