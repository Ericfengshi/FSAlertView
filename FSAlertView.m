//
//  FSAlertView.m
//  FSAlertView https://github.com/Ericfengshi/FSAlertView
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
@synthesize window;
@synthesize shadowView = _shadowView;
@synthesize titleLabel = _titleLabel;
@synthesize messageLabel = _messageLabel;
@synthesize btnTableView = _btnTableView;
@synthesize btnList = _btnList;
@synthesize cancelButtonTitle = _cancelButtonTitle;
@synthesize hasTwoBtns = _hasTwoBtns;


-(void)dealloc{

    self.shadowView = nil;
    self.titleLabel = nil;
    self.messageLabel = nil;
    self.btnTableView = nil;
    self.btnList = nil;
    self.cancelButtonTitle = nil;
    [super dealloc];
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
        
        id<UIApplicationDelegate> appDelegate = [[UIApplication sharedApplication] delegate];
        if ([appDelegate respondsToSelector:@selector(window)]){
            window = [appDelegate performSelector:@selector(window)];
        }else{
            window = [[UIApplication sharedApplication] keyWindow];
        }
        
        self.shadowView = [[[UIView alloc] initWithFrame:window.frame] autorelease];
        self.shadowView.backgroundColor = [UIColor colorWithRed:0 green:0 blue:0 alpha:0.5];

        self.delegate = delegate;
        
        CGFloat tempHeight = 0;
        /*title*/
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
        /*message*/
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
        /*buttons*/
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
        
        CGFloat tableViewHeight = self.btnList.count*cellHeightSpace_ + tempHeight;
        if(self.hasTwoBtns){
            tableViewHeight = cellHeightSpace_ + tempHeight;
        }
        if(tableViewHeight > [UIScreen mainScreen].applicationFrame.size.height - 44.0 - headerFooterSpace_*2 - 44.0){ //The Top navigationbar height: 44.0f,  the bottom of the symmetry height:44.0
            tableViewHeight = [UIScreen mainScreen].applicationFrame.size.height - 44.0 - headerFooterSpace_*2 - 44.0;
        }
        /*UITableView*/
        UITableView *tableView = [[[UITableView alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_, tableViewHeight) style:UITableViewStylePlain] autorelease];
        tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        tableView.backgroundColor = [UIColor colorWithRed:255/255.0f green:255/255.0f blue:255/255.0f alpha:0.8];
        tableView.scrollEnabled = YES;
        tableView.tableFooterView = [[[UIView alloc] initWithFrame:CGRectZero] autorelease];
        tableView.dataSource = self;
        tableView.delegate = self;
        
        // UITableView border radius
        tableView.layer.borderColor = [[UIColor grayColor] CGColor];
        tableView.layer.cornerRadius = 10.0f;
        tableView.layer.borderWidth = 0.0f;
        
        self.btnTableView = tableView;
        
        [self addSubview:self.btnTableView];
        [self setFrame:CGRectMake(leftRightSpace_, 20+([UIScreen mainScreen].applicationFrame.size.height - tableViewHeight)/2, cellWidthSpace_, tableViewHeight)];// The status bar height:20.0f
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
                    [cell addSubview:[self drawImageViewLine:CGRectMake( 0, cell.frame.size.height-1, cellWidthSpace_, 1)]];
                }

            }
        }else if (indexPath.row == 1) {
            if (self.messageLabel){

                UIView *cellView = [[[UIView alloc] initWithFrame:CGRectMake(0, 0, cellWidthSpace_, self.messageLabel.frame.origin.y + self.messageLabel.frame.size.height + gapSpace_)] autorelease];
                [cellView addSubview:self.messageLabel];
                
                [cellView addSubview:[self drawImageViewLine:CGRectMake( 0, cellView.frame.size.height-1, cellWidthSpace_, 1)]];
                
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
                    
                    [cellView addSubview:[self drawImageViewLine:CGRectMake( 0, cellHeightSpace_-1, cellWidthSpace_, 1)]];
                    [cellView addSubview:[self drawImageViewLine:CGRectMake( cellWidthSpace_/2, 0, 1, cellHeightSpace_)]];
                    
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
                        
                        [cell addSubview:[self drawImageViewLine:CGRectMake( 0, cellHeightSpace_-1, cellWidthSpace_, 1)]];
                        
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
        }else{
            // delegate event
            if ([self.delegate respondsToSelector:@selector(fsAlertView:clickedButtonAtIndex:)]) {
                [self hideView];
                [self.delegate fsAlertView:self clickedButtonAtIndex:indexPath.row-2+1];
            }
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
    }else{
        // delegate
        if ([self.delegate respondsToSelector:@selector(fsAlertView:clickedButtonAtIndex:)]) {
            [self hideView];
            [self.delegate fsAlertView:self clickedButtonAtIndex:2];
        }
    }

}

#pragma mark -
#pragma mark - FSAlertView method

/**
 * UIView(FSAlertView) show
 * @return
 */
- (void)showInView{
    [UIView animateWithDuration:0.5 delay:0.0 options:UIViewAnimationCurveEaseIn animations:^(void){

        [window addSubview:self.shadowView];
        [self setFrame:CGRectMake(leftRightSpace_, 20+([UIScreen mainScreen].applicationFrame.size.height - self.btnTableView.frame.size.height)/2, cellWidthSpace_, self.btnTableView.frame.size.height)];
        [self.shadowView addSubview:self];
        if (self.btnList.count == 0) {
            [self performSelector:@selector(hideView) withObject:nil afterDelay:3.0];
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
    [UIView animateWithDuration:0.3 delay:0.0 options:UIViewAnimationCurveEaseOut animations:^(void){

        [self setFrame:CGRectMake(leftRightSpace_, [UIScreen mainScreen].applicationFrame.size.height, cellWidthSpace_, self.btnTableView.frame.size.height)];
        self.shadowView.backgroundColor = [UIColor clearColor];
        
    } completion:^(BOOL isFinished){
        [self.shadowView removeFromSuperview];
        self.shadowView = nil;
    }];
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


/**
 * add under/vertical line for UIControl
 * @param frame
 * @return UIImageView
 */
-(UIImageView*)drawImageViewLine:(CGRect)frame{
    
    UIImageView *imgView = [[UIImageView alloc]initWithFrame:frame];
    imgView.backgroundColor = [UIColor colorWithRed:200/255.0f green:200/255.0f blue:200/255.0f alpha:1.0];
    return [imgView autorelease];
}
@end
