//
//  ChatTableViewCell.m
//  test
//
//  Created by iFlyLabs on 06/04/15.
//  Copyright (c) 2015 iFlyLabs. All rights reserved.
//

#import "GroupChatLeftMediaTableViewCell.h"
#import "ChatCellSettings.h"

@interface GroupChatLeftMediaTableViewCell ()

@property (strong, nonatomic) UIView *Bubble;
@property (strong, nonatomic) UIView *Main;
@property (strong, nonatomic) UIView *UpCurve;
@property (strong, nonatomic) UIView *DownCurve;
@property (strong, nonatomic) UIView *HidingLayerTop;
@property (strong, nonatomic) UIView *HidingLayerSide;

@end

@implementation GroupChatLeftMediaTableViewCell

@synthesize Bubble;
@synthesize Main;
@synthesize UpCurve;
@synthesize DownCurve;
@synthesize HidingLayerTop;
@synthesize HidingLayerSide;
@synthesize chatUserImage;
@synthesize chatNameLabel;
@synthesize chatTimeLabel;
@synthesize chatMessageImage;
@synthesize playVideoImage;
@synthesize delegate, messageEvent;

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
    
    chatNameLabel = [[UILabel alloc] init];
    [chatNameLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    chatTimeLabel = [[UILabel alloc] init];
    [chatTimeLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    chatMessageImage = [[UIImageView alloc] init];
    [chatMessageImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    UITapGestureRecognizer *tapOnPicture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(whenTapOnPictureMessage)];
    chatMessageImage.userInteractionEnabled = YES;
    [chatMessageImage addGestureRecognizer: tapOnPicture];
    
    playVideoImage = [[UIImageView alloc] init];
    playVideoImage.image = [UIImage imageNamed:@"play-button"];
    [playVideoImage setTranslatesAutoresizingMaskIntoConstraints:NO];
    
    [self.contentView addSubview:Bubble];
    
    [Bubble addSubview:DownCurve];
    [Bubble addSubview:HidingLayerTop];
    [Bubble addSubview:Main];
    [Bubble addSubview:UpCurve];
    [Bubble addSubview:HidingLayerSide];
    [Bubble addSubview:chatUserImage];
    
    [Main addSubview:chatNameLabel];
    [Main addSubview:chatTimeLabel];
    [Main addSubview:chatMessageImage];
    [Main addSubview:playVideoImage];
    
    chatUserImage.image = [UIImage imageNamed:@"defaultUser.png"];
    chatNameLabel.text = @"chatNameLabel";
    
    chatTimeLabel.text = @"chatTimeLabel";
    
    chatMessageImage.image = [UIImage imageNamed:@"unloaded"];
    
    [chatNameLabel setNumberOfLines:1];
    [chatTimeLabel setNumberOfLines:1];
    
    chatNameLabel.lineBreakMode = NSLineBreakByClipping;
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
    
    
    horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[chatNameLabel]-8-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatNameLabel)];
    
    
    [Main addConstraints:horizontal];
    
    // ////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting width constraint for chatNameLabel
    
    NSLayoutConstraint *proportionalWidth = [NSLayoutConstraint constraintWithItem:chatNameLabel
                                                         attribute:NSLayoutAttributeWidth
                                                         relatedBy:NSLayoutRelationEqual
                                                            toItem:Main
                                                         attribute:NSLayoutAttributeWidth
                                                        multiplier:.5
                                                          constant:0];
    
    proportionalWidth.priority = 750;
    
    
    [Main addConstraint:proportionalWidth];
    
    [chatNameLabel setContentCompressionResistancePriority:250 forAxis:UILayoutConstraintAxisHorizontal];
    
    // ////////////////////////////////////////////////////////////////////////////////////////////

    
    //Setting the constraints for chatNameLabel. It should be at 16 distance from right and left of superview, i.e., Main and 8 distance from top and chatMessageLabel which is at 8 distance from chatTimeLabel which is at 8 distance from bottom of superview.
    
    vertical = [NSLayoutConstraint constraintsWithVisualFormat:@"V:|-8-[chatNameLabel]-8-[chatMessageImage]-8-[chatTimeLabel]-8-|" options:0 metrics:nil views:NSDictionaryOfVariableBindings(chatNameLabel, chatMessageImage,chatTimeLabel)];
    
    [Main addConstraints:vertical];
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    self.contentView.backgroundColor = [UIColor clearColor];
    
    Bubble.backgroundColor = [UIColor clearColor];
    Main.backgroundColor = [UIColor clearColor];
    
    UpCurve.backgroundColor = [UIColor clearColor];
    
    HidingLayerTop.backgroundColor = [UIColor clearColor];
    
    HidingLayerSide.backgroundColor = [UIColor clearColor];
    
    chatTimeLabel.textAlignment = NSTextAlignmentRight;
    
    return self;
}

