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

@interface AlbumsViewController ()

@end

@implementation AlbumsViewController
@synthesize scrollView;
@synthesize assetsLibrary;

- (void)viewDidLoad {
    [super viewDidLoad];
    assetsLibrary = [[ALAssetsLibrary alloc] init];
    [self setScrollViewProperties];
    [self loadAlbums];

   
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:TRUE];
    

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setScrollViewProperties{
    scrollView = [[GridScrollView alloc] initGrid:2 spacing:35 gridWidth:380];
    
    scrollView.contentMode = (UIViewContentModeScaleAspectFill);
    scrollView.contentSize =  CGSizeMake(380,SCREEN_HEIGHT);
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator = YES;
    scrollView.showsHorizontalScrollIndicator = NO;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollView.maximumZoomScale = 1;
    scrollView.minimumZoomScale = 1;
    scrollView.clipsToBounds = YES;
    scrollView.frame = CGRectMake(0, 65, 380, SCREEN_HEIGHT-60);
    [scrollView setBackgroundColor:[UIColor whiteColor]];
    scrollView.gridDelegate = self;
    
    [self.view addSubview:scrollView];
}

#pragma GridScrollView
- (void)selectImageWithAssetURL:(NSURL *)assetURL image:(IndexableImageView *)image{
    
    [self callListCasesWithAlbum];
   
}
#pragma END GridScrollView


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
        
        [self.Albums addObject:album];
      
        
        NSMutableDictionary *coverA = [album valueForKeyPath:@"cover"];
        NSMutableDictionary *coverb = [coverA valueForKeyPath:@"cover"];
        NSMutableDictionary *normal = [coverb valueForKeyPath:@"normal"];
        
        NSString *coverUrl = [NSString stringWithFormat:@"%@%@",BASE_PATH, [normal valueForKeyPath:@"url"]];
        NSURL *urlCoverAlbum = [NSURL URLWithString:[coverUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
  
        IndexableImageView *imageInfo = [[IndexableImageView alloc] initWithUrl:urlCoverAlbum andImageInfo:album];
        
        UIImageView *coverAlbum = [[UIImageView alloc] init];
        [coverAlbum setImageWithURL:urlCoverAlbum placeholderImage:nil options:0 success:^(UIImage *image, BOOL cached) {
            
            [scrollView insertPicture:image withAssetURL:nil indexImage:imageInfo];
            
        } failure:^(NSError *error) {
        }];
    }
    /*
    ALAssetsLibrary *assetsLib= [[ALAssetsLibrary alloc] init];
    [assetsLib enumerateGroupsWithTypes:ALAssetsGroupSavedPhotos
                                 usingBlock:^(ALAssetsGroup *group, BOOL *stop){
                                     if (group != nil){
                                         [group setAssetsFilter:[ALAssetsFilter allPhotos]];
                                         [group enumerateAssetsWithOptions:NSEnumerationReverse usingBlock:^(ALAsset *result, NSUInteger index, BOOL *stop){
                                             if (result != nil){
                                                 UIImage *img = [UIImage imageWithCGImage:[result thumbnail]];
                                                 
                                                 IndexableImageView *imageInfo = [[IndexableImageView alloc] initWithUrl:nil andImageInfo:a];
                                                 
                                                 [scrollView insertPicture:img withAssetURL:nil indexImage:imageInfo];
                                             }
                                         }];
                                     }
                                 } failureBlock:^(NSError *error) {
                                     NSLog(@"error: %@", error);
                                 }];
    
 

  */
    
}


- (IBAction)addAction:(id)sender {
    
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    NewAlbumViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"NewAlbum"];
    
    
    self.hidesBottomBarWhenPushed =  YES;
    [self.navigationController pushViewController:cController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (void) callListCasesWithAlbum{
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    ListCasesViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"ListCases"];
    cController.albumId = 2;
    
    self.hidesBottomBarWhenPushed =  YES;
    [self.navigationController pushViewController:cController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
    
}



@end
