//
//  UpdateCaseTableView.m
//  casesurfer
//
//  Created by Osvaldo on 11-09-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "UpdateCaseTableView.h"
#import "NewAlbumViewController.h"
#import "MedCase.h"
#import "NSString+Validation.h"
#import "CBCPicker.h"
#import "Definitions.h"
#import "Album.h"
#import "UIAlertView+Block.h"
#import "rollUpdateViewController.h"
#import "rollGridChoseImageViewController.h"
#import "UIImageView+WebCache.h"

@interface UpdateCaseTableView ()

@end

@implementation UpdateCaseTableView
@synthesize scrollView;

- (void)viewDidLoad {
    [super viewDidLoad];
    [self fillCase];
    [self setToptButtons];
    self.albums = [[NSMutableArray alloc] init];
    self.albumIds = [[NSMutableArray alloc] init];
    self.originalImages = [[NSMutableArray alloc] init];
    self.delImages = [[NSMutableArray alloc] init];
    [self setScrollViewProperties];
    [self setImages];

    
  
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:YES];
    [self.navigationController setNavigationBarHidden:FALSE];
    [self loadAlbums];
  
    [scrollView startEditMode];
    
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    [self hideAll];
}


- (void) setToptButtons{
    UIBarButtonItem *rItem = [[UIBarButtonItem alloc] initWithTitle:@"Save"
                                                              style:UIBarButtonItemStylePlain
                                                             target:self
                                                             action:@selector(updateCase:)];
    
    [self.navigationItem setRightBarButtonItem:rItem animated:YES];
}

-(void)setScrollViewProperties{
    scrollView = [[HorizontalGrid alloc] initGrid:4 gridHeight:70];
    
    scrollView.contentMode = (UIViewContentModeScaleAspectFill);
    scrollView.pagingEnabled = NO;
    scrollView.showsVerticalScrollIndicator = NO;
    scrollView.showsHorizontalScrollIndicator = YES;
    scrollView.alwaysBounceVertical = NO;
    scrollView.alwaysBounceHorizontal = NO;
    scrollView.autoresizingMask = (UIViewAutoresizingFlexibleHeight);
    scrollView.maximumZoomScale = 1;
    scrollView.minimumZoomScale = 1;
    scrollView.clipsToBounds = YES;
    scrollView.frame = CGRectMake(0,0, 280, 70);
    scrollView.contentSize = CGSizeMake(280,0);
    
    scrollView.gridDelegate = self;
    
    self.viewImages.frame = CGRectMake(88, 11, 280, 70);
    [self.viewImages addSubview:scrollView];
    
}

