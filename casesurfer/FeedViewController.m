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
#import "Utilities.h"

@interface FeedViewController ()

@end

@implementation FeedViewController
@synthesize feedTableView;

- (void)viewDidLoad {
    [super viewDidLoad];
    self.refreshLoadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 400, 60)];
    self.refreshLoadingView.hidden = YES;
    self.pullRefreshVisible = NO;
    [self.view addSubview:self.refreshLoadingView];
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
    [self.navigationController setNavigationBarHidden:NO];
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
        
        NSDictionary *notificable = [celda valueForKey:@"notificable"];
        if([notificableTipe isEqualToString:@"Medcase"]){
            height = 290;
        }
        if([notificableTipe isEqualToString:@"Share"]){
            height = 210;
        }
        if ([notificableTipe isEqualToString:@"Comment"])
        {
            height = [self textH:[notificable valueForKeyPath:@"message"]] + 50;
        }
    }
    return height;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
   return itemsArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSDictionary *celda = [itemsArray objectAtIndex:indexPath.row];
    NSString *notificableType = [celda valueForKeyPath:@"notificable_type"];
    NSString *userName = [celda valueForKeyPath:@"user_name"];
    NSString *caseName = [celda valueForKeyPath:@"title"];
    NSString *caseId = [celda valueForKeyPath:@"medcaseid"];
    NSString *timeAgo = [celda valueForKeyPath:@"time_ago"];
    NSString *notificable_id= [celda valueForKeyPath:@"notificable_id"];
    NSString *notification_id= [celda valueForKeyPath:@"id"];
    int userId = [[celda valueForKey:@"actor_user_id"] intValue];
    
    NSString *userAvatarUrl = [NSString stringWithFormat:@"%@%@",DEV_BASE_PATH, [celda valueForKeyPath:@"user_avatar"]];
    NSURL *urlUserImage = [NSURL URLWithString:[userAvatarUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
   

    NSString *caseImageUrl = [NSString stringWithFormat:@"%@%@",DEV_BASE_PATH, [celda valueForKeyPath:@"medcase_image"]];
    if ([notificableType isEqualToString:@"Share"]) {
        caseImageUrl = [NSString stringWithFormat:@"%@%@",DEV_BASE_PATH, [celda valueForKeyPath:@"share_image"]];
    }
    
    NSURL *urlCaseImage = [NSURL URLWithString:[caseImageUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    NSDictionary *notificable =  [celda valueForKeyPath:@"notificable"];
    
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
            cell.lblWantToShare.text = @"Shared";
        } else{
            cell.btnAcept.hidden = FALSE;
            cell.btnIgnore.hidden = FALSE;
            cell.lblWantToShare.text = @"Wants to Share";
        }
    }
    
    if([notificableType isEqualToString:@"Comment"]){
        
        Utilities *util = [[Utilities alloc] init];
        
        cell.txtMessage.text = [notificable valueForKeyPath:@"message"];
        cell.txtMessage.frame = CGRectMake(11, 50, [util screenWidth] -20, [self textH:[notificable valueForKeyPath:@"message"]] -25 );
    
        for ( UIView *view in cell.subviews ) {
            if (view.tag == 1) {
                [view removeFromSuperview];
            }
        }
        UIView *sep = [util addSeparator:[self textH:[notificable valueForKeyPath:@"message"]]+40];
        [cell addSubview:sep];
    }
    
    [cell.contentView clearsContextBeforeDrawing];
    [cell setCallerViewController:self];
    [cell.userName setText:userName];
    [cell.caseName setText:caseName];
    cell.caseId = [caseId intValue];
    cell.lblTimeAgo.text = timeAgo;
    cell.userId = userId;
    cell.notificableId = notificable_id;
    cell.notificationId = notification_id;
    
    [cell.caseImage setImageWithURL:urlCaseImage placeholderImage: [UIImage imageNamed:@"logo.png"]];
    [cell.userAvatar setImageWithURL:urlUserImage placeholderImage: [UIImage imageNamed:@"logo.png"]];
    
    return cell;
}

- (int) textH: (NSString *) text
{
    Utilities *util = [[Utilities alloc] init];
    float height = [util labelHeightWith:text width:300 font:[UIFont systemFontOfSize:14.0]];
    return 12+17+3+height+5;
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
