//
//  FSAlertView.h
//  FSAlertView
//
//  Created by fengs on 14-11-28.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol FSAlertViewDelegate <NSObject>
@optional
- (void)fsAlertView:(UIView*)fsAlertView clickedButtonAtIndex:(NSInteger)buttonIndex;
@end

@interface FSAlertView : UIView<UITableViewDataSource,UITableViewDelegate>

@property(nonatomic,assign) id delegate;
@property (nonatomic,retain) UILabel *titleLabel;
@property (nonatomic,retain) UILabel *messageLabel;
@property (nonatomic,retain) UITableView *btnTableView;
@property (nonatomic,retain) NSMutableArray *btnList;
@property (nonatomic,retain) NSString *cancelButtonTitle;
@property (nonatomic,assign) BOOL hasTwoBtns;

- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id /*<FSAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION;
- (void)showInView:(UIView *)view;
@end
