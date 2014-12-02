//
//  FSAlertView.m
//  FSAlertView
//
//  Created by fengs on 14-11-28.
//  Copyright (c) 2014年 fengs. All rights reserved.
//

#import "FSAlertView.h"
#import <QuartzCore/QuartzCore.h>

#define leftRightSpace_ 22.0f
#define headerFooterSpace_ 22.0f
#define cellWidthSpace_ ([UIScreen mainScreen].applicationFrame.size.width - leftRightSpace_ - leftRightSpace_)
#define cellHeightSpace_ 44.0f
#define gapSpace_ 10.0f

@implementation FSAlertView
@synthesize delegate = _delegate;
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;
@synthesize btnTableView = _btnTableView;
@synthesize btnList = _btnList;
@synthesize cancelButtonTitle = _cancelButtonTitle;
@synthesize hasTwoBtns = _hasTwoBtns;

-(void)dealloc{
    [super dealloc];
    self.titleLabel = nil;
    self.messageLabel = nil;
    self.btnTableView = nil;
    self.btnList = nil;
    self.cancelButtonTitle = nil;
}

#pragma mark -
#pragma mark - view init
/**
 * view init
 * @param title
 * @param message
 * @param delegate
 * @param tag
 * @param cancelButtonTitle
 * @param otherButtonTitles
 * @return id
 */
- (id)initWithTitle:(NSString*)title message:(NSString*)message delegate:(id /*<FSAlertViewDelegate>*/)delegate cancelButtonTitle:(NSString*)cancelButtonTitle otherButtonTitles:(NSString*)otherButtonTitles, ... NS_REQUIRES_NIL_TERMINATION{
    
    self = [super init];
    if (self) {
        self.backgroundColor = [UIColor clearColor];
        self.delegate = delegate;
        CGFloat tempHeight = 0;
        if(title){
            UILabel *titleLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_, cellHeightSpace_)] autorelease];
            titleLabel.backgroundColor = [UIColor clearColor];
            titleLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:16];
            titleLabel.textAlignment = UITextAlignmentCenter;
            titleLabel.textColor = [UIColor blackColor];
            titleLabel.numberOfLines = 1;
            titleLabel.text = title;
            
            self.titleLabel = titleLabel;
            tempHeight = self.titleLabel.frame.size.height;
        }
        
        if(message){
            // messageLabel default height：33.0f
            CGFloat height = [self resizeViewHeight:message width:cellWidthSpace_- gapSpace_*2 height:33];
            CGFloat originHeight = gapSpace_;
            if(title){
                originHeight = 0;
            }
            UILabel *messageLabel = [[[UILabel alloc] initWithFrame:CGRectMake(gapSpace_, originHeight, cellWidthSpace_- gapSpace_*2, height)] autorelease];
            
            messageLabel.backgroundColor = [UIColor clearColor];
            messageLabel.font = [UIFont systemFontOfSize:13.0f];
            messageLabel.textAlignment = UITextAlignmentCenter;
            messageLabel.textColor = [UIColor blackColor];
            messageLabel.numberOfLines = 0;
            messageLabel.text = message;
            
            self.messageLabel = messageLabel;
            tempHeight += height + originHeight + gapSpace_;
        }
        
        self.btnList = [[[NSMutableArray alloc] init] autorelease];
        
        if(otherButtonTitles){
            NSMutableArray *array = [NSMutableArray array];
            va_list args;
            va_start(args, otherButtonTitles);
            for (NSString *str = otherButtonTitles; str != nil; str = va_arg(args,NSString*)) {
                [array addObject:str];
            }  
            va_end(args);
            
            self.btnList = array;
        }
        
        self.cancelButtonTitle = cancelButtonTitle;
        if(cancelButtonTitle){
            [self.btnList addObject:cancelButtonTitle];
        }
        
        self.hasTwoBtns = self.btnList.count == 2;
        
        CGFloat tableViewHeight = self.btnList.count*44 + tempHeight;
        if(self.hasTwoBtns){
            tableViewHeight = 44 + tempHeight;
        }
        if(tableViewHeight > [UIScreen mainScreen].applicationFrame.size.height - 44.0f*2 - headerFooterSpace_*2){ // navigationbar-height: 44.0f
            tableViewHeight = [UIScreen mainScreen].applicationFrame.size.height - 44.0f*2 - headerFooterSpace_*2;
        }
        
        UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(leftRightSpace_, ([UIScreen mainScreen].applicationFrame.size.height - tableViewHeight-44.0f*2)/2, cellWidthSpace_, tableViewHeight) style:UITableViewStylePlain] autorelease];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.8];;
        tableView.scrollEnabled = YES;
        UIView *footView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        tableView.tableFooterView = footView;
        tableView.dataSource = self;
        tableView.delegate = self;
        
        // UITableView border radius
        tableView.layer.borderColor = [[UIColor grayColor] CGColor];
        tableView.layer.cornerRadius = 10.0f;
        tableView.layer.borderWidth = 0.0f;
        
        self.btnTableView = tableView;
        
        [self addSubview:self.btnTableView];
    }
    return self;
}