-(void)layoutSubviews
{
//    CGSize size = chatMessageImage.superview.frame.size;
//    [chatMessageImage setCenter:CGPointMake(size.width/2, size.height/2)];
    
    Main.layer.cornerRadius = 10.0f;
    UpCurve.layer.cornerRadius = 10.0f;
    DownCurve.layer.cornerRadius = 25.0f;
    chatUserImage.layer.cornerRadius = 12.5f;
    chatUserImage.layer.masksToBounds = YES;
}

- (void)updateFramesForAuthorType:(AuthorType)type
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
    
    horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-35-[chatTimeLabel]-8-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatTimeLabel)];
    
    [Main addConstraints:horizontal];
    
    
    // /////////////////////////////////////////////////////////////////////////////////////////////
    
    //Setting the constraints for chatMessageLabel. It should be 16 distance from right and left of superview, i.e., Main.
    
    horizontal = [NSLayoutConstraint constraintsWithVisualFormat:@"H:|-8-[chatMessageImage]-8-|" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(chatMessageImage)];
    
    [Main addConstraints:horizontal];
    
    //  play button
    NSArray *tmpWidthPlayVideo = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[playVideoImage(40)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(playVideoImage)];
    
    NSArray *tmpHeighttmpWidthPlayVideo = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[playVideoImage(40)]" options:NSLayoutFormatDirectionLeftToRight metrics:nil views:NSDictionaryOfVariableBindings(playVideoImage)];
    
    [Main addConstraints:tmpWidthPlayVideo];
    [Main addConstraints:tmpHeighttmpWidthPlayVideo];
    
    NSLayoutConstraint *xCenterConstraint = [NSLayoutConstraint constraintWithItem:playVideoImage attribute:NSLayoutAttributeCenterX relatedBy:NSLayoutRelationEqual toItem:chatMessageImage attribute:NSLayoutAttributeCenterX multiplier:1.0 constant:0];
    [Main addConstraint:xCenterConstraint];
    
    NSLayoutConstraint *yCenterConstraint = [NSLayoutConstraint constraintWithItem:playVideoImage attribute:NSLayoutAttributeCenterY relatedBy:NSLayoutRelationEqual toItem:chatMessageImage attribute:NSLayoutAttributeCenterY multiplier:1.0 constant:0];
    [Main addConstraint:yCenterConstraint];
    
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
    
    //  DownCurve.backgroundColor = [chatCellSettings getReceiverBubbleColor];
    DownCurve.backgroundColor = [UIColor clearColor];
    
    NSArray *textColor = [chatCellSettings getReceiverBubbleTextColor];
    
    chatNameLabel.textColor = textColor[0];
    chatTimeLabel.textColor = textColor[2];
    
    NSArray *fontWithSize = [chatCellSettings getReceiverBubbleFontWithSize];
    
    chatNameLabel.font = fontWithSize[0];
    chatTimeLabel.font = fontWithSize[2];
    
    NSArray *constraint_H = [NSLayoutConstraint constraintsWithVisualFormat:@"V:[chatMessageImage(150)]"
                                                                    options:0 metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(chatMessageImage)];
    [Main addConstraints: constraint_H];
    
    NSArray *constraint_V = [NSLayoutConstraint constraintsWithVisualFormat:@"H:[chatMessageImage(150)]"
                                                                    options:0 metrics:nil
                                                                      views:NSDictionaryOfVariableBindings(chatMessageImage)];
    [Main addConstraints: constraint_V];
}

- (void)setAuthorType:(AuthorType)type
{
    _authorType = type;
    [self updateFramesForAuthorType:_authorType];
}

- (void)whenTapOnPictureMessage {
    [delegate clickOnPictureOfMessage: messageEvent];
}

@end
