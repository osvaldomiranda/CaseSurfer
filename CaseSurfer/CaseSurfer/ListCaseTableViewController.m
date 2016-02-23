//
//  ListCaseTableViewController.m
//  casesurfer
//
//  Created by Osvaldo on 09-10-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "ListCaseTableViewController.h"
#import "ListCaseTableViewCell.h"
#import "Album.h"
#import "Definitions.h"
#import "UIImageView+WebCache.h"
#import "MedCase.h"
#import "NewAlbumViewController.h"
#import "SearchCase.h"
#import "Session.h"

@interface ListCaseTableViewController ()

@end

@implementation ListCaseTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    
    self.clearsSelectionOnViewWillAppear = YES;
    self.tableView.separatorColor = [UIColor clearColor];
    self.tableView.allowsMultipleSelectionDuringEditing = NO;
    
    itemsArray = [[NSMutableArray alloc] init];
    self.filteredUserArray  = [[NSMutableArray alloc] init];
    self.usersArray  = [[NSMutableArray alloc] init];

    
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
        if (self.albumId == 9999) {
            MedCase *mCase = [[MedCase alloc] init];
            [mCase index:params Success:^(NSArray *items) {
                NSArray *medCases = items;
               [self fillImtensArray:medCases];
            } Error:^(NSError *error) {
                
            }];
        }
        else{
            [album  find:self.albumId Success:^(NSMutableDictionary *items) {
                self.lblTitle.text = [items valueForKeyPath:@"name"];
                NSArray *medCases = [items valueForKeyPath:@"medcases"];
                [self fillImtensArray:medCases];
            } Error:^(NSError *error) {
            }];
        }
    }
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:NO];
    self.hidesBottomBarWhenPushed = YES;
}


-(void) fillImtensArray:(NSArray *) items{
    
    [itemsArray removeAllObjects];
    for (NSMutableDictionary *item in items) {
        [itemsArray addObject:item];
        
        NSString *title = [item valueForKeyPath:@"title"];
        NSString *idCase = [item valueForKeyPath:@"id"];

        
        SearchCase *sCase = [[SearchCase alloc] initWithTitle:title andId:idCase andInfo:item];
        [self.filteredUserArray addObject:sCase];
        [self.usersArray addObject:sCase];
     
    }
    [self.tableView reloadData];
   
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    return 112;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        return self.filteredUserArray.count;
    }
    else {
        return itemsArray.count;
    }
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {

    static NSString *CellIdentifier = @"ListCaseCell";
    ListCaseTableViewCell *cell = (ListCaseTableViewCell *)[self.tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[ListCaseTableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    
//    [cell.contentView clearsContextBeforeDrawing];
    [cell setCallerViewController:self];
    

    
    if (tableView == self.searchDisplayController.searchResultsTableView) {
        SearchCase *sCase = [self.filteredUserArray objectAtIndex:indexPath.row];
        
        NSDictionary *infoCase = sCase.info;
        
        NSString *patient = [infoCase valueForKeyPath:@"patient"];
        NSString *gender = [infoCase valueForKeyPath:@"patient_gender"];
        NSString *age = [infoCase valueForKeyPath:@"patient_age"];
        
        NSArray *images = [infoCase valueForKeyPath:@"images"];
        NSURL *urlCaseImage = [self urlFirsImage:images];
        
         ;
        
        Session *session= [[Session alloc] init];
        int myId =  [session.getUserId intValue];
        
       // NSLog(@"%@", infoCase);
        
        if (myId != [[infoCase valueForKeyPath:@"user_id"] intValue]) {
            patient = [self anonimize: [infoCase valueForKeyPath:@"patient"]];
        }
        
        
        cell.caseId = [[infoCase valueForKeyPath:@"id"] intValue];
        cell.lblTitle.text = [infoCase valueForKeyPath:@"title"];
        cell.lblData.text = [NSString stringWithFormat:@"%@, %@, %@ years old", patient, gender, age ];
        [cell.caseImage setImageWithURL:urlCaseImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
       
        
    } else {
    
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
    }
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



#pragma mark Content Filtering
-(void)filterContentForSearchText:(NSString*)searchText scope:(NSString*)scope {
    [self.filteredUserArray removeAllObjects];
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"SELF.title contains[c] %@",searchText];
    self.filteredUserArray = [NSMutableArray arrayWithArray:[self.usersArray filteredArrayUsingPredicate:predicate]];
    
   // NSLog(@"Users Array %@", self.filteredUserArray);
}

#pragma mark - UISearchDisplayController Delegate Methods
-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchString:(NSString *)searchString {
    [self filterContentForSearchText:searchString scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:[self.searchDisplayController.searchBar selectedScopeButtonIndex]]];
    return YES;
}

-(BOOL)searchDisplayController:(UISearchDisplayController *)controller shouldReloadTableForSearchScope:(NSInteger)searchOption {
    [self filterContentForSearchText:self.searchDisplayController.searchBar.text scope:
     [[self.searchDisplayController.searchBar scopeButtonTitles] objectAtIndex:searchOption]];
    return YES;
}





- (IBAction)editCase:(id)sender {
    
    if (self.albumId != 0) {
        if (self.tableView.isEditing) {
            [self.tableView setEditing: NO animated: YES];
        } else{
            [self.tableView setEditing: YES animated: YES];
        }
    }
}

- (void) endEdit{
    if (self.tableView.isEditing) {
        [self.tableView setEditing: NO animated: YES];
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

- (NSString *)anonimize:(NSString *) fullname {
    
    NSMutableString * firstCharacters = [NSMutableString string];
    NSArray * words = [fullname componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceCharacterSet]];
    for (NSString * word in words) {
        if ([word length] > 0) {
            NSString * firstLetter = [word substringToIndex:1];
            [firstCharacters appendString:[firstLetter uppercaseString]];
        }
    }
    
    return firstCharacters;
}



@end
