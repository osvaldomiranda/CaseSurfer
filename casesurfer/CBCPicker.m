//
//  CBCPicker.m
//  Cranberry
//
//  Created by Osvaldo Antonio Miranda Silva on 26-03-15.
//  Copyright (c) 2015 Osvaldo Antonio Miranda Silva. All rights reserved.
//

#import "CBCPicker.h"

@interface CBCPicker (){
    CGPoint pickerShowPosition;
}
@end

@implementation CBCPicker

- (id) initPickerWithData:(NSArray *)mDataSource selectedItem:(NSString *)mSelectedItem onCanvas:(UIView *)mContainer onSelect:(void (^) (NSString *selectedItem))mSelectBlock onNext:(void (^)())mNextBlock{
    self = [super initWithFrame:mContainer.frame];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:@"CBCPicker" owner:self options:nil];
        [self addSubview:self.nibView];
        self.nibView.frame = mContainer.frame;
        self.datasource = mDataSource;
        self.selectBlock = mSelectBlock;
        self.nextBlock = mNextBlock;
        [self selectItem:mSelectedItem];
        pickerShowPosition = (CGPoint){0, self.containerView.frame.origin.y};
        [self showPicker];
    }
    UITapGestureRecognizer *gestureRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(removeAll)];
    [self addGestureRecognizer:gestureRecognizer];
    return self;
}

+ (void) showPickerWithData:(NSArray *)mDataSource selectedItem:(NSString *)mSelectedItem onCanvas:(UIView *)mContainer onSelect:(void (^) (NSString *selectedItem))mSelectBlock onNext:(void (^)())mNextBlock{

    CBCPicker *modalPicker = [[CBCPicker alloc] initPickerWithData:mDataSource selectedItem:mSelectedItem onCanvas:mContainer onSelect:mSelectBlock onNext:mNextBlock];
    [mContainer addSubview:modalPicker];
}

- (void) removeAll{
    [UIView animateWithDuration:0.4 animations:^{
        self.containerView.frame = CGRectMake(pickerShowPosition.x,
                                              pickerShowPosition.y + self.containerView.frame.size.height,
                                              self.containerView.frame.size.width,
                                              self.containerView.frame.size.height);
    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)selectItem:(NSString *)mSelectedItem{
    if (mSelectedItem != nil) {
        for (int i=0; i<self.datasource.count; i++) {
            if ([mSelectedItem isEqualToString:self.datasource[i]]) {
                [self.picker selectRow:i inComponent:0 animated:YES];
                self.selectedItem = self.datasource[i];
            }
        }
    }
}

- (IBAction)tapSelect:(id)sender{
    if (self.selectBlock) {
        NSInteger row = [self.picker selectedRowInComponent:0];
        self.selectBlock([self pickerView:self.picker titleForRow:row forComponent:0]);
        [self removeAll];
    }
}

- (IBAction)tapNext:(id)sender{
    if (self.nextBlock) {
        NSInteger row = [self.picker selectedRowInComponent:0];
        self.selectBlock([self pickerView:self.picker titleForRow:row forComponent:0]);
        self.nextBlock();
        [self removeAll];
    }
}

- (void)showPicker{
    self.containerView.frame = CGRectMake(pickerShowPosition.x,
                                       pickerShowPosition.y + self.containerView.frame.size.height,
                                       self.containerView.frame.size.width,
                                       self.containerView.frame.size.height);
    [UIView animateWithDuration:0.4 animations:^{
        self.containerView.frame = CGRectMake(pickerShowPosition.x,
                                           pickerShowPosition.y,
                                           self.containerView.frame.size.width,
                                           self.containerView.frame.size.height);
    } completion:nil];
}


- (void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component
{
    self.selectedItem = self.datasource[row];
    NSLog(@"row selected:%@", self.selectedItem);
}

- (NSString*) pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component
{
    return self.datasource[row];
}

- (NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView
{
    return 1;
}

- (NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component
{
    return self.datasource.count;
}

@end