#pragma mark -
#pragma mark - UITableView Delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.btnList.count + 2;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {// title
        if (self.titleLabel) {
            return 44;
        }else{
            return 0;
        }
    }else if(indexPath.row == 1){// message
        if (self.messageLabel) {
            return self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + gapSpace_;
        }else{
            return 0;
        }
    }else{
        if (self.hasTwoBtns) {
            if (indexPath.row == 2) {
                return 44;
            }else{/* if (indexPath.row == 4) { */
                return 0;
            }
        }else
            return 44; 
    }

}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *CellIdentifier = [NSString stringWithFormat:@"Cell%d",indexPath.row];
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        cell = [[[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier ] autorelease];
        if (indexPath.row == 0) {
            if (self.titleLabel){
                cell.userInteractionEnabled = NO;
                cell.accessoryView = self.titleLabel;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
                
                if (!self.messageLabel) {
                    // add underline
                    UIImageView *imgView = [[[UIImageView alloc]initWithFrame:CGRectMake( 0, cell.frame.size.height-1, cellWidthSpace_, 1)] autorelease];
                    imgView.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0];
                    [cell addSubview:imgView];
                }

            }
        }else if (indexPath.row == 1) {
            if (self.messageLabel){

                UIView *cellView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + gapSpace_)] autorelease];
                [cellView addSubview:self.messageLabel];
                
                // add underline
                UIImageView *imgView = [[[UIImageView alloc]initWithFrame:CGRectMake( 0, cellView.frame.size.height-1, cellWidthSpace_, 1)] autorelease];
                imgView.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0];
                [cellView addSubview:imgView];
                
                cell.userInteractionEnabled = NO;
                cell.accessoryView = cellView;
                cell.selectionStyle = UITableViewCellSelectionStyleNone;
            }
        }else{
            if (self.hasTwoBtns) {
                if (indexPath.row == 2) {
                    UIView *cellView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_, cellHeightSpace_)] autorelease];
                    
                    UIButton *leftBtn = [[[UIButton alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_/2, cellHeightSpace_)] autorelease];
                    UILabel *leftLabel = [[[UILabel alloc] initWithFrame:leftBtn.frame] autorelease];
                    leftLabel.backgroundColor = [UIColor clearColor];
                    leftLabel.font = [UIFont systemFontOfSize:16.0f];
                    leftLabel.textAlignment = UITextAlignmentCenter;
                    leftLabel.textColor = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0];
                    leftLabel.numberOfLines = 0;
                    leftLabel.text = [self.btnList objectAtIndex:0];
                    [leftBtn addSubview:leftLabel];
                    [leftBtn addTarget:self action:@selector(leftBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cellView addSubview:leftBtn];
                    
                    UIButton *rightBtn = [[[UIButton alloc] initWithFrame:CGRectMake(cellWidthSpace_/2+1, 0, cellWidthSpace_/2-1, cellHeightSpace_)] autorelease];
                    UILabel *rightLabel = [[[UILabel alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_/2-1, cellHeightSpace_)] autorelease];
                    rightLabel.backgroundColor = [UIColor clearColor];
                    rightLabel.font = [UIFont systemFontOfSize:16.0f];
                    rightLabel.textAlignment = UITextAlignmentCenter;
                    rightLabel.textColor = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0];
                    rightLabel.numberOfLines = 0;
                    rightLabel.text = [self.btnList objectAtIndex:1];
                    [rightBtn addSubview:rightLabel];
                    [rightBtn addTarget:self action:@selector(rightBtnClick:) forControlEvents:UIControlEventTouchUpInside];
                    [cellView addSubview:rightBtn];
                    
                    // add underline 
                    UIImageView *imgView = [[[UIImageView alloc]initWithFrame:CGRectMake( 0, cellHeightSpace_-1, cellWidthSpace_, 1)] autorelease];
                    imgView.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0];
                    [cellView addSubview:imgView];
                    
                    // add underline Vertical
                    UIImageView *imgViewVertical = [[[UIImageView alloc] initWithFrame:CGRectMake( cellWidthSpace_/2, 0, 1, cellHeightSpace_)] autorelease];
                    imgViewVertical.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0];
                    [cellView addSubview:imgViewVertical];
                    
                    cell.accessoryView = cellView;
                    cell.selectionStyle = UITableViewCellSelectionStyleNone;
                    
                }
            }else{
                for (int i=0; i< self.btnList.count; i++) {
                    if (indexPath.row == i+2) {
                        cell.textLabel.text = [self.btnList objectAtIndex:i];
                        if(self.cancelButtonTitle && indexPath.row == self.btnList.count+1){
                            cell.textLabel.font = [UIFont fontWithName:@"Helvetica-Bold" size:13];
                        }else{
                            cell.textLabel.font = [UIFont systemFontOfSize:13.0];
                        }
                        cell.textLabel.textColor = [UIColor colorWithRed:0/255.0f green:122/255.0f blue:255/255.0f alpha:1.0];
                        cell.textLabel.textAlignment = UITextAlignmentCenter;
                        cell.textLabel.backgroundColor = [UIColor clearColor];
                        
                        // add underline
                        UIImageView *imgView = [[[UIImageView alloc]initWithFrame:CGRectMake( 0, cellHeightSpace_-1, cellWidthSpace_, 1)] autorelease];
                        imgView.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0];
                        [cell addSubview:imgView];
                        
                    }
                }
            }

        }
    }
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (!self.hasTwoBtns) {
        // click the cancelButton
        if(self.cancelButtonTitle && indexPath.row == self.btnList.count+1){
            [self hideView];
            return;
        }
        
        // delegate event
        if ([self.delegate respondsToSelector:@selector(fsAlertView:clickedButtonAtIndex:)]) {
            [self hideView];
            [self.delegate fsAlertView:self clickedButtonAtIndex:indexPath.row-2+1];
        }
    }
}

