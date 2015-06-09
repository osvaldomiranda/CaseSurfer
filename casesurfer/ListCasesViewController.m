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

@interface ListCasesViewController ()

@end

@implementation ListCasesViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    itemsArray = [[NSMutableArray alloc] init];
    Album *album = [[Album alloc] init];
    
    [album  find:self.albumId Success:^(NSMutableDictionary *items) {
       
        [self.albumName setTitle:[items valueForKeyPath:@"name"]];
        
        NSArray *medCases = [items valueForKeyPath:@"medcases"];
        [self fillImtensArray:medCases];
    } Error:^(NSError *error) {
        
    }];
    
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
    int numRows = itemsArray.count;
    return numRows;
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

#pragma END Table View

-(NSURL *) urlFirsImage:(NSArray *) images{
    NSDictionary *thumb;
    for(NSDictionary *image in images){
        NSDictionary *img = [image valueForKeyPath:@"image"];
        thumb = [img valueForKeyPath:@"thumb"];
        break;
    }
    NSString *caseImageUrl = [NSString stringWithFormat:@"%@%@",BASE_PATH, [thumb valueForKeyPath:@"url"]];
    NSURL *urlCaseImage = [NSURL URLWithString:[caseImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    return urlCaseImage;
}

- (IBAction)back:(id)sender {
    [self.navigationController popViewControllerAnimated:YES];
}

@end
