//
//  ChatTableViewCell.m
//  test
//
//  Created by iFlyLabs on 06/04/15.
//  Copyright (c) 2015 iFlyLabs. All rights reserved.
//

#import "ChatTableViewCell.h"
#import "ChatCellSettings.h"

@interface ChatTableViewCell ()

@property (strong, nonatomic) UIView *Bubble;
@property (strong, nonatomic) UIView *Main;
@property (strong, nonatomic) UIView *UpCurve;
@property (strong, nonatomic) UIView *DownCurve;
@property (strong, nonatomic) UIView *HidingLayerTop;
@property (strong, nonatomic) UIView *HidingLayerSide;

@end

@implementation ChatTableViewCell


@synthesize Bubble;
@synthesize Main;
@synthesize UpCurve;
@synthesize DownCurve;
@synthesize HidingLayerTop;
@synthesize HidingLayerSide;
@synthesize chatUserImage;
@synthesize chatTimeLabel;
@synthesize chatMessageLabel;
@synthesize chatMessageStatus;
@synthesize chatMessageBurn;
@synthesize messageId;

NSLayoutConstraint *height;
NSLayoutConstraint *width;
NSArray *horizontal;
NSArray *vertical;

CGFloat red;
CGFloat blue;
CGFloat green;

static ChatCellSettings *chatCellSettings = nil;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    static dispatch_once_t onceToken;
    
    dispatch_once(&onceToken, ^{
        chatCellSettings = [ChatCellSettings getInstance];
    });
    
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    self.backgroundColor = [UIColor clearColor];
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;
    self.contentView.autoresizingMask = UIViewAutoresizingFlexibleWidth | UIViewAutoresizingFlexibleHeight;
    
    Bubble = [[UIView alloc] init];
    
    [Bubble setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    Main = [[UIView alloc] init];
    [Main setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UpCurve = [[UIView alloc] init];
    
    [UpCurve setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    DownCurve = [[UIView alloc] init];
    
    [DownCurve setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    HidingLayerTop = [[UIView alloc] init];
    
    [HidingLayerTop setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    HidingLayerSide = [[UIView alloc] init];
    
    [HidingLayerSide setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    chatUserImage = [[UIImageView alloc] init];
    
    [chatUserImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    chatTimeLabel = [[UILabel alloc] init];
    chatTimeLabel.backgroundColor = [UIColor clearColor];
    
    [chatTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    chatMessageLabel = [[UILabel alloc] init];
    
    [chatMessageLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    chatMessageBurn = [[UIImageView alloc] init];
    chatMessageBurn.image = [UIImage imageNamed:@"ic_burn"];
    [chatMessageBurn setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    chatMessageStatus = [[UIImageView alloc] init];
    [chatMessageStatus setTranslatesAutoresizingMaskIntoConstraints: NO];
    
    [self.contentView addSubview:Bubble];
    
    [Bubble addSubview:DownCurve];
    [Bubble addSubview:HidingLayerTop];
    [Bubble addSubview:Main];
    [Bubble addSubview:UpCurve];
    [Bubble addSubview:HidingLayerSide];
    [Bubble addSubview:chatUserImage];
    
    [Main addSubview:chatTimeLabel];
    [Main addSubview:chatMessageLabel];
    [Main addSubview:chatMessageStatus];
    [Main addSubview:chatMessageBurn];
    
    chatUserImage.image = [UIImage imageNamed:@"defaultUser.png"];
    
    chatTimeLabel.text = @"chatTimeLabel";
    
    chatMessageLabel.text = @"chatMessageLabel";
    
    [chatMessageLabel setNumberOfLines:0];
    [chatTimeLabel setNumberOfLines:1];
    
    chatMessageLabel.lineBreakMode = NSLineBreakByWordWrapping;
    chatTimeLabel.lineBreakMode = NSLineBreakByWordWrapping;
    
    
    //Common placement of the different views
    
    //Setting constraints for Bubble. It should be at a zero distance from top, bottom and 8 distance right hand side of the superview, i.e., self.contentView (The default superview for all tableview cell elements)
    
    
    vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[Bubble]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(Bubble)];
    
    width = [NSLayoutConstraint constraintWithItem:Bubble attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:128.0f];
    
    [self.contentView addConstraint:width];
    
    
    [self.contentView addConstraints:vertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for Main block. It contains name, message and time labels. Main should be at a zero distance from bottom and left of its superview, i.e., Bubble
    
    
    vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[Main]-(0)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(Main)];
    
    [Bubble addConstraints:vertical];
    
    height = [NSLayoutConstraint constraintWithItem:Main attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:32.0f];
    
    width = [NSLayoutConstraint constraintWithItem:Main attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationGreaterThanOrEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:38.0f];
    
    
    [Bubble addConstraints:@[height,width]];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for UpCurve. It should be at zero distance from Main on left side, -1 distance from bottom and 10 distance from right of the superview, i.e., Bubble. Height and Width should be 32 and 20 respectively
    
    height = [NSLayoutConstraint constraintWithItem:UpCurve attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:32.0f];
    
    width = [NSLayoutConstraint constraintWithItem:UpCurve attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:20.0f];
    
    
    [Bubble addConstraints:@[height,width]];
    
    
    vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[UpCurve]-(-1)-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(UpCurve)];
    
    [Bubble addConstraints:vertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for DownCurve. It should be at a 0 distance from right and bottom of superview and -20 distance from Main on the left. Its superview is Bubble. The height and width should be 25 and 50 respectively.
    
    height = [NSLayoutConstraint constraintWithItem:DownCurve attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:25.0f];
    
    width = [NSLayoutConstraint constraintWithItem:DownCurve attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:50.0f];
    
    
    [Bubble addConstraints:@[height,width]];
    
    
    vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[DownCurve]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(DownCurve)];
    
    [Bubble addConstraints:vertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for HidingLayerSide. Superview is Bubble. Right and bottom distances should be 0 and top should be greater than 0. Height and Width are 32 and 15 respectively.
    
    height = [NSLayoutConstraint constraintWithItem:HidingLayerSide attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:32.0f];
    
    width = [NSLayoutConstraint constraintWithItem:HidingLayerSide attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:15.0f];
    
    
    vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[HidingLayerSide]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(HidingLayerSide)];
    
    [Bubble addConstraints:@[height,width]];
    
    [Bubble addConstraints:vertical];
    
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for HidingLayerTop. Superview is Bubble. Right, left and top distances should be 0 and bottom should be 20.
    
    
    vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-0-[HidingLayerTop]-20-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(HidingLayerTop)];
    
    
    [Bubble addConstraints:vertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting constraints for chatUserImage. Its superview is Bubble. It should be at 0 distance from right and bottom of superview and 5 distance from Main. Height and width should be 25 and 25.
    
    height = [NSLayoutConstraint constraintWithItem:chatUserImage attribute:NSLayoutAttributeHeight relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:25.0f];
    
    width = [NSLayoutConstraint constraintWithItem:chatUserImage attribute:NSLayoutAttributeWidth relatedBy:NSLayoutRelationEqual toItem:nil attribute:NSLayoutAttributeNotAnAttribute multiplier:1.f constant:25.0f];
    
    
    vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatUserImage]-0-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(chatUserImage)];
    
    [Bubble addConstraints:@[height,width]];
    
    [Bubble addConstraints:vertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting the constraints for chatNameLabel. It should be at 16 distance from right and left of superview, i.e., Main and 8 distance from top and chatMessageLabel which is at 8 distance from chatTimeLabel which is at 8 distance from bottom of superview.
    
    // ////////////////////////////////////////////////////////////////////////////////////////////

    
    //Setting the constraints for chatNameLabel. It should be at 16 distance from right and left of superview, i.e., Main and 8 distance from top and chatMessageLabel which is at 8 distance from chatTimeLabel which is at 8 distance from bottom of superview.
    
    vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[chatMessageLabel]-8-[chatTimeLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chatMessageLabel,chatTimeLabel)];
    //  vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[chatMessageLabel]-8-[chatTimeLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chatMessageLabel,chatTimeLabel)];
    
    [Main addConstraints:vertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    self.contentView.backgroundColor = [UIColor clearColor];

    
    Bubble.backgroundColor = [UIColor clearColor];
    Main.backgroundColor = [UIColor clearColor];
    
    UpCurve.backgroundColor = [UIColor clearColor];
    UpCurve.hidden = YES;
    
    HidingLayerTop.backgroundColor = [UIColor orangeColor];
    HidingLayerTop.hidden = YES;
    
    HidingLayerSide.backgroundColor = [UIColor clearColor];
    HidingLayerSide.hidden = YES;
    
    chatTimeLabel.textAlignment = NSTextAlignmentRight;
    [chatMessageLabel setPreferredMaxLayoutWidth:220.0f];
    
    UILongPressGestureRecognizer *longGesture = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(onCellLongGesturePressed:)];
    [Bubble addGestureRecognizer: longGesture];
    
    return self;
}

-  (void)onCellLongGesturePressed:(UILongPressGestureRecognizer*)sender {
    if (sender.state == UIGestureRecognizerStateBegan){
        [[NSNotificationCenter defaultCenter] postNotificationName:@"longGestureOnMessage"
                                                            object:messageId];
    }
}

-(void)layoutSubviews
{
//    CGSize size = chatMessageLabel.superview.frame.size;
//    [chatMessageLabel setCenter:CGPointMake(size.width/2, size.height/2)];
    
    Main.layer.cornerRadius = 10.0f;
    UpCurve.layer.cornerRadius = 10.0f;
    DownCurve.layer.cornerRadius = 25.0f;
    chatUserImage.layer.cornerRadius = 12.5f;
    chatUserImage.layer.masksToBounds = YES;
}

- (void)updateFramesForAuthorType:(AuthorType)type
{
    
    if(type == iMessageBubbleTableViewCellAuthorTypeSender)
    {
        //Setting constraints for Bubble. It should be at a zero distance from top, bottom and 8 distance right hand side of the superview, i.e., self.contentView (The default superview for all tableview cell elements)
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[Bubble]-8-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(Bubble)];
        
        
        [self.contentView addConstraints:horizontal];

        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for Main block. It contains name, message and time labels. Main should be at a zero distance from bottom and left of its superview, i.e., Bubble
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[Main]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(Main)];
        
        
        [Bubble addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting constraints for UpCurve. It should be at zero distance from Main on left side, -1 distance from bottom and 10 distance from right of the superview, i.e., Bubble. Height and Width should be 32 and 20 respectively
        
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[Main]-0-[UpCurve]-10-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(Main,UpCurve)];
        
        
        [Bubble addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting constraints for DownCurve. It should be at a 0 distance from right and bottom of superview and -20 distance from Main on the left. Its superview is Bubble. The height and width should be 25 and 50 respectively.
        
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[Main]-(-20)-[DownCurve]-(0)-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(Main,DownCurve)];
        
        [Bubble addConstraints:horizontal];

        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting constraints for HidingLayerSide. Superview is Bubble. Right and bottom distances should be 0 and top should be greater than 0. Height and Width are 32 and 15 respectively.
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[HidingLayerSide]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(HidingLayerSide)];
        
        [Bubble addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting constraints for HidingLayerTop. Superview is Bubble. Right, left and top distances should be 0 and bottom should be 20.
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[HidingLayerTop]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(HidingLayerTop)];
        
        
        
        [Bubble addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting constraints for chatUserImage. Its superview is Bubble. It should be at 0 distance from right and bottom of superview and 5 distance from Main. Height and width should be 25 and 25.
        
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[Main]-5-[chatUserImage]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(Main,chatUserImage)];
        
        [Bubble addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        //Setting the constraints for chatTimeLabel. It should be 16 distance from right and left of superview, i.e., Main.
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[chatTimeLabel]-8-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatTimeLabel)];
        [Main addConstraints:horizontal];
        
        //  status
        NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[chatMessageStatus]-5-[chatMessageBurn]-5-[chatTimeLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chatMessageStatus, chatMessageBurn, chatTimeLabel)];
        
        NSArray *constraint_POS_V  = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatMessageStatus]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chatMessageStatus)];
        
        NSArray *tmpWidth = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[chatMessageStatus(16.5)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatMessageStatus)];
        
        NSArray *tmpHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatMessageStatus(16.5)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatMessageStatus)];
        
        [Main addConstraints:constraint_POS_H];
        [Main addConstraints:constraint_POS_V];
        [Main addConstraints:tmpWidth];
        [Main addConstraints:tmpHeight];
        
        //  message burn
        NSArray *tmpWidthBurn = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[chatMessageBurn(16.5)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatMessageBurn)];
        
        NSArray *tmpHeightBurn  = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatMessageBurn(16.5)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatMessageBurn)];
        
        NSArray *constraint_POS_V_BURN  = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatMessageBurn]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chatMessageBurn)];
        
        [Main addConstraints:tmpWidthBurn];
        [Main addConstraints:tmpHeightBurn];
        [Main addConstraints:constraint_POS_V_BURN];
        
        vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[chatMessageLabel]-8-[chatTimeLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chatMessageLabel,chatTimeLabel)];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting the constraints for chatMessageLabel. It should be 16 distance from right and left of superview, i.e., Main.
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[chatMessageLabel]-8-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatMessageLabel)];
        
        [Main addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        if(![chatCellSettings getSenderBubbleTail])
        {
            [DownCurve setHidden:YES];
            [UpCurve setHidden:YES];
        }
        else
        {
            [DownCurve setHidden:NO];
            [UpCurve setHidden:NO];
        }
        
        
        Main.backgroundColor = [chatCellSettings getSenderBubbleColor];
        
        //  DownCurve.backgroundColor = [chatCellSettings getSenderBubbleColor];
        DownCurve.backgroundColor = [UIColor clearColor];
        
        NSArray *textColor = [chatCellSettings getSenderBubbleTextColor];
        
        chatMessageLabel.textColor = textColor[1];
        chatTimeLabel.textColor = textColor[2];
        
        NSArray *fontWithSize = [chatCellSettings getSenderBubbleFontWithSize];
        
        chatMessageLabel.font = fontWithSize[1];
        chatTimeLabel.font = fontWithSize[2];
    }
    else
    {
        //Setting constraints for Bubble. It should be at a zero distance from top, bottom and 8 distance from left hand side of the superview, i.e., self.contentView (The default superview for all tableview cell elements)
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[Bubble]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(Bubble)];
        
        
        [self.contentView addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for Main block. It contains name, message and time labels. Main should be at a zero distance from bottom and right of its superview, i.e., Bubble
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[Main]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(Main)];
        
        [Bubble addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for UpCurve. It should be at zero distance from Main on right side, -1 distance from bottom and 10 distance from left of the superview, i.e., Bubble. Height and Width should be 32 and 20 respectively
        
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-10-[UpCurve]-0-[Main]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(UpCurve,Main)];
        
        
        [Bubble addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for DownCurve. It should be at a 0 distance from left and bottom of superview and -20 distance from Main on the right. Its superview is Bubble. The height and width should be 25 and 50 respectively.
        
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[DownCurve]-(-20)-[Main]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(DownCurve,Main)];
        
        [Bubble addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for HidingLayerSide. Superview is Bubble. Left and bottom distances should be 0 and top should be greater than 0. Height and Width are 32 and 15 respectively.
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[HidingLayerSide]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(HidingLayerSide)];
        
        vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-(>=0)-[HidingLayerSide]-0-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(HidingLayerSide)];
        
        
        [Bubble addConstraints:horizontal];
        
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for HidingLayerTop. Superview is Bubble. Right, left and top distances should be 0 and bottom should be 20.
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[HidingLayerTop]-0-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(HidingLayerTop)];
        
        
        
        [Bubble addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting constraints for chatUserImage. Its superview is Bubble. It should be at 0 distance from left and bottom of superview and 5 distance from Main on the right. Height and width should be 25 and 25.
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-0-[chatUserImage]-5-[Main]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatUserImage,Main)];
        
        vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatUserImage]-0-|" options:NSLayoutFormatAlignAllBottom metrics:nil views:NSDictionaryOfVariableBindings(chatUserImage)];
        
        
        [Bubble addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting the constraints for chatTimeLabel. It should be 16 distance from right and left of superview, i.e., Main.
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-50-[chatTimeLabel]-8-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatTimeLabel)];
        
        [Main addConstraints:horizontal];
        
        NSArray *constraint_POS_H = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[chatMessageStatus]-5-[chatMessageBurn]-5-[chatTimeLabel]" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chatMessageStatus, chatMessageBurn, chatTimeLabel)];
        NSArray *constraint_POS_V  = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatMessageStatus]-5-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chatMessageStatus)];
        
        NSArray *tmpWidth = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[chatMessageStatus(16.5)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatMessageStatus)];
        
        NSArray *tmpHeight = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatMessageStatus(16.5)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatMessageStatus)];
        [Main addConstraints:tmpWidth];
        [Main addConstraints:tmpHeight];
        
        vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[chatMessageLabel]-8-[chatTimeLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chatMessageLabel,chatTimeLabel)];
        
        NSArray *tmpWidthBurn = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[chatMessageBurn(16.5)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatMessageBurn)];
        
        NSArray *tmpHeightBurn = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatMessageBurn(16.5)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatMessageBurn)];
        
        [Main addConstraints:constraint_POS_H];
        [Main addConstraints:constraint_POS_V];
        [Main addConstraints:tmpWidthBurn];
        [Main addConstraints:tmpHeightBurn];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////
        
        //Setting the constraints for chatMessageLabel. It should be 16 distance from right and left of superview, i.e., Main.
        
        horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[chatMessageLabel]-8-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatMessageLabel)];
        
        [Main addConstraints:horizontal];
        
        // /////////////////////////////////////////////////////////////////////////////////////////////

        if(![chatCellSettings getReceiverBubbleTail])
        {
            [DownCurve setHidden:YES];
            [UpCurve setHidden:YES];
        }
        else
        {
            [DownCurve setHidden:NO];
            [UpCurve setHidden:NO];
        }
        
        Main.backgroundColor = [chatCellSettings getReceiverBubbleColor];
        
//          DownCurve.backgroundColor = [chatCellSettings getReceiverBubbleColor];
        DownCurve.backgroundColor = [UIColor clearColor];
        
        NSArray *textColor = [chatCellSettings getReceiverBubbleTextColor];
        
        chatMessageLabel.textColor = textColor[1];
        chatTimeLabel.textColor = textColor[2];
        
        NSArray *fontWithSize = [chatCellSettings getReceiverBubbleFontWithSize];
        
        chatMessageLabel.font = fontWithSize[1];
        chatTimeLabel.font = fontWithSize[2];
    }
}

- (void)setAuthorType:(AuthorType)type
{
    _authorType = type;
    [self updateFramesForAuthorType:_authorType];
}

@end