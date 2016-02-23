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
@synthesize readNextPage;

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadingStart)
                                                 name:upLoadingObserver
                                               object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self
                                             selector:@selector(uploadingEnd)
                                                 name:EndUpLoadingObserver
                                               object:nil];
    

    
    self.refreshLoadingView = [[LoadingView alloc] initWithFrame:CGRectMake(0, 0, 400, 60)];
    self.refreshLoadingView.hidden = YES;
    self.pullRefreshVisible = NO;
    [self.view addSubview:self.refreshLoadingView];
    
    
    self.upLoadingView = [[UploadingView alloc] initWithFrame:CGRectMake(0, 0, 400, 60)];
    self.upLoadingView.hidden = YES;
    self.uploadingVisible = NO;
    [self.view addSubview:self.upLoadingView];
    
    feedTableView.separatorColor = [UIColor clearColor];
    itemsArray = [[NSMutableArray alloc] init];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    
    self.page = 1;
    readNextPage = false;
    
    [self refrechData];
    
}


-(void) refrechData{
    
  
    NSNumber *p= [[NSNumber alloc] initWithInt:self.page];
    NSMutableDictionary *notificationParams =  @{@"page": p}.mutableCopy;
    Notification *notification = [[Notification alloc] initWithParams:notificationParams];
    
    [notification index:notificationParams Success:^(NSArray *items) {
        [self saveNotificationsCache:items];
        [self fillImtensArray:items];
        
        if (itemsArray.count==0) {
            [self initialFeed];
        }
        
        if (self.pullRefreshVisible) {
            [self loadingViewVisible:NO];
        }
    } Error:^(NSError *error) {
    }];
    
    
    [self showUploadingView];
}

- (void) showUploadingView{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSString *uploading = [defaults objectForKey:@"uploading"];
    if ([uploading isEqualToString:@"YES"]) {
        [self upLoadingViewVisible:YES];
    } else {
        [self upLoadingViewVisible:NO];
    }
}
-(void) fillImtensArray:(NSArray *) items{
    //[itemsArray removeAllObjects];
    
    //******** del notifications deleted
    bool exist = false;
  /*  int i = 0;
    for (NSMutableDictionary *item in itemsArray) {
        exist = false;
        for (NSMutableDictionary *iarray in itemsArray) {
            if ([item valueForKeyPath:@"id"] == [iarray valueForKeyPath:@"id"] ) {
                exist = true;
            }
        }
        if (!exist) {
            [itemsArray removeObjectAtIndex:i];
        }
        i++;
    }
    */
    
    //******** add new notifications
    exist = false;
    for (NSMutableDictionary *item in items) {
        exist = false;
        for (NSMutableDictionary *iarray in itemsArray) {
            if ([item valueForKeyPath:@"id"] == [iarray valueForKeyPath:@"id"] ) {
                exist = true;
            }
        }
        if (!exist) {
             [itemsArray addObject:item];
        }
    }
    
    [self orderArray:itemsArray];
    
    NSArray *newArray = [[NSOrderedSet orderedSetWithArray:itemsArray] array];
    [itemsArray removeAllObjects];
    itemsArray = newArray.mutableCopy;
    
    [feedTableView reloadData];
}



- (void) orderArray:(NSMutableArray *) arr{
    NSSortDescriptor *hopProfileDescriptor = [[NSSortDescriptor alloc] initWithKey:@"id" ascending:NO];
    
    NSArray *descriptors = [NSArray arrayWithObjects:hopProfileDescriptor, nil];
    NSArray *sortedArrayOfDictionaries = [arr sortedArrayUsingDescriptors:descriptors];
    
    [itemsArray removeAllObjects];
    for (NSMutableDictionary *item in sortedArrayOfDictionaries) {
        [itemsArray addObject:item];
    }

}


