//
//  CBCPicker.h
//  Cranberry
//
//  Created by Osvaldo Antonio Miranda Silva on 26-03-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface CBCPicker : UIView<UIPickerViewDataSource, UIPickerViewDelegate>

@property (strong, nonatomic) NSArray *datasource;
@property (strong, nonatomic) NSString *selectedItem;
@property (copy) void (^selectBlock) (NSString *selectedItem);
@property (copy) void (^nextBlock) (void);


@property (strong, nonatomic) IBOutlet UIView *nibView;
@property (strong, nonatomic) IBOutlet UIButton *btnSelect;
@property (strong, nonatomic) IBOutlet UIButton *btnNext;
@property (strong, nonatomic) IBOutlet UIPickerView *picker;
@property (strong, nonatomic) IBOutlet UIView *containerView;

- (IBAction)tapSelect:(id)sender;
- (IBAction)tapNext:(id)sender;

+ (void) showPickerWithData:(NSArray *)mDataSource selectedItem:(NSString *)mSelectedItem onCanvas:(UIView *)mContainer onSelect:(void (^) (NSString *selectedItem))mSelectBlock onNext:(void (^)())mNextBlock;


@end