- (void) setImages{
    int i = 0;
    for (NSDictionary *imageIdx in self.photos) {
        NSString *id = [imageIdx valueForKeyPath:@"id"];
        NSDictionary *img = [imageIdx valueForKeyPath:@"image"];
        NSDictionary *thumb = [img valueForKeyPath:@"normal"];
        NSString *imgUrl = [NSString stringWithFormat:@"%@%@",DEV_BASE_PATH , [thumb valueForKeyPath:@"url"]];
        NSURL *urlImgCase = [NSURL URLWithString:[imgUrl stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
        
        UIImageView *imageView = [[UIImageView alloc] init];
        
        NSMutableDictionary *info = @{@"id" : [NSString stringWithFormat:@"%d",i],
                                      @"idImageCase": id,
                                      @"url": urlImgCase
                                      }.mutableCopy;
        
        
        [imageView setImageWithURL:urlImgCase placeholderImage:[UIImage imageNamed:@"logo.png"] success:^(UIImage *image, BOOL cached) {
            
            [scrollView insertPicture:image withAssetURL:urlImgCase index:i];
            
            IndexableImageView *indexableImage = [[IndexableImageView alloc] initWithImage:image andUrl:urlImgCase andImageInfo:info];
            
            [self.originalImages addObject:indexableImage];
            
        } failure:^(NSError *error) {
            
        }];
        i++;
    }
    
}

-(void) fillHorizontalView{
    int i = 0;
    
    for (IndexableImageView *imageIdx in self.originalImages) {

        [scrollView insertPicture:imageIdx.image withAssetURL:imageIdx.assetURL index:i];

        i++;
    }
    [scrollView startEditMode];
}

#pragma GridScrollView
- (void)selectImageWithAssetURL:(UIImage *)image indexImage:(int)indexImage assetUrl:(NSURL *)assetUrl{
    [self delImageAtIndex:indexImage];
    
}
#pragma END GridScrollView

- (void) delImageAtIndex:(int)index {
    
    if (self.originalImages.count > 1) {
        
        
        IndexableImageView *image = [self.originalImages objectAtIndex:index];
        
        
        if ([image.imageInfo valueForKeyPath:@"idImageCase"] != NULL ) {
            [self.delImages addObject:image];
        }
        
        [self.originalImages removeObjectAtIndex:index];
        
        [scrollView clearGrid];
        [self fillHorizontalView];
    }

}

#pragma rollUpdate
- (void)selectImages:(NSMutableArray *)images{
    
    [scrollView clearGrid];
    
    self.newImageCount = (int)images.count;
    
    for (IndexableImageView *image in images) {
        IndexableImageView *indexableImage = [[IndexableImageView alloc] initWithImage:image.image andUrl:image.assetURL andImageInfo:image.imageInfo];
        [self.originalImages insertObject:indexableImage atIndex:0];
    }
    
    [self fillHorizontalView];
}
#pragma END rollUpdate




-(void) fillCase{
    NSMutableDictionary *item = self.medCase;
    Album *album = [[Album alloc] init];
    
    [album find:[[item valueForKeyPath:@"album_id"] intValue] Success:^(NSMutableDictionary *items) {
        self.lblAlbum.text = [items valueForKeyPath:@"name"];
        self.selectedAlbum = [items valueForKeyPath:@"name"];
    } Error:^(NSError *error) {
        
    }];
   
    self.txtTitle.text = [item valueForKeyPath:@"title"];
    self.txtDescription.text = [item valueForKeyPath:@"description"];
    self.txtPatient.text = [item valueForKeyPath:@"patient"];
    self.lblGender.text = [item valueForKeyPath:@"patient_gender"];
    self.selectedGender = [item valueForKeyPath:@"patient_gender"];
    
    self.lblAge.text = [NSString stringWithFormat:@"%@",[item valueForKeyPath:@"patient_age"]];
    self.selectedAge = self.lblAge.text;
    
}

-(void) loadAlbums{
    Album *myAlbum = [[Album alloc] init];
    NSMutableDictionary *params = @{@"order_by":@"name"}.mutableCopy;
    [myAlbum index:params Success:^(NSArray *items) {
        [self fillAlbumArray: items];
    } Error:^(NSError *error) {
    }];
   
}

-(void) fillAlbumArray:(NSArray *) items{
    [self.albumIds removeAllObjects];
    [self.albums removeAllObjects];
    for (id album in items  ) {
        NSString *titleAlbum = [album valueForKeyPath:@"name"];
        NSString *idAlbum = [album valueForKeyPath:@"id"];
        [self.albums addObject:titleAlbum];
        [self.albumIds addObject:idAlbum];
    }
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


- (IBAction)updateCase:(id)sender {
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
   //     NSInteger row = [self.albums indexOfObjectIdenticalTo:self.selectedAlbum];
        MedCase *medCase = [[MedCase alloc] init];
        medCase.title = self.txtTitle.text;
  //      medCase.album_id = self.albumIds[row];
        medCase.patient = self.txtPatient.text;
        medCase.patient_age = self.selectedAge;
        medCase.patient_gender = self.selectedGender;
        medCase.descript = self.txtDescription.text;
        medCase.stars = @"0";
        medCase.images = self.photos;
     //   [medCase ];
        
        [self.navigationController setNavigationBarHidden:TRUE];
        [[NSNotificationCenter defaultCenter] postNotificationName:loginObserver
                                                            object:nil];
    }
}

- (IBAction)createAlbum:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    rollGridChoseImageViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"rollGridChose"];
    cController.callerViewController = self;
    self.hidesBottomBarWhenPushed =  YES;
    [self.navigationController pushViewController:cController animated:YES];
    self.hidesBottomBarWhenPushed = NO;
}

- (IBAction)addImage:(id)sender {
    UIStoryboard *storyBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    rollUpdateViewController *cController = [storyBoard instantiateViewControllerWithIdentifier:@"rollUpdate"];
    cController.delegate = self;
    [self.navigationController pushViewController:cController animated:YES];
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