- (CGFloat) tableView:(UITableView *)tableView heightForRowAtIndexPath: (NSIndexPath *) indexPath {
    int height = 250;
    if (itemsArray.count > 0) {
        NSDictionary *celda = [itemsArray objectAtIndex:indexPath.row];
        NSString *notificableTipe = [celda valueForKeyPath:@"notificable_type"];
        
        NSDictionary *notificable = [celda valueForKey:@"notificable"];
        if([notificableTipe isEqualToString:@"Medcase"]){
            height = 290;
        }
        if([notificableTipe isEqualToString:@"Share"]){
            height = 250;
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
    
    
    ShareTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ShareTableViewCell"];
    
    
    cell.delegate = self;
    
    if([notificableType isEqualToString:@"Medcase"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"FeedCaseCell"];
    }
    
    if([notificableType isEqualToString:@"Comment"]){
        cell = [tableView dequeueReusableCellWithIdentifier:@"FeedTableViewCell"];
    }
    
    if([notificableType isEqualToString:@"Share"]){
        
       
        cell.status =  [notificable valueForKeyPath:@"status"];
        
        int sender = [[notificable valueForKey:@"sender_id"] intValue];

        
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        
        int uId = [[defaults objectForKey:@"UserId"] intValue] ;
        
        //NSLog(@" u Id: %d", uId);
        
        if([cell.status isEqualToString:@"approved"]){
            cell.btnAcept.hidden = TRUE;
            cell.btnIgnore.hidden = TRUE;
           
            cell.lblWantToShare.text = @"Shared case with you";
            if (uId == sender){
               cell.lblWantToShare.text = @"Accepted your case";
            }
        } else{
            if (uId != sender) {
                cell.btnAcept.hidden = FALSE;
                cell.btnIgnore.hidden = FALSE;
                cell.lblWantToShare.text = @"Wants to Share";
            }
            else{
                cell.btnAcept.hidden = TRUE;
                cell.btnIgnore.hidden = TRUE;
                cell.lblWantToShare.text = @"You send Share";
            }

        }
    }
    
    if([notificableType isEqualToString:@"Comment"]){
        
        
        Utilities *util = [[Utilities alloc] init];
        
        cell.txtMessage.text = [notificable valueForKeyPath:@"message"];
        [cell.txtMessage sizeToFit];
        [cell.txtMessage setScrollEnabled:NO];
        cell.TextViewHeightConstraint.constant = [self textH:[notificable valueForKeyPath:@"message"]] -25 ;
        cell.TextViewWidthConstraint.constant = [util screenWidth] -20 ;
    
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
    if (scrollView.contentOffset.y < -30){
        if (!self.pullRefreshVisible){
            if (!self.uploadingVisible) {
                [self loadingViewVisible:YES];
               
            }
        }
    }
    
    
    //next page
    CGFloat refreshPoint = scrollView.frame.size.height * self.page;
    CGFloat distanceFromBottom = scrollView.contentSize.height - scrollView.contentOffset.y;
    
   // NSLog(@"PUNTOS %f --- %f --- %f",scrollView.frame.size.height, scrollView.contentSize.height, scrollView.contentOffset.y);
    
    if(distanceFromBottom < refreshPoint && !readNextPage)
    {
        readNextPage = true;
        [self nextPage];
    }
}

-(void) nextPage{
    
   //NSLog(@"Next Page : %d", self.page);
    self.page++;
    NSNumber *p= [[NSNumber alloc] initWithInt:self.page];
    NSMutableDictionary *notificationParams =  @{@"page": p}.mutableCopy;
    Notification *notification = [[Notification alloc] initWithParams:notificationParams];
    
    [notification index:notificationParams Success:^(NSArray *items) {
        [self saveNotificationsCache:items];
        
      //  NSLog(@"Norificaciones : %@", items);
        
        [self fillImtensArray:items];
        readNextPage = false;
    } Error:^(NSError *error) {
            readNextPage = false;
    }];
    
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
    self.page = 1;
    [self refrechData];
}

-(void) saveNotificationsCache:(NSArray *) items{
    
 //   NSLog(@"DEFAULT %@",items);
    
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
 //   [defaults setObject:items forKey:@"notifications"];
    [defaults synchronize];
}

-(NSArray *) loadNotificationsCache{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSArray *items = [defaults objectForKey:@"notifications"];
    return items;
}

- (void) uploadingStart{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"YES" forKey:@"uploading"];
    [defaults synchronize];
}

- (void) uploadingEnd{
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setObject:@"NO" forKey:@"uploading"];
    [defaults synchronize];
    [self upLoadingViewVisible:NO];
    self.page = 1;
    [self refrechData];
}






-(void) upLoadingViewVisible:(BOOL) visible{
    BOOL hidden; int viewMove=0;
    if (visible) {
        if (!self.uploadingVisible) {
            hidden = NO;
            viewMove = 60;
            self.uploadingVisible =TRUE;
            self.upLoadingView.hidden = hidden;
        }
    } else {
        if (self.uploadingVisible) {
            hidden = YES; viewMove = 0;
            self.uploadingVisible =FALSE;
            self.upLoadingView.hidden = hidden;
        }
    }
    [self.upLoadingView startLoadingIndicator];
    
    [UIView animateWithDuration:0.35f animations:^{
        self.viewWidthConstraint.constant = viewMove;
        [self.view layoutIfNeeded];
    }];
    
}


- (void) initialFeed {
    
    NSDictionary *notif = @{
                            @"album_id": @"0",
                            @"created_at": @"2015-11-03T10:01:33.871Z",
                            @"description": @"A cloud based App and web platform for organizing, sharing and discussing medical imaging cases.",
                            @"id": @"0",
                            @"patient": @"xx",
                            @"patient_age": @"30",
                            @"patient_gender": @"Male",
                            @"stars": @"0",
                            @"title": @"Welcome to our platform",
                            @"updated_at": @"2015-11-03T10:01:33.871Z",
                            @"user_id": @"10" };
    
    NSMutableDictionary *item = @{@"actor_user_id": @"10",
                                @"id" : @"0",
                                @"is_read": @"1",
                                @"medcase_image": @"http://casesurfer.com/assets/welcome-1ce1b004d4a86ec72c1e2c0abba4707e.jpg",
                                @"medcaseid": @"0",
                                @"notificable": notif,
                                @"notificable_id": @"215",
                                @"notificable_type": @"Medcase",
                                @"share_image": @"",
                                @"time_ago": @"less than a minute ago",
                                @"title": @"Welcome to our platform, A cloud based App and web platform for organizing, sharing and discussing medical imaging cases.",
                                @"url": @"" ,
                                @"user_avatar": @"",
                                @"user_id": @"10",
                                @"user_name": @"Case Surfer"
                                }.mutableCopy;
    
    
    [itemsArray addObject: item];
    
    
    notif = @{
                            @"album_id": @"0",
                            @"created_at": @"2015-11-03T10:01:33.871Z",
                            @"description": @"",
                            @"id": @"0",
                            @"patient": @"xx",
                            @"patient_age": @"30",
                            @"patient_gender": @"Male",
                            @"stars": @"0",
                            @"title": @"Welcome to our platform",
                            @"updated_at": @"2015-11-03T10:01:33.871Z",
                            @"user_id": @"10" };
    
    item = @{@"actor_user_id": @"10",
                                  @"id" : @"0",
                                  @"is_read": @"1",
                                  @"medcase_image": @"http://casesurfer.com/assets/fistula2-0e76b82af65a9f082767e5ced2d1c594.jpg",
                                  @"medcaseid": @"0",
                                  @"notificable": notif,
                                  @"notificable_id": @"",
                                  @"notificable_type": @"Medcase",
                                  @"share_image": @"",
                                  @"time_ago": @"less than a minute ago",
                                  @"title": @"You will be notified here when you upload a case.\n You uploaded a new case Left CC Fistula ",
                                  @"url": @"" ,
                                  @"user_avatar": @"",
                                  @"user_id": @"10",
                                  @"user_name": @"Case Surfer"
                                  }.mutableCopy;
    
    
    [itemsArray addObject: item];
    
    notif = @{
              @"album_id": @"0",
              @"created_at": @"2015-11-03T10:01:33.871Z",
              @"description": @"",
              @"id": @"0",
              @"patient": @"xx",
              @"patient_age": @"30",
              @"patient_gender": @"Male",
              @"stars": @"0",
              @"title": @"Welcome to our platform",
              @"updated_at": @"2015-11-03T10:01:33.871Z",
              @"user_id": @"10" };
    
    item = @{@"actor_user_id": @"10",
             @"id" : @"0",
             @"is_read": @"1",
             @"medcase_image": @"http://casesurfer.com/assets/shared1-da11362bc582bdf0728b23e4f89035f5.jpg",
             @"medcaseid": @"0",
             @"notificable": notif,
             @"notificable_id": @"",
             @"notificable_type": @"Share",
             @"share_image": @"",
             @"time_ago": @"less than a minute ago",
             @"title": @"If someone wants to share a case with you will be ask here for accepting or declining.\n John Bolton want's to share a case with you.  ",
             @"url": @"" ,
             @"user_avatar": @"",
             @"user_id": @"10",
             @"user_name": @"Case Surfer"
             }.mutableCopy;
    
    
    [itemsArray addObject: item];
    
    notif = @{
              @"created_at": @"2015-12-02T17:57:16.014Z",
              @"id": @"0",
              @"medcase_id": @"0",
              @"message": @"This Timeline displays all your comments or other’s comments to shared cases.\n\nJohn Bolton : Great job ",
              @"updated_at": @"2015-12-02T17:57:16.014Z",
              @"user_id": @"0",
              };
    
    item = @{@"actor_user_id": @"10",
             @"id" : @"0",
             @"is_read": @"1",
             @"medcase_image": @"http://casesurfer.com/assets/fistula1-920c006972123c43b695ba82644d5c00.jpg",
             @"medcaseid": @"0",
             @"notificable": notif,
             @"notificable_id": @"",
             @"notificable_type": @"Comment",
             @"share_image": @"",
             @"time_ago": @"less than a minute ago",
             @"title": @"Some Medcase",
             @"url": @"" ,
             @"user_avatar": @"",
             @"user_id": @"10",
             @"user_name": @"Case Surfer"
             }.mutableCopy;
    
    
    [itemsArray addObject: item];
    
    
}


// cell delegate
- (void) accept:(NSString *) notificationId {
    [self shareStatus: notificationId];
}

- (void) ignore:(NSString *) notificationId {
    [self shareStatus: notificationId];
}


- (void) shareStatus:(NSString *) notificationId{
    [self removeItemArray: notificationId ];
    
    self.page = 1;
    [self refrechData];
}

-(void) removeItemArray: (NSString *) id{
    bool exist = false;
    int i = 0;
    int itemindex = 0;
    for (NSMutableDictionary *iarray in itemsArray) {
        if ([id isEqual: [iarray valueForKeyPath:@"id"]]) {
            exist = true;
            itemindex=i;
        }
        i++;
    }
    if (exist) {
        [itemsArray removeObjectAtIndex: itemindex];
    }
}

@end
