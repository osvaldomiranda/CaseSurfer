//
//  ListCasesViewController.m
//  casesurfer
//
//  Created by Osvaldo on 01-06-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "ListCasesViewController.h"
#import "ListCaseTableViewCell.h"
#import "Album.h"
#import "Definitions.h"
#import "UIImageView+WebCache.h"
#import "MedCase.h"
#import "NewAlbumViewController.h"

@interface ListCasesViewController ()

@end

@implementation ListCasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    itemsArray = [[NSMutableArray alloc] init];
    [self refrechData];
}

-(void) refrechData{
    NSMutableDictionary *params = @{}.mutableCopy;
    Album *album = [[Album alloc] init];
    if (self.albumId  == 0) {
        [album album_shared:params Success:^(NSArray *items) {
            self.lblTitle.text = @"Shared with me";
            NSArray *medCases = [items[0] valueForKeyPath:@"medcases"];
           [self fillImtensArray:medCases];
        } Error:^(NSError *error) {
        }];
    } else {
        [album  find:self.albumId Success:^(NSMutableDictionary *items) {
            self.lblTitle.text = [items valueForKeyPath:@"name"];
            NSArray *medCases = [items valueForKeyPath:@"medcases"];
            [self fillImtensArray:medCases];
        } Error:^(NSError *error) {
        }];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:TRUE];
     self.hidesBottomBarWhenPushed = YES;
}



-(void) fillImtensArray:(NSArray *) items{
    [itemsArray removeAllObjects];
    for (NSMutableDictionary *item in items) {
        [itemsArray addObject:item];
    }
    [self.listCaseTableView reloadData];
}


#pragma Table View
- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 112;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return itemsArray.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    ListCaseTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ListCaseCell"];
    [cell.contentView clearsContextBeforeDrawing];
    
    [cell.contentView clearsContextBeforeDrawing];
    [cell setCallerViewController:self];
    
    NSDictionary *celda = [itemsArray objectAtIndex:indexPath.row];
    
    NSString *patient = [celda valueForKeyPath:@"patient"];
    NSString *gender = [celda valueForKeyPath:@"patient_gender"];
    NSString *age = [celda valueForKeyPath:@"patient_age"];
    
    NSArray *images = [celda valueForKeyPath:@"images"];
    NSURL *urlCaseImage = [self urlFirsImage:images];
    
    cell.caseId = [[celda valueForKeyPath:@"id"] intValue];
    cell.lblTitle.text = [celda valueForKeyPath:@"title"];
    cell.lblData.text = [NSString stringWithFormat:@"%@, %@, %@ years old", patient, gender, age ];
    [cell.caseImage setImageWithURL:urlCaseImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
    
    return cell;
}

- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *celda = [itemsArray objectAtIndex:indexPath.row];
    int caseId = [[celda valueForKeyPath:@"id"] intValue];;
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        [self deleteCase:caseId];
    }
}




#pragma END Table View

- (IBAction)editCase:(id)sender {
    
    if (self.albumId != 0) {
        if (self.listCaseTableView.isEditing) {
            [self.listCaseTableView setEditing: NO animated: YES];
        } else{
            [self.listCaseTableView setEditing: YES animated: YES];
        }
    }
}

- (void) endEdit{
    if (self.listCaseTableView.isEditing) {
        [self.listCaseTableView setEditing: NO animated: YES];
    }
}

-(void) deleteCase:(int) idCase{
    NSMutableDictionary *caseParams =  @{}.mutableCopy;
    MedCase *medcase = [[MedCase alloc] initWithParams:caseParams];
    [medcase delete:idCase params:caseParams Success:^(NSMutableDictionary *items) {
        [self refrechData];
    } Error:^(NSError *error) {
    }];
}

-(NSURL *) urlFirsImage:(NSArray *) images{
    NSDictionary *thumb;
    for(NSDictionary *image in images){
        NSDictionary *img = [image valueForKeyPath:@"image"];
        thumb = [img valueForKeyPath:@"thumb"];
        break;
    }
    NSString *caseImageUrl = [NSString stringWithFormat:@"%@%@", DEV_BASE_PATH, [thumb valueForKeyPath:@"url"]];
    NSURL *urlCaseImage = [NSURL URLWithString:[caseImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return urlCaseImage;
}

- (IBAction)editAlbum:(id)sender {
    if (self.albumId != nil) {
        UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
        NewAlbumViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"NewAlbum"];
        
        cController.albumId = self.albumId;
        self.hidesBottomBarWhenPushed =  YES;
        [self.navigationController pushViewController:cController animated:YES];
        self.hidesBottomBarWhenPushed =  NO;
    }
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
