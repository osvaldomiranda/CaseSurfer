//
//  FeedViewController.m
//  casesurfer
//
//  Created by Osvaldo on 07-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "FeedViewController.h"
#import "FeedTableViewCell.h"
#import "FeedCaseTableViewCell.h"
#import "ShareTableViewCell.h"
#import "Notification.h"
#import "Definitions.h"

@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize feedTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshLoadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 64, 400, 60)];
    self.refreshLoadingView.hidden = YES;
    self.pullRefreshVisible = NO;
    [self.view addSubview:self.refreshLoadingView];
    [self.navigationController setNavigationBarHidden:TRUE];
    feedTableView.separatorColor = [UIColor clearColor];
    itemsArray = [[NSMutableArray alloc] init];
    [self refrechData];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:TRUE];
}



-(void) refrechData{
    NSMutableDictionary *notificationParams =  @{}.mutableCopy;
    Notification *notification = [[Notification alloc] initWithParams:notificationParams];

    [notification index:notificationParams Success:^(NSArray *items) {
        [self fillImtensArray:items];
        if (self.pullRefreshVisible) {
            [self loadingViewVisible:NO];
        }
    } Error:^(NSError *error) {
    }];
}

-(void) fillImtensArray:(NSArray *) items{
    
    NSLog(@"FEED %@",items);
    
    [itemsArray removeAllObjects];
    for (NSMutableDictionary *item in items) {
        [itemsArray addObject:item];
    }
    [feedTableView reloadData];
}

- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    int height = 90;
    if (itemsArray.count > 0) {
        NSDictionary *celda = [itemsArray objectAtIndex:indexPath.row];
        NSString *notificableTipe = [celda valueForKeyPath:@"notificable_type"];
        if([notificableTipe isEqualToString:@"Medcase"]){
            height = 290;
        }
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   int numRows = itemsArray.count;
    return numRows;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *celda = [itemsArray objectAtIndex:indexPath.row];
    NSString *notificableType = [celda valueForKeyPath:@"notificable_type"];
    NSString *userName = [celda valueForKeyPath:@"user_name"];
    NSString *caseName = [celda valueForKeyPath:@"title"];
   
    
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@%@",BASE_PATH, [celda valueForKeyPath:@"user_avatar"]];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    
    NSString *caseImageUrl = [NSString stringWithFormat:@"%@%@",BASE_PATH, [celda valueForKeyPath:@"medcase_image"]];
    NSURL *urlCaseImage = [NSURL URLWithString:[caseImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *notificable =  [celda valueForKeyPath:@"notificable"];
    
    NSString *caseId = [notificable valueForKeyPath:@"id"];
    
    FeedTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"FeedTableViewCell"];
    
    if([notificableType isEqualToString:@"Medcase"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCaseCell"];
    }
    
    if([notificableType isEqualToString:@"Share"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"ShareTableViewCell"];
        cell.status =  [notificable valueForKeyPath:@"status"];
        
        if([cell.status isEqualToString:@"approved"]){
            cell.btnAcept.hidden = TRUE;
            cell.btnIgnore.hidden = TRUE;
        } else{
            cell.btnAcept.hidden = FALSE;
            cell.btnIgnore.hidden = FALSE;
        }
    }
    
    if([notificableType isEqualToString:@"Comment"]){
        cell.lblMessage.text = [notificable valueForKeyPath:@"message"];
    }
    
    [cell.contentView clearsContextBeforeDrawing];
    [cell setCallerViewController:self];
    [cell.userName setText:userName];
    [cell.caseName setText:caseName];
    cell.caseId = [caseId intValue];
    
    [cell.caseImage setImageWithURL:urlCaseImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
    [cell.userAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"normal_default.png"]];
    
    return cell;
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if (scrollView.contentOffset.y < -20){
        if (!self.pullRefreshVisible){
            [self loadingViewVisible:YES];
        }
    }
}


-(void) loadingViewVisible:(BOOL) visible{
    BOOL hidden; int viewMove;
    if (visible) {
        hidden = NO; viewMove = 60;
        self.pullRefreshVisible =TRUE;
    } else {
        hidden = YES; viewMove = -60;
        self.pullRefreshVisible =FALSE;
    }
    [self.refreshLoadingView startLoadingIndicator];
    [UIView transitionWithView:self.feedTableView
                      duration:0.3
                       options:UIViewAnimationOptionCurveEaseIn
                    animations:^{
                        CGRect new_frame = self.feedTableView.frame;
                        new_frame.origin.y += viewMove;
                        self.feedTableView.frame = new_frame;
                    }
                    completion:nil];
    self.refreshLoadingView.hidden = hidden;
    [self refrechData];
}




@end
