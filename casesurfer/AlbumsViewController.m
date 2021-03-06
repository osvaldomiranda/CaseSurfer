//
//  AlbumsViewController.m
//  casesurfer
//
//  Created by Osvaldo on 11-05-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "AlbumsViewController.h"
#import "GridScrollView.h"
#import "Definitions.h"
#import "NewAlbumViewController.h"
#import "ListCasesViewController.h"
#import "Album.h"
#import "UIImageView+WebCache.h"
#import "ListCaseTableViewController.h"

@interface AlbumsViewController ()

@end

@implementation AlbumsViewController
@synthesize scrollView;
@synthesize assetsLibrary;

- (void)viewDidLoad {
    [super viewDidLoad];
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    [self setScrollViewProperties];
    self.inEdit = NO;
    self.ordered = false;
    
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:YES];
    [scrollView clearGrid];
    [self loadAlbums];
    self.selectedAlbumId = 0;
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}



-(void)setScrollViewProperties{
    scrollView = [[GridScrollView alloc] initGrid:2 spacing:35 gridWidth:SCREEN_WIDTH];
    
    scrollView.contentMode = (UIViewContentModeScaleAspectFill);
    scrollView.contentSize =  CGSizeMake(SCREEN_WIDTH,SCREEN_HEIGHT);
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollView.maximumZoomScale = 1;
    scrollView.minimumZoomScale = 1;
    scrollView.clipsToBounds = YES;
    scrollView.frame = CGRectMake(0, 60, SCREEN_WIDTH, SCREEN_HEIGHT-110);
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    scrollView.gridDelegate = self;
    
    [self.view addSubview:scrollView];
}

#pragma GridScrollView
- (void)selectImageWithAssetURL:(NSURL *)assetURL image:(IndexableImageView *)image selected:(BOOL *)selected{
    self.selectedAlbumId = [[image.imageInfo valueForKeyPath:@"id"] intValue];
    if (self.inEdit) {
        [self deleteAlbumConfirm];
    } else {
        [self callListCasesWithAlbum];
    }
}
#pragma END GridScrollView


-(void) loadAlbums{
    Album *myAlbum = [[Album alloc] init];
    NSMutableDictionary *params =  @{}.mutableCopy;
    
    [myAlbum album_shared:params Success:^(NSArray *items) {
        [self makeAlbumShared:items];
    } Error:^(NSError *error) {
    }];
    
    if (self.ordered) {
        params =  @{@"order_by":@"name"}.mutableCopy;
    }
    else {
        params =  @{}.mutableCopy;
    }
    
    [myAlbum index:params Success:^(NSArray *items) {
        [self fillAlbumArray: items];
    } Error:^(NSError *error) {
    }];
    

    
}

- (IBAction)order:(id)sender{
    [scrollView clearGrid];
    if (self.ordered) {
        self.ordered = false;
    }
    else {
        self.ordered = true;
    }
    [self loadAlbums];
}

- (IBAction)search:(id)sender {
    self.selectedAlbumId = 9999;
    [self callList];
}

- (void) callList{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ListCaseTableViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"ListCaseTable"];
    cController.albumId = self.selectedAlbumId;
    self.hidesBottomBarWhenPushed =  YES;
    [self.navigationController pushViewController:cController animated:NO];
    self.hidesBottomBarWhenPushed = NO;
}

-(void) fillAlbumArray:(NSArray *) items{
    for (id album in items  ) {
        [self.Albums addObject:album];
        
        NSMutableDictionary *coverA = [album valueForKeyPath:@"cover"];
        NSMutableDictionary *coverb = [coverA valueForKeyPath:@"cover"];
        NSMutableDictionary *normal = [coverb valueForKeyPath:@"normal"];
        
        NSString *coverUrl = [NSString stringWithFormat:@"%@%@",DEV_BASE_PATH, [normal valueForKeyPath:@"url"]];
        NSURL *urlCoverAlbum = [NSURL URLWithString:[coverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  
        IndexableImageView *imageInfo = [[IndexableImageView alloc] initWithUrl:urlCoverAlbum andImageInfo:album];
        
        UIImage *placeholder = [UIImage imageNamed:@"logo.png"];
        
        UIImageView *coverAlbum = [[UIImageView alloc] init];
        [coverAlbum setImageWithURL:urlCoverAlbum placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
            [scrollView insertPicture:image withAssetURL:nil indexImage:imageInfo];
        } failure:^(NSError *error) {
           [scrollView insertPicture:placeholder withAssetURL:nil indexImage:imageInfo];
        }];
    }
    
    
    
}

- (void) makeAlbumShared:(NSArray *) items {
    
    NSDictionary *normal = @{@"url" : @"/assets/fallback/album/normal_default-7d926a5922e6cf19df77d063203983b6.png"};
    NSDictionary *coverA = @{@"normal": normal};
    NSDictionary *cover  = @{@"cover": coverA};
    
    NSArray *medCases = [items[0] valueForKeyPath:@"medcases"];
    
    NSMutableDictionary *albumShare = @{
                                        @"id" : @"0",
                                        @"name" : @"Shared With Me",
                                        @"cases" : [NSString stringWithFormat:@"%lu", (unsigned long)[medCases count]] ,
                                        @"cover" : cover
                                        }.mutableCopy;
    NSArray *sharedWithMe = [[NSArray alloc] initWithObjects:albumShare, nil];
    
    [self fillAlbumArray:sharedWithMe];
}


- (IBAction)addAction:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        
    NewAlbumViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"NewAlbum"];
   
    self.hidesBottomBarWhenPushed =  YES;
    [self.navigationController pushViewController:cController animated:YES];
    self.hidesBottomBarWhenPushed =  NO;
    
}

- (void) callListCasesWithAlbum{

    [self callList];
}

- (IBAction)edit:(id)sender {
    if (!self.inEdit) {
        [scrollView startEditMode];
        self.inEdit = YES;
    } else {
        [scrollView endEditMode];
        self.inEdit = NO;
    }
}

- (void)deleteAlbumConfirm{
    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@" Are you sure ? "
                                                    message:@"The album and all cases will be removed"
                                                   delegate:self
                                          cancelButtonTitle:@"Cancel"
                                          otherButtonTitles:@"OK", nil];
    [alert show];
}

-(void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (buttonIndex != 0)  // 0 ==  cancel button
    {
        [self deleteAlbum];
    }else {
        [scrollView clearGrid];
        [self loadAlbums];
        self.inEdit = NO;
    }
}

-(void) deleteAlbum{
    NSMutableDictionary *albumParams = @{}.mutableCopy;
    Album *album = [[Album alloc] init];
    
    [album delete:self.selectedAlbumId params:albumParams Success:^(NSMutableDictionary *items) {
        [scrollView clearGrid];
        [self loadAlbums];
        self.inEdit = NO;
    } Error:^(NSError *error) {
    }];
}
@end
