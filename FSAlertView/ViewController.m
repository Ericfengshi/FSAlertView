//
//  ViewController.m
//  FSAlertView
//
//  Created by fengs on 14-11-28.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()
@property (nonatomic,retain) UITextField *textField;
@end

@implementation ViewController
@synthesize textField = _textField;

-(void)dealloc{

    self.textField = nil;
    [super dealloc];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    self.textField = nil;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor whiteColor];
    
    UITextField *textField = [[[UITextField alloc] initWithFrame:CGRectMake(([UIScreen mainScreen].applicationFrame.size.width - 200)/2, 30, 200, 40)] autorelease];
    textField.borderStyle = UITextBorderStyleRoundedRect;
    textField.textAlignment = UITextAlignmentCenter;
    textField.placeholder = @"click value";
    textField.delegate = self;
    textField.contentVerticalAlignment = UIControlContentVerticalAlignmentCenter;
    self.textField = textField;
    [self.view addSubview:self.textField];
    
    UIBarButtonItem *barBtnItemRight = [[UIBarButtonItem alloc]initWithTitle:@"more"
                                                                       style:UIBarButtonItemStyleDone
                                                                      target:self
                                                                      action:@selector(more)];
    self.navigationItem.rightBarButtonItem = barBtnItemRight;
    [barBtnItemRight release];

}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)more{
    
    FSAlertView *moreAlert = [[FSAlertView alloc] initWithTitle:@"title"
                                                        message:@"the FSAlertView message: please click the buttons"
                                                       delegate:self
                                              cancelButtonTitle:@"cancel"
                                              otherButtonTitles:@"button 1",@"button 2",@"button 3"
                              ,@"button 4",@"button 5",@"button 6"
                              ,@"button 7",@"button 8",@"button 9",@"button 10", nil];

    moreAlert.tag = 0x1101;
    [moreAlert showInView];
    [moreAlert release];
}

#pragma mark -
#pragma mark -FSAlertViewDelegate
- (void)fsAlertView:(UIView*)fsAlertView clickedButtonAtIndex:(NSInteger)buttonIndex {
    
    if (fsAlertView.tag == 0x1101) {
        switch (buttonIndex) {
                // button 1
            case 1: {
                self.textField.text = @"button 1";
                break;
            }
                // button 2
            case 2: {
                self.textField.text = @"button 2";
                break;
            }
                // button 3
            case 3: {
                self.textField.text = @"button 3";
                break;
            }
                // button 4
            case 4: {
                self.textField.text = @"button 4";
                break;
            }
                // button 5
            case 5: {
                self.textField.text = @"button 5";
                break;
            }
                // button 6
            case 6: {
                self.textField.text = @"button 6";
                break;
            }
                // button 7
            case 7: {
                self.textField.text = @"button 7";
                break;
            }
                // button 8
            case 8: {
                self.textField.text = @"button 8";
                break;
            }
                // button 9
            case 9: {
                self.textField.text = @"button 9";
                break;
            }
                // button 10
            case 10: {
                self.textField.text = @"button 10";
                break;
            }
            default:
                break;
        }
    }
}

#pragma mark -
#pragma mark -textFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    return NO;
}

@end