#pragma mark -
#pragma mark - hasTwoBtns click event

/**
 * leftBtnClick UIControlEventTouchUpInside
 * @param UIButton
 * @return
 */
-(void)leftBtnClick:(UIButton *)btn{
    
    // delegate event
    if ([self.delegate respondsToSelector:@selector(fsAlertView:clickedButtonAtIndex:)]) {
        [self hideView];
        [self.delegate fsAlertView:self clickedButtonAtIndex:1];
    }
}

/**
 * rightBtnClick UIControlEventTouchUpInside
 * @param UIButton
 * @return
 */
-(void)rightBtnClick:(UIButton *)btn{
    if (self.cancelButtonTitle) {
        [self hideView];
        return;
    }
    // delegate event
    if ([self.delegate respondsToSelector:@selector(fsAlertView:clickedButtonAtIndex:)]) {
        [self hideView];
        [self.delegate fsAlertView:self clickedButtonAtIndex:2];
    }
}

#pragma mark -
#pragma mark - FSAlertView method

/**
 * UIView(FSAlertView) show
 * @param view:
    UIViewController.view
 * @return
 */
- (void)showInView:(UIView *)view{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        // add UIViewController.view shadow
        UIView *shadowView = [[[UIView alloc] initWithFrame:[UIScreen mainScreen].bounds] autorelease];
        shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];
        shadowView.userInteractionEnabled = NO;
        shadowView.tag = 1024;
        [view addSubview:shadowView];
        [view bringSubviewToFront:shadowView];
        
        // UIView(FSAlertView) show
        [self setFrame:[UIScreen mainScreen].bounds];
        [view addSubview:self];
        [view bringSubviewToFront:self];
        
        //  navigationItem disable
        UIViewController *viewController = [self viewController];
        viewController.navigationItem.leftBarButtonItem.enabled = NO;
        viewController.navigationItem.rightBarButtonItem.enabled = NO;
        
        // except of UIView(FSAlertView) be disable
        for (UIView *subView in [view subviews]) {
            if (![self isEqual:subView]) {
                subView.userInteractionEnabled = NO;
            }
        }
        
        if (self.btnList.count == 0) {
            [NSTimer scheduledTimerWithTimeInterval:3.0f
                                             target:self
                                           selector:@selector(hideView)
                                           userInfo:nil
                                            repeats:NO];
        }
    } completion:^(BOOL isFinished){
        
    }];
}

/**
 * hide UIView(FSAlertView)
 * @return
 */
-(void)hideView
{
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationOptionCurveEaseInOut animations:^(void){
        // remove UIViewController.view shadow, UIViewController.view available
        for (UIView *subView in [[self superview] subviews]) {
            if (subView.tag == 1024) {
                [subView removeFromSuperview];
            }else{
                subView.userInteractionEnabled = YES;
            }
        }
        // FSAlertView hide
        [self setFrame:CGRectMake(0, [UIScreen mainScreen].bounds.size.height, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
        //  navigationItem available
        UIViewController *viewController = [self viewController];
        viewController.navigationItem.leftBarButtonItem.enabled = YES;
        viewController.navigationItem.rightBarButtonItem.enabled = YES;
        
    } completion:^(BOOL isFinished){
        
    }];
}

/**
 * find the UIViewController by UIView
 * @return
 */
- (UIViewController *)viewController {
    UIResponder *responder = self;
    while (![responder isKindOfClass:[UIViewController class]]) {
        responder = [responder nextResponder];
        if (nil == responder) {
            break;
        }
    }
    return (UIViewController *)responder;
}

/**
 * resize View eight
 * @param text
 * @param width:
    const
 * @param height:
    default view height
 * @return CGFloat
 */
-(CGFloat)resizeViewHeight:(NSString *)text width:(CGFloat)width height:(CGFloat)height{
    
    CGSize constraint = CGSizeMake(width, 2000.0f);
    CGSize size = [text sizeWithFont:[UIFont systemFontOfSize:13.0f] constrainedToSize:constraint lineBreakMode:UILineBreakModeWordWrap];
    return size.height>height?size.height:height;
}
@end
