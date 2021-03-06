/* LinphoneAppDelegate.m
 *
 * Copyright (C) 2009  Belledonne Comunications, Grenoble, France
 *
 *  This program is free software; you can redistribute it and/or modify
 *  it under the terms of the GNU General Public License as published by
 *  the Free Software Foundation; either version 2 of the License, or
 *  (at your option) any later version.
 *
 *  This program is distributed in the hope that it will be useful,
 *  but WITHOUT ANY WARRANTY; without even the implied warranty of
 *  MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 *  GNU General Public License for more details.
 *
 *  You should have received a copy of the GNU General Public License
 *  along with this program; if not, write to the Free Software
 *  Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA 02111-1307, USA.
 */

#import "PhoneMainView.h"
#import "ContactsListView.h"
#import "ContactDetailsView.h"
#import "ShopView.h"
#import "LinphoneAppDelegate.h"
#import "AddressBook/ABPerson.h"

#import "CoreTelephony/CTCallCenter.h"
#import "CoreTelephony/CTCall.h"

#import "LinphoneCoreSettingsStore.h"

#include "LinphoneManager.h"
#include "linphone/linphonecore.h"

#import "ContactObject.h"
#import "ContactDetailObj.h"
#import "NSDatabase.h"
#import "JSONKit.h"
#import "AppUtils.h"
#import "PBXContact.h"
#include <Intents/INInteraction.h>

#import <Fabric/Fabric.h>
#import <Crashlytics/Crashlytics.h>
#import "OTRConstants.h"
#import "RoomObject.h"
#import "NSData+Base64.h"
#import "MainChatViewController.h"
#import "GroupMainChatViewController.h"
#import "XMPPRoom.h"
#import "LoadingViewController.h"

#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)  ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

@interface LinphoneAppDelegate (){
    Reachability* hostReachable;
    NSArray *listNumber;
    
    ABAddressBookRef addressListBook;
    NSThread *getContactThread;
    NSThread *addContactThread;
}
@end

@implementation LinphoneAppDelegate

@synthesize configURL;
@synthesize window;

@synthesize _internetActive, _internetReachable;
@synthesize localization;
@synthesize _hRegistrationState, _hStatus, _hHeader, _wSubMenu, _hTabbar;
@synthesize _deviceToken, _updateTokenSuccess;
@synthesize _listFace, _listPlace, _listNature, _listObject, _listSymbol;
@synthesize _meEnded;
@synthesize _acceptCall;
@synthesize listContacts, sipContacts, pbxContacts;
@synthesize idContact;
@synthesize _database, _databasePath, _threadDatabase;
@synthesize _busyForCall;
@synthesize _recordFile, _hasRecordCall;
@synthesize _newContact;
@synthesize _cropAvatar, _dataCrop;
@synthesize fromImagePicker;
@synthesize _isSyncing;
@synthesize _chooseMyAvatar, userImage, xmppStream, _resource, _xmppIncomingFileTransfer, friendBuddy, myBuddy;
@synthesize _cloudfoneRequestSent;
@synthesize idRoomChat, roomChatName, _groupNameChange;
@synthesize _listFriends, _statusXMPPDict, idVideoMessage, typeBubbleTouch, lastRowVisibleChat;
@synthesize reloadMessageList;
@synthesize imageChooseName, titleCaption, imageChoose, _heightChatTbView;
@synthesize _msgForward, msgHisForward, idMessageRecall, imageCapture, photoGroup;
@synthesize _allPhonesDict, _allIDDict, contactLoaded, _strRequestFriend, supportGroupChat, bgTimer;
@synthesize webService, keepAwakeTimer;

#pragma mark - Lifecycle Functions

- (id)init {
	self = [super init];
	if (self != nil) {
		startedInBackground = FALSE;
	}
	return self;
	[[UIApplication sharedApplication] setDelegate:self];
}

#pragma mark -

- (void)applicationDidEnterBackground:(UIApplication *)application {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	//  [LinphoneManager.instance enterBackgroundMode];
}

- (void)applicationWillResignActive:(UIApplication *)application {
	NSLog(@"%@", NSStringFromSelector(_cmd));
	LinphoneCall *call = linphone_core_get_current_call(LC);

	if (call) {
		/* save call context */
		LinphoneManager *instance = LinphoneManager.instance;
		instance->currentCallContextBeforeGoingBackground.call = call;
		instance->currentCallContextBeforeGoingBackground.cameraIsEnabled = linphone_call_camera_enabled(call);

		const LinphoneCallParams *params = linphone_call_get_current_params(call);
		if (linphone_call_params_video_enabled(params)) {
			linphone_call_enable_camera(call, false);
		}
	}

	if (![LinphoneManager.instance resignActive]) {
	}
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
	NSLog(@"%@", NSStringFromSelector(_cmd));
    
    NSString *goHistoryCall = [[NSUserDefaults standardUserDefaults] objectForKey:@"isGoToHistoryCall"];
    if (goHistoryCall != nil && [goHistoryCall isEqualToString:@"YES"]) {
        //  reset value
        [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isGoToHistoryCall"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        if (![PhoneMainView.instance.currentView isEqual: CallsHistoryViewController.compositeViewDescription]) {
            //  Di chuyen den view history neu nguoi dung click vao history tu dien thoai de mo app
            [PhoneMainView.instance changeCurrentView:CallsHistoryViewController.compositeViewDescription];
        }
    }
    
	if (startedInBackground) {
		startedInBackground = FALSE;
		[PhoneMainView.instance startUp];
		[PhoneMainView.instance updateStatusBar:nil];
	}
	LinphoneManager *instance = LinphoneManager.instance;
	[instance becomeActive];
	
	if (instance.fastAddressBook.needToUpdate) {
		//Update address book for external changes
		if (PhoneMainView.instance.currentView == ContactsListView.compositeViewDescription || PhoneMainView.instance.currentView == ContactDetailsView.compositeViewDescription) {
			[PhoneMainView.instance changeCurrentView:DialerView.compositeViewDescription];
		}
		[instance.fastAddressBook reload];
		instance.fastAddressBook.needToUpdate = FALSE;
		const MSList *lists = linphone_core_get_friends_lists(LC);
		while (lists) {
			linphone_friend_list_update_subscriptions(lists->data);
			lists = lists->next;
		}
	}

	LinphoneCall *call = linphone_core_get_current_call(LC);

	if (call) {
		if (call == instance->currentCallContextBeforeGoingBackground.call) {
			const LinphoneCallParams *params = linphone_call_get_current_params(call);
			if (linphone_call_params_video_enabled(params)) {
				linphone_call_enable_camera(call, instance->currentCallContextBeforeGoingBackground.cameraIsEnabled);
			}
			instance->currentCallContextBeforeGoingBackground.call = 0;
		} else if (linphone_call_get_state(call) == LinphoneCallIncomingReceived) {
			LinphoneCallAppData *data = (__bridge LinphoneCallAppData *)linphone_call_get_user_data(call);
			if (data && data->timer) {
				[data->timer invalidate];
				data->timer = nil;
			}
			if ((floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max)) {
				if ([LinphoneManager.instance lpConfigBoolForKey:@"autoanswer_notif_preference"]) {
					linphone_core_accept_call(LC, call);
					[PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
				} else {
					[PhoneMainView.instance displayIncomingCall:call];
				}
			} else if (linphone_core_get_calls_nb(LC) > 1) {
				[PhoneMainView.instance displayIncomingCall:call];
			}

			// in this case, the ringing sound comes from the notification.
			// To stop it we have to do the iOS7 ring fix...
			[self fixRing];
		}
	}
	[LinphoneManager.instance.iapManager check];
}

#pragma deploymate push "ignored-api-availability"
- (UIUserNotificationCategory *)getMessageNotificationCategory {
	NSArray *actions;

	if ([[UIDevice.currentDevice systemVersion] floatValue] < 9 ||
		[LinphoneManager.instance lpConfigBoolForKey:@"show_msg_in_notif"] == NO) {

		UIMutableUserNotificationAction *reply = [[UIMutableUserNotificationAction alloc] init];
		reply.identifier = @"reply";
		reply.title = NSLocalizedString(@"Reply", nil);
		reply.activationMode = UIUserNotificationActivationModeForeground;
		reply.destructive = NO;
		reply.authenticationRequired = YES;

		UIMutableUserNotificationAction *mark_read = [[UIMutableUserNotificationAction alloc] init];
		mark_read.identifier = @"mark_read";
		mark_read.title = NSLocalizedString(@"Mark Read", nil);
		mark_read.activationMode = UIUserNotificationActivationModeBackground;
		mark_read.destructive = NO;
		mark_read.authenticationRequired = NO;

		actions = @[ mark_read, reply ];
	} else {
		// iOS 9 allows for inline reply. We don't propose mark_read in this case
		UIMutableUserNotificationAction *reply_inline = [[UIMutableUserNotificationAction alloc] init];

		reply_inline.identifier = @"reply_inline";
		reply_inline.title = NSLocalizedString(@"Reply", nil);
		reply_inline.activationMode = UIUserNotificationActivationModeBackground;
		reply_inline.destructive = NO;
		reply_inline.authenticationRequired = NO;
		reply_inline.behavior = UIUserNotificationActionBehaviorTextInput;

		actions = @[ reply_inline ];
	}

	UIMutableUserNotificationCategory *localRingNotifAction = [[UIMutableUserNotificationCategory alloc] init];
	localRingNotifAction.identifier = @"incoming_msg";
	[localRingNotifAction setActions:actions forContext:UIUserNotificationActionContextDefault];
	[localRingNotifAction setActions:actions forContext:UIUserNotificationActionContextMinimal];

	return localRingNotifAction;
}

- (UIUserNotificationCategory *)getCallNotificationCategory {
	UIMutableUserNotificationAction *answer = [[UIMutableUserNotificationAction alloc] init];
	answer.identifier = @"answer";
	answer.title = NSLocalizedString(@"Answer", nil);
	answer.activationMode = UIUserNotificationActivationModeForeground;
	answer.destructive = NO;
	answer.authenticationRequired = YES;
    
	UIMutableUserNotificationAction *decline = [[UIMutableUserNotificationAction alloc] init];
	decline.identifier = @"decline";
	decline.title = NSLocalizedString(@"Decline", nil);
	decline.activationMode = UIUserNotificationActivationModeBackground;
	decline.destructive = YES;
	decline.authenticationRequired = NO;

	NSArray *localRingActions = @[ decline, answer ];

	UIMutableUserNotificationCategory *localRingNotifAction = [[UIMutableUserNotificationCategory alloc] init];
	localRingNotifAction.identifier = @"incoming_call";
	[localRingNotifAction setActions:localRingActions forContext:UIUserNotificationActionContextDefault];
	[localRingNotifAction setActions:localRingActions forContext:UIUserNotificationActionContextMinimal];

	return localRingNotifAction;
}

- (UIUserNotificationCategory *)getAccountExpiryNotificationCategory {
	
	UIMutableUserNotificationCategory *expiryNotification = [[UIMutableUserNotificationCategory alloc] init];
	expiryNotification.identifier = @"expiry_notification";
	return expiryNotification;
}


- (void)registerForNotifications:(UIApplication *)app {
	self.voipRegistry = [[PKPushRegistry alloc] initWithQueue:dispatch_get_main_queue()];
	self.voipRegistry.delegate = self;

	// Initiate registration.
	self.voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];

	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
		// Call category
		UNNotificationAction *act_ans =
			[UNNotificationAction actionWithIdentifier:@"Answer"
												 title:NSLocalizedString(@"Answer", nil)
											   options:UNNotificationActionOptionForeground];
		UNNotificationAction *act_dec = [UNNotificationAction actionWithIdentifier:@"Decline"
																			 title:NSLocalizedString(@"Decline", nil)
																		   options:UNNotificationActionOptionNone];
		UNNotificationCategory *cat_call =
			[UNNotificationCategory categoryWithIdentifier:@"call_cat"
												   actions:[NSArray arrayWithObjects:act_ans, act_dec, nil]
										 intentIdentifiers:[[NSMutableArray alloc] init]
												   options:UNNotificationCategoryOptionCustomDismissAction];

		// Msg category
		UNTextInputNotificationAction *act_reply =
			[UNTextInputNotificationAction actionWithIdentifier:@"Reply"
														  title:NSLocalizedString(@"Reply", nil)
														options:UNNotificationActionOptionNone];
		UNNotificationAction *act_seen =
			[UNNotificationAction actionWithIdentifier:@"Seen"
												 title:NSLocalizedString(@"Mark as seen", nil)
											   options:UNNotificationActionOptionNone];
		UNNotificationCategory *cat_msg =
			[UNNotificationCategory categoryWithIdentifier:@"msg_cat"
												   actions:[NSArray arrayWithObjects:act_reply, act_seen, nil]
										 intentIdentifiers:[[NSMutableArray alloc] init]
												   options:UNNotificationCategoryOptionCustomDismissAction];

		// Video Request Category
		UNNotificationAction *act_accept =
			[UNNotificationAction actionWithIdentifier:@"Accept"
												 title:NSLocalizedString(@"Accept", nil)
											   options:UNNotificationActionOptionForeground];

		UNNotificationAction *act_refuse = [UNNotificationAction actionWithIdentifier:@"Cancel"
																				title:NSLocalizedString(@"Cancel", nil)
																			  options:UNNotificationActionOptionNone];
		UNNotificationCategory *video_call =
			[UNNotificationCategory categoryWithIdentifier:@"video_request"
												   actions:[NSArray arrayWithObjects:act_accept, act_refuse, nil]
										 intentIdentifiers:[[NSMutableArray alloc] init]
												   options:UNNotificationCategoryOptionCustomDismissAction];

		// ZRTP verification category
		UNNotificationAction *act_confirm = [UNNotificationAction actionWithIdentifier:@"Confirm"
																				 title:NSLocalizedString(@"Accept", nil)
																			   options:UNNotificationActionOptionNone];

		UNNotificationAction *act_deny = [UNNotificationAction actionWithIdentifier:@"Deny"
																			  title:NSLocalizedString(@"Deny", nil)
																			options:UNNotificationActionOptionNone];
		UNNotificationCategory *cat_zrtp =
			[UNNotificationCategory categoryWithIdentifier:@"zrtp_request"
												   actions:[NSArray arrayWithObjects:act_confirm, act_deny, nil]
										 intentIdentifiers:[[NSMutableArray alloc] init]
												   options:UNNotificationCategoryOptionCustomDismissAction];
		[UNUserNotificationCenter currentNotificationCenter].delegate = self;
		[[UNUserNotificationCenter currentNotificationCenter]
			requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound |
											 UNAuthorizationOptionBadge)
						  completionHandler:^(BOOL granted, NSError *_Nullable error) {
							// Enable or disable features based on authorization.
							if (error) {
								LOGD(error.description);
							}
						  }];
		NSSet *categories = [NSSet setWithObjects:cat_call, cat_msg, video_call, cat_zrtp, nil];
		[[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
	}
}
#pragma deploymate pop

void onUncaughtException(NSException* exception)
{
    NSString *crashContent = [NSString stringWithFormat:@"%@",[exception callStackSymbols]];
    NSString *device = [AppUtils getDeviceNameFromModelName:[AppUtils getDeviceModel]];
    NSString *osVersion = [AppUtils getCurrentOSVersionOfDevice];
    NSString *appVersion = [AppUtils getCurrentVersionApplicaton];
    NSString *bundleIdentifier = [[NSBundle mainBundle] bundleIdentifier];
    
    NSString *messageSend = [NSString stringWithFormat:@"------------------------------\nDevice: %@\nOS Version: %@\nApp version: %@\nApp bundle ID: %@\n------------------------------\nAccount ID: %@\n------------------------------\nReason: %@\n------------------------------\n%@", device, osVersion, appVersion, bundleIdentifier, USERNAME, exception.reason, crashContent];
    
    NSString *totalEmail = [NSString stringWithFormat:@"mailto:%@?subject=%@&body=%@", @"lekhai0212@gmail.com,cfreport@cloudfone.vn", [NSString stringWithFormat:@"Report crash from %@", USERNAME], messageSend];
    NSString *url = [totalEmail stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [[UIApplication sharedApplication]  openURL: [NSURL URLWithString: url]];
}

- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
    UIApplication *app = [UIApplication sharedApplication];
	UIApplicationState state = app.applicationState;
    
    NSSetUncaughtExceptionHandler(&onUncaughtException);
    
    //  Khoi tao
    webService = [[WebServices alloc] init];
    webService.delegate = self;
    
    //  Tạo folder cho ghi âm cuộc gọi
    [self createFolderRecordsIfNotExists: folder_call_records];
    
    // Copy database and connect
    [self copyFileDataToDocument:@"callnex.sqlite"];
    [NSDatabase connectCallnexDB];
    
    //  Ghi âm cuộc gọi
    _hasRecordCall = false;
    _recordFile = @"";
    _isSyncing = false;
    idMessageRecall = @"";
    supportGroupChat = YES;
    self.xmppChatRooms = [[NSMutableArray alloc] init];
    
    _allPhonesDict = [[NSMutableDictionary alloc] init];
    _allIDDict = [[NSMutableDictionary alloc] init];
    
    // check for internet connection
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(checkNetworkStatus:)
                                                 name:kReachabilityChangedNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(reloadContactListAfterAddSuccess)
                                                 name:@"reloadContactAfterAdd" object:nil];
    
    //  Đăng nhập vào xmpp service
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(protocolLoginFailed:)
                                                 name:kOTRProtocolLoginFail object:nil ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(protocolLoginSuccess:)
                                                 name:kOTRProtocolLoginSuccess object:nil ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinedGroupChat:)
                                                 name:k11JoinGroupChatSuccessfully object:nil ];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(joinAllGroupGetFromServer)
                                                 name:getAllGroupsForAccountSuccessful object:nil ];
    
    _internetReachable = [Reachability reachabilityForInternetConnection];
    [_internetReachable startNotifier];
    
    // check if a pathway to a random host exists
    hostReachable = [Reachability reachabilityWithHostName:@"www.apple.com"];
    [hostReachable startNotifier];
    
    _hStatus = [application statusBarFrame].size.height;
    
    if (SCREEN_WIDTH <= 375 && SCREEN_WIDTH > 320) {
        _hRegistrationState = 45.0;
        _wSubMenu = 60.0;
        _hTabbar = 58.0;
        _hHeader = 50.0;
    }else if (SCREEN_WIDTH > 375){
        _hRegistrationState = 45.0;
        _wSubMenu = 100.0;
        _hTabbar = 65.0;
        _hHeader = 50.0;
    }else{
        _hRegistrationState = 35.0;
        _wSubMenu = 40.0;
        _hTabbar = 50.0;
        _hHeader = 42.0;
    }
    
    idRoomChat = 0;
    roomChatName = @"";
    _groupNameChange = @"";
    
    _listFriends = [[NSMutableArray alloc] init];
    _statusXMPPDict = [[NSMutableDictionary alloc] init];
    
    listNumber = [[NSArray alloc] initWithObjects: @"+", @"0", @"1", @"2", @"3", @"4", @"5", @"6", @"7", @"8", @"9", nil];
    
    //  Set ngôn ngữ hiện tại
    NSString *curLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:language_key];
    if (curLanguage == nil) {
        [[NSUserDefaults standardUserDefaults] setObject:key_en forKey:language_key];
        [[NSUserDefaults standardUserDefaults] synchronize];
        curLanguage = [[NSUserDefaults standardUserDefaults] objectForKey:language_key];
    }
    
    localization = [HMLocalization sharedInstance];
    [localization setLanguage: curLanguage];
    
    //  Tạo resource cho phần chat
    NSString *chatResouce = [[NSUserDefaults standardUserDefaults] objectForKey: chat_resouce];
    if (chatResouce == nil || [chatResouce isEqualToString: @""]) {
        chatResouce = [NSString stringWithFormat:@"ios_%@", [AppUtils randomStringWithLength:10]];
        [[NSUserDefaults standardUserDefaults] setObject:chatResouce forKey:chat_resouce];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    _resource = chatResouce;
    
    if(SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"10.0")){
        UNUserNotificationCenter *notifiCenter = [UNUserNotificationCenter currentNotificationCenter];
        notifiCenter.delegate = self;
        [notifiCenter requestAuthorizationWithOptions:(UNAuthorizationOptionSound | UNAuthorizationOptionAlert | UNAuthorizationOptionBadge) completionHandler:^(BOOL granted, NSError * _Nullable error){
            if( !error ){
                [[UIApplication sharedApplication] registerForRemoteNotifications];
            }
        }];
    }
    
    if ([[UIApplication sharedApplication] respondsToSelector:@selector(registerForRemoteNotifications)])
    {
        UIUserNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        UIUserNotificationSettings *mySettings = [UIUserNotificationSettings settingsForTypes:types categories:nil];
        
        [[UIApplication sharedApplication] registerUserNotificationSettings:mySettings];
        [[UIApplication sharedApplication] registerForRemoteNotifications];
    } else {
        UIRemoteNotificationType types = UIUserNotificationTypeBadge | UIUserNotificationTypeSound | UIUserNotificationTypeAlert;
        [[UIApplication sharedApplication] registerForRemoteNotificationTypes:types];
    }
    
    //  List emotion
    _listFace = [[NSMutableArray alloc] init];
    _listNature = [[NSMutableArray alloc] init];
    _listObject = [[NSMutableArray alloc] init];
    _listPlace = [[NSMutableArray alloc] init];
    _listSymbol = [[NSMutableArray alloc] init];
    
    //  get list contact
    contactLoaded = NO;
    [self getContactsListForFirstLoad];
    
	LinphoneManager *instance = [LinphoneManager instance];
	BOOL background_mode = [instance lpConfigBoolForKey:@"backgroundmode_preference"];
	BOOL start_at_boot = [instance lpConfigBoolForKey:@"start_at_boot_preference"];
	[self registerForNotifications:app];

	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
		self.del = [[ProviderDelegate alloc] init];
		[LinphoneManager.instance setProviderDelegate:self.del];
	}

	if (state == UIApplicationStateBackground) {
		// we've been woken up directly to background;
		if (!start_at_boot || !background_mode) {
			// autoboot disabled or no background, and no push: do nothing and wait for a real launch
			//output a log with NSLog, because the ortp logging system isn't activated yet at this time
			NSLog(@"Linphone launch doing nothing because start_at_boot or background_mode are not activated.", NULL);
			return YES;
		}
	}
    
//    [[UIApplication sharedApplication] beginBackgroundTaskWithExpirationHandler:nil];
//    bgTimer = [NSTimer scheduledTimerWithTimeInterval:60 target:self
//                                             selector:@selector(reloginToXMPPServer)
//                                             userInfo:nil repeats:YES];
//    [[NSRunLoop currentRunLoop] addTimer:bgTimer forMode:NSRunLoopCommonModes];
    
	[LinphoneManager.instance startLinphoneCore];
	LinphoneManager.instance.iapManager.notificationCategory = @"expiry_notification";
	// initialize UI
	[self.window makeKeyAndVisible];
	[RootViewManager setupWithPortrait:(PhoneMainView *)self.window.rootViewController];
	//  [PhoneMainView.instance startUp];
    [[PhoneMainView instance] changeCurrentView:[LoadingViewController compositeViewDescription] push:YES];
	[PhoneMainView.instance updateStatusBar:nil];
    
//    if (bgStartId != UIBackgroundTaskInvalid)
//        [[UIApplication sharedApplication] endBackgroundTask:bgStartId];
    
    
    //  Enable all notification type. VoIP Notifications don't present a UI but we will use this to show local nofications later
    UIUserNotificationSettings *notificationSettings = [UIUserNotificationSettings settingsForTypes:UIUserNotificationTypeAlert| UIUserNotificationTypeBadge | UIUserNotificationTypeSound categories:nil];
    
    //register the notification settings
    [application registerUserNotificationSettings:notificationSettings];
    
    //output what state the app is in. This will be used to see when the app is started in the background
    NSLog(@"app launched with state : %li", (long)application.applicationState);
    NSLog(@"FINISH LAUNCHING WITH OPTION : %@", launchOptions.description);
    
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(updateCustomerTokenIOS)
                                                 name:updateTokenForXmpp object:nil];
    //  thêm contact khi sync xmpp
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(addContactFromSyncXMPP:)
                                                 name:@"addNewContactFromSyncXMPP" object:nil];
    
    // Request authorization to Address Book
    ABAddressBookRef addressBookRef = ABAddressBookCreateWithOptions(NULL, NULL);
    
    if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusNotDetermined) {
        ABAddressBookRequestAccessWithCompletion(addressBookRef, ^(bool granted, CFErrorRef error) {
            if (granted) {
                // First time access has been granted, add the contact
                contactLoaded = NO;
                [self getContactsListForFirstLoad];
            } else {
                NSLog(@"User denied access");
            }
        });
    }
    else if (ABAddressBookGetAuthorizationStatus() == kABAuthorizationStatusAuthorized) {
        NSLog(@"The user has previously given access, add the contact");
    }
    else {
        // The user has previously denied access
        // Send an alert telling user to change privacy setting in settings app
    }
    
    
    
	return YES;
}

- (void)reloadContactListAfterAddSuccess {
    [self getContactsListForFirstLoad];
}

- (void) registerForVoIPPushes {
    self.voipRegistry = [[PKPushRegistry alloc] initWithQueue:nil];
    self.voipRegistry.delegate = self;
    
    // Initiate registration.
    self.voipRegistry.desiredPushTypes = [NSSet setWithObject:PKPushTypeVoIP];
}

- (void)applicationWillTerminate:(UIApplication *)application {
    /*  Leo Kelvin
	NSLog(@"%@", NSStringFromSelector(_cmd));
	LinphoneManager.instance.conf = TRUE;
	linphone_core_terminate_all_calls(LC);

	// destroyLinphoneCore automatically unregister proxies but if we are using
	// remote push notifications, we want to continue receiving them
	if (LinphoneManager.instance.pushNotificationToken != nil) {
		// trick me! setting network reachable to false will avoid sending unregister
		const MSList *proxies = linphone_core_get_proxy_config_list(LC);
		BOOL pushNotifEnabled = NO;
		while (proxies) {
			const char *refkey = linphone_proxy_config_get_ref_key(proxies->data);
			pushNotifEnabled = pushNotifEnabled || (refkey && strcmp(refkey, "push_notification") == 0);
			proxies = proxies->next;
		}
		// but we only want to hack if at least one proxy config uses remote push..
		if (pushNotifEnabled) {
			linphone_core_set_network_reachable(LC, FALSE);
		}
	}

	[LinphoneManager.instance destroyLinphoneCore];
    */
}

- (BOOL)application:(UIApplication *)application handleOpenURL:(NSURL *)url {
	NSString *scheme = [[url scheme] lowercaseString];
	if ([scheme isEqualToString:@"linphone-config"] || [scheme isEqualToString:@"linphone-config"]) {
		NSString *encodedURL =
			[[url absoluteString] stringByReplacingOccurrencesOfString:@"linphone-config://" withString:@""];
		self.configURL = [encodedURL stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
		UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Remote configuration", nil)
																		 message:NSLocalizedString(@"This operation will load a remote configuration. Continue ?", nil)
																  preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"No", nil)
																style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		
		UIAlertAction* yesAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"Yes", nil)
																style:UIAlertActionStyleDefault
														  handler:^(UIAlertAction * action) {
															  [self showWaitingIndicator];
															  [self attemptRemoteConfiguration];
														  }];
		
		[errView addAction:defaultAction];
		[errView addAction:yesAction];

		[PhoneMainView.instance presentViewController:errView animated:YES completion:nil];
	} else {
		if ([[url scheme] isEqualToString:@"sip"]) {
			// remove "sip://" from the URI, and do it correctly by taking resourceSpecifier and removing leading and
			// trailing "/"
			NSString *sipUri = [[url resourceSpecifier]
				stringByTrimmingCharactersInSet:[NSCharacterSet characterSetWithCharactersInString:@"/"]];
			[VIEW(DialerView) setAddress:sipUri];
		}
	}
	return YES;
}

- (void)fixRing {
	if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
		// iOS7 fix for notification sound not stopping.
		// see http://stackoverflow.com/questions/19124882/stopping-ios-7-remote-notification-sound
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:1];
		[[UIApplication sharedApplication] setApplicationIconBadgeNumber:0];
	}
}

- (void)processRemoteNotification:(NSDictionary *)userInfo {

    NSDictionary *aps = [userInfo objectForKey:@"aps"];
    if (aps != nil)
    {
        NSDictionary *alert = [aps objectForKey:@"alert"];
        NSString *xmppKey = [alert objectForKey:@"xmpp"];
        if (xmppKey != nil && ![xmppKey isKindOfClass:[NSNull class]] && [xmppKey isEqualToString:@"yes"])
        {
            if ([[UIApplication sharedApplication] applicationState] == UIApplicationStateBackground ) {
                NSString *content = [alert objectForKey:@"content"];
                NSAttributedString *strContent = [AppUtils convertMessageStringToEmojiString: content];
                
                NSString *sender = [alert objectForKey:@"sender"];
                NSString *groupId = [alert objectForKey:@"group-id"];
                if ([groupId isEqualToString: @""])
                {
                    if (![content isEqualToString: @""] && content != nil && ![sender isEqualToString: @""] && sender != nil) {
                        UILocalNotification *messageNotif = [[UILocalNotification alloc] init];
                        messageNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow: 0.1];
                        messageNotif.timeZone = [NSTimeZone defaultTimeZone];
                        messageNotif.alertBody = strContent.string;
                        
                        NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:sender, @"xmppID", @"chat", @"type", nil];
                        messageNotif.userInfo = info;
                        
                        //  messageNotif.userInfo = infoDict;
                        messageNotif.soundName = UILocalNotificationDefaultSoundName;
                        [[UIApplication sharedApplication] scheduleLocalNotification: messageNotif];
                    }
                }else{
                    NSString *sender = [alert objectForKey:@"sender"];
                    
                    NSString *senderName = [NSDatabase getNameOfContactWithPhoneNumber:sender];
                    if ([senderName isEqualToString: @""]) {
                        senderName = sender;
                    }
                    NSString *subject = [NSDatabase getSubjectOfRoom: groupId];
                    NSString *msgContent = [NSString stringWithFormat:@"%@ %@ \"%@\": %@", senderName, [localization localizedStringForKey:text_in], subject, strContent.string];
                    
                    UILocalNotification *messageNotif = [[UILocalNotification alloc] init];
                    messageNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow: 0.1];
                    messageNotif.timeZone = [NSTimeZone defaultTimeZone];
                    messageNotif.alertBody = msgContent;
                    
                    NSDictionary *info = [NSDictionary dictionaryWithObjectsAndKeys:groupId, @"xmppID", @"groupchat", @"type", nil];
                    messageNotif.userInfo = info;
                    
                    //  messageNotif.userInfo = infoDict;
                    messageNotif.soundName = UILocalNotificationDefaultSoundName;
                    [[UIApplication sharedApplication] scheduleLocalNotification: messageNotif];
                }
            }
        }else{
            [[LinphoneManager instance] refreshRegisters];
            
            [[NSUserDefaults standardUserDefaults] setObject:aps forKey:@"testkey"];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            NSString *loc_key = [aps objectForKey:@"loc-key"];
            NSString *callId = [aps objectForKey:@"call-id"];
            
            NSString *address = [self getNameForCurrentPhoneNumber: callId];
            if ([address isEqualToString: callId]) {
                address = [self getNameOfContactWithPhoneNumber: callId];
                if ([address isEqualToString:@""]) {
                    address = callId;
                }
            }
            
            UILocalNotification *messageNotif = [[UILocalNotification alloc] init];
            messageNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow: 0.1];
            messageNotif.timeZone = [NSTimeZone defaultTimeZone];
            messageNotif.timeZone = [NSTimeZone defaultTimeZone];
            messageNotif.alertBody = [NSString stringWithFormat:@"%@ %@", [localization localizedStringForKey:receive_call_from], address];
            messageNotif.soundName = UILocalNotificationDefaultSoundName;
            [[UIApplication sharedApplication] scheduleLocalNotification: messageNotif];
            
            
//            NSString *loc_key = [aps objectForKey:@"loc-key"];
//            NSString *callId = [aps objectForKey:@"call-id"];
            if (alert != nil) {
                loc_key = [alert objectForKey:@"loc-key"];
                /*if we receive a remote notification, it is probably because our TCP background socket was no more working.
                 As a result, break it and refresh registers in order to make sure to receive incoming INVITE or MESSAGE*/
                if (linphone_core_get_calls(LC) == NULL) { // if there are calls, obviously our TCP socket shall be working
                    //linphone_core_set_network_reachable(LC, FALSE);
                    if (!linphone_core_is_network_reachable(LC)) {
                        LinphoneManager.instance.connectivity = none; //Force connectivity to be discovered again
                        [LinphoneManager.instance setupNetworkReachabilityCallback];
                    }
                    if (loc_key != nil) {
                        
                        //  callId = [userInfo objectForKey:@"call-id"];
                        if (callId != nil) {
                            if ([callId isEqualToString:@""]){
                                //Present apn pusher notifications for info
                                if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) {
                                    UNMutableNotificationContent* content = [[UNMutableNotificationContent alloc] init];
                                    content.title = @"APN Pusher";
                                    content.body = @"Push notification received !";
                                    
                                    UNNotificationRequest *req = [UNNotificationRequest requestWithIdentifier:@"call_request" content:content trigger:NULL];
                                    [[UNUserNotificationCenter currentNotificationCenter] addNotificationRequest:req withCompletionHandler:^(NSError * _Nullable error) {
                                        // Enable or disable features based on authorization.
                                        if (error) {
                                            NSLog(@"Error while adding notification request :%@", error.description);
                                        }
                                    }];
                                } else {
                                    UILocalNotification *notification = [[UILocalNotification alloc] init];
                                    notification.repeatInterval = 0;
                                    notification.alertBody = @"Push notification received !";
                                    notification.alertTitle = @"APN Pusher";
                                    [[UIApplication sharedApplication] presentLocalNotificationNow:notification];
                                }
                            } else {
                                [LinphoneManager.instance addPushCallId:callId];
                            }
                        } else  if ([callId  isEqual: @""]) {
                            NSLog(@"PushNotification: does not have call-id yet, fix it !");
                        }
                    }
                }
            }
            
            if (callId && [self addLongTaskIDforCallID:callId]) {
                if ([UIApplication sharedApplication].applicationState != UIApplicationStateActive && loc_key &&
                    index > 0) {
                    if ([loc_key isEqualToString:@"IC_MSG"]) {
                        [LinphoneManager.instance startPushLongRunningTask:FALSE];
                        [self fixRing];
                    } else if ([loc_key isEqualToString:@"IM_MSG"]) {
                        [LinphoneManager.instance startPushLongRunningTask:TRUE];
                    }
                }
            }
        }
    }
}

- (BOOL)addLongTaskIDforCallID:(NSString *)callId {
    NSDictionary *dict = LinphoneManager.instance.pushDict;
    if ([[dict allKeys] indexOfObject:callId] != NSNotFound) {
        return FALSE;
    }
    [dict setValue:[NSNumber numberWithInt:1] forKey:callId];
    return TRUE;
}

- (void)application:(UIApplication *)application didReceiveRemoteNotification:(NSDictionary *)userInfo {
	//  [self processRemoteNotification:userInfo];
}

- (LinphoneChatRoom *)findChatRoomForContact:(NSString *)contact {
	const MSList *rooms = linphone_core_get_chat_rooms(LC);
	const char *from = [contact UTF8String];
	while (rooms) {
		const LinphoneAddress *room_from_address = linphone_chat_room_get_peer_address((LinphoneChatRoom *)rooms->data);
		char *room_from = linphone_address_as_string_uri_only(room_from_address);
		if (room_from && strcmp(from, room_from) == 0) {
			return rooms->data;
		}
		rooms = rooms->next;
	}
	return NULL;
}

/*
- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
	NSLog(@"%@ - state = %ld", NSStringFromSelector(_cmd), (long)application.applicationState);

	if ([notification.category isEqual:LinphoneManager.instance.iapManager.notificationCategory]){
		[PhoneMainView.instance changeCurrentView:ShopView.compositeViewDescription];
		return;
	}

	[self fixRing];

	if ([notification.userInfo objectForKey:@"callId"] != nil) {
		BOOL bypass_incoming_view = TRUE;
		// some local notifications have an internal timer to relaunch themselves at specified intervals
		if ([[notification.userInfo objectForKey:@"timer"] intValue] == 1) {
			[LinphoneManager.instance cancelLocalNotifTimerForCallId:[notification.userInfo objectForKey:@"callId"]];
			bypass_incoming_view = [LinphoneManager.instance lpConfigBoolForKey:@"autoanswer_notif_preference"];
		}
		if (bypass_incoming_view) {
			[LinphoneManager.instance acceptCallForCallId:[notification.userInfo objectForKey:@"callId"]];
		}
	} else if ([notification.userInfo objectForKey:@"from_addr"] != nil) {
		NSString *chat = notification.alertBody;
		NSString *remote_uri = (NSString *)[notification.userInfo objectForKey:@"from_addr"];
		NSString *from = (NSString *)[notification.userInfo objectForKey:@"from"];
		NSString *callID = (NSString *)[notification.userInfo objectForKey:@"call-id"];
		LinphoneChatRoom *room = [self findChatRoomForContact:remote_uri];
		if ([UIApplication sharedApplication].applicationState == UIApplicationStateBackground ||
			((PhoneMainView.instance.currentView != ChatsListView.compositeViewDescription) &&
			 ((PhoneMainView.instance.currentView != ChatConversationView.compositeViewDescription))) ||
			(PhoneMainView.instance.currentView == ChatConversationView.compositeViewDescription &&
			 room != PhoneMainView.instance.currentRoom)) {
			// Create a new notification

			if (floor(NSFoundationVersionNumber) <= NSFoundationVersionNumber_iOS_9_x_Max) {
				// Do nothing
			} else {
				UNMutableNotificationContent *content = [[UNMutableNotificationContent alloc] init];
				content.title = NSLocalizedString(@"Message received", nil);
				if ([LinphoneManager.instance lpConfigBoolForKey:@"show_msg_in_notif" withDefault:YES]) {
					content.subtitle = from;
					content.body = chat;
				} else {
					content.body = from;
				}
				content.sound = [UNNotificationSound soundNamed:@"msg.caf"];
				content.categoryIdentifier = @"msg_cat";
				content.userInfo = @{ @"from" : from, @"from_addr" : remote_uri, @"call-id" : callID };
				content.accessibilityLabel = @"Message notif";
				UNNotificationRequest *req =
					[UNNotificationRequest requestWithIdentifier:@"call_request" content:content trigger:NULL];
				req.accessibilityLabel = @"Message notif";
				[[UNUserNotificationCenter currentNotificationCenter]
					addNotificationRequest:req
					 withCompletionHandler:^(NSError *_Nullable error) {
					   // Enable or disable features based on authorization.
					   if (error) {
						   LOGD(@"Error while adding notification request :");
						   LOGD(error.description);
					   }
					 }];
			}
		}
	} else if ([notification.userInfo objectForKey:@"callLog"] != nil) {
		NSString *callLog = (NSString *)[notification.userInfo objectForKey:@"callLog"];
		HistoryDetailsView *view = VIEW(HistoryDetailsView);
		[view setCallLogId:callLog];
		[PhoneMainView.instance changeCurrentView:view.compositeViewDescription];
	}
}
*/

#pragma mark - PushNotification Functions

- (void)application:(UIApplication *)application didRegisterForRemoteNotificationsWithDeviceToken:(NSData *)deviceToken {
	NSLog(@"%@ : %@", NSStringFromSelector(_cmd), deviceToken);
	//  [LinphoneManager.instance setPushNotificationToken:deviceToken];
}

- (void)application:(UIApplication *)application didFailToRegisterForRemoteNotificationsWithError:(NSError *)error {
	NSLog(@"%@ : %@", NSStringFromSelector(_cmd), [error localizedDescription]);
	//  [LinphoneManager.instance setPushNotificationToken:nil];
}

#pragma mark - PushKit Functions

- (void)pushRegistry:(PKPushRegistry *)registry didInvalidatePushTokenForType:(NSString *)type {
    NSLog(@"PushKit Token invalidated");
    dispatch_async(dispatch_get_main_queue(), ^{
        //  [LinphoneManager.instance setPushNotificationToken:nil];
    });
}

- (void)pushRegistry:(PKPushRegistry *)registry
	didReceiveIncomingPushWithPayload:(PKPushPayload *)payload
							  forType:(NSString *)type {
    
	NSLog(@"PushKit : incoming voip notfication: %@", payload.dictionaryPayload);
	if (floor(NSFoundationVersionNumber) > NSFoundationVersionNumber_iOS_9_x_Max) { // Call category
		UNNotificationAction *act_ans =
			[UNNotificationAction actionWithIdentifier:@"Answer"
												 title:NSLocalizedString(@"Answer", nil)
											   options:UNNotificationActionOptionForeground];
		UNNotificationAction *act_dec = [UNNotificationAction actionWithIdentifier:@"Decline"
																			 title:NSLocalizedString(@"Decline", nil)
																		   options:UNNotificationActionOptionNone];
		UNNotificationCategory *cat_call =
			[UNNotificationCategory categoryWithIdentifier:@"call_cat"
												   actions:[NSArray arrayWithObjects:act_ans, act_dec, nil]
										 intentIdentifiers:[[NSMutableArray alloc] init]
												   options:UNNotificationCategoryOptionCustomDismissAction];
		// Msg category
		UNTextInputNotificationAction *act_reply =
			[UNTextInputNotificationAction actionWithIdentifier:@"Reply"
														  title:NSLocalizedString(@"Reply", nil)
														options:UNNotificationActionOptionNone];
		UNNotificationAction *act_seen =
			[UNNotificationAction actionWithIdentifier:@"Seen"
												 title:NSLocalizedString(@"Mark as seen", nil)
											   options:UNNotificationActionOptionNone];
		UNNotificationCategory *cat_msg =
			[UNNotificationCategory categoryWithIdentifier:@"msg_cat"
												   actions:[NSArray arrayWithObjects:act_reply, act_seen, nil]
										 intentIdentifiers:[[NSMutableArray alloc] init]
												   options:UNNotificationCategoryOptionCustomDismissAction];

		// Video Request Category
		UNNotificationAction *act_accept =
			[UNNotificationAction actionWithIdentifier:@"Accept"
												 title:NSLocalizedString(@"Accept", nil)
											   options:UNNotificationActionOptionForeground];

		UNNotificationAction *act_refuse = [UNNotificationAction actionWithIdentifier:@"Cancel"
																				title:NSLocalizedString(@"Cancel", nil)
																			  options:UNNotificationActionOptionNone];
		UNNotificationCategory *video_call =
			[UNNotificationCategory categoryWithIdentifier:@"video_request"
												   actions:[NSArray arrayWithObjects:act_accept, act_refuse, nil]
										 intentIdentifiers:[[NSMutableArray alloc] init]
												   options:UNNotificationCategoryOptionCustomDismissAction];

		// ZRTP verification category
		UNNotificationAction *act_confirm = [UNNotificationAction actionWithIdentifier:@"Confirm"
																				 title:NSLocalizedString(@"Accept", nil)
																			   options:UNNotificationActionOptionNone];

		UNNotificationAction *act_deny = [UNNotificationAction actionWithIdentifier:@"Deny"
																			  title:NSLocalizedString(@"Deny", nil)
																			options:UNNotificationActionOptionNone];
		UNNotificationCategory *cat_zrtp =
			[UNNotificationCategory categoryWithIdentifier:@"zrtp_request"
												   actions:[NSArray arrayWithObjects:act_confirm, act_deny, nil]
										 intentIdentifiers:[[NSMutableArray alloc] init]
												   options:UNNotificationCategoryOptionCustomDismissAction];

		[UNUserNotificationCenter currentNotificationCenter].delegate = self;
		[[UNUserNotificationCenter currentNotificationCenter]
			requestAuthorizationWithOptions:(UNAuthorizationOptionAlert | UNAuthorizationOptionSound |
											 UNAuthorizationOptionBadge)
						  completionHandler:^(BOOL granted, NSError *_Nullable error) {
							// Enable or disable features based on authorization.
							if (error) {
								LOGD(error.description);
							}
						  }];
		NSSet *categories = [NSSet setWithObjects:cat_call, cat_msg, video_call, cat_zrtp, nil];
		[[UNUserNotificationCenter currentNotificationCenter] setNotificationCategories:categories];
	}
	[LinphoneManager.instance setupNetworkReachabilityCallback];
	dispatch_async(dispatch_get_main_queue(), ^{
	  [self processRemoteNotification:payload.dictionaryPayload];
	});
}

- (void)pushRegistry:(PKPushRegistry *)registry didUpdatePushCredentials:(PKPushCredentials *)credentials forType:(PKPushType)type
{
	NSLog(@"PushKit credentials updated");
	NSLog(@"voip token: %@", (credentials.token));
	dispatch_async(dispatch_get_main_queue(), ^{
        _deviceToken = credentials.token.description;
        _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@" " withString:@""];
        _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@"<" withString:@""];
        _deviceToken = [_deviceToken stringByReplacingOccurrencesOfString:@">" withString:@""];
        
        //  Cap nhat token cho phan chat
        if (USERNAME != nil && ![USERNAME isEqualToString: @""]) {
            [self updateCustomerTokenIOS];
        }else{
            _updateTokenSuccess = false;
        }
        
        //  [LinphoneManager.instance setPushNotificationToken:credentials.token];
	});
}

#pragma mark - UNUserNotifications Framework

- (void) userNotificationCenter:(UNUserNotificationCenter *)center willPresentNotification:(UNNotification *)notification withCompletionHandler:(void (^)(UNNotificationPresentationOptions))completionHandler {
	completionHandler(UNNotificationPresentationOptionAlert | UNNotificationPresentationOptionAlert);
}

-(void)userNotificationCenter:(UNUserNotificationCenter *)center didReceiveNotificationResponse:(UNNotificationResponse *)response withCompletionHandler:(void (^)(void))completionHandler {
    LOGD(@"UN : response received");
    LOGD(response.description);
    
    NSString *type = (NSString *)[response.notification.request.content.userInfo objectForKey:@"type"];
    if (type != nil && [type isEqualToString:@"chat"]) {
        NSString *cloudfoneID = (NSString *)[response.notification.request.content.userInfo objectForKey:@"xmppID"];
        if (cloudfoneID != nil && ![cloudfoneID isEqualToString:@""]) {
            reloadMessageList = YES;
            friendBuddy = [AppUtils getBuddyOfUserOnList: cloudfoneID];
            [[PhoneMainView instance] changeCurrentView:[MainChatViewController compositeViewDescription]
                                                   push:true];
            return;
        }
    }else if (type != nil && [type isEqualToString:@"groupchat"]){
        NSString *groupId = (NSString *)[response.notification.request.content.userInfo objectForKey:@"xmppID"];
        if (groupId != nil && ![groupId isEqualToString:@""]) {
            reloadMessageList = YES;
            roomChatName = groupId;
            [[PhoneMainView instance] changeCurrentView:[GroupMainChatViewController compositeViewDescription] push:true];
            
            return;
        }
    }
    
    NSString *callId = (NSString *)[response.notification.request.content.userInfo objectForKey:@"CallId"];
    if (!callId) {
        return;
    }
    LinphoneCall *call = [LinphoneManager.instance callByCallId:callId];
    if (call) {
        LinphoneCallAppData *data = (__bridge LinphoneCallAppData *)linphone_call_get_user_data(call);
        if (data->timer) {
            [data->timer invalidate];
            data->timer = nil;
        }
    }
    
    if ([response.actionIdentifier isEqual:@"Answer"]) {
        // use the standard handler
        [PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
        linphone_core_accept_call(LC, call);
    } else if ([response.actionIdentifier isEqual:@"Decline"]) {
        linphone_core_decline_call(LC, call, LinphoneReasonDeclined);
    } else if ([response.actionIdentifier isEqual:@"Reply"]) {
        LinphoneCore *lc = [LinphoneManager getLc];
        NSString *replyText = [(UNTextInputNotificationResponse *)response userText];
        NSString *from = [response.notification.request.content.userInfo objectForKey:@"from_addr"];
        LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(lc, [from UTF8String]);
        if (room) {
            LinphoneChatMessage *msg = linphone_chat_room_create_message(room, replyText.UTF8String);
            linphone_chat_room_send_chat_message(room, msg);
            
            if (linphone_core_lime_enabled(LC) == LinphoneLimeMandatory && !linphone_chat_room_lime_available(room)) {
                [LinphoneManager.instance alertLIME:room];
            }
            linphone_chat_room_mark_as_read(room);
            TabBarView *tab = (TabBarView *)[PhoneMainView.instance.mainViewController
                                             getCachedController:NSStringFromClass(TabBarView.class)];
            [tab update:YES];
            [PhoneMainView.instance updateApplicationBadgeNumber];
        }
    } else if ([response.actionIdentifier isEqual:@"Seen"]) {
        NSString *from = [response.notification.request.content.userInfo objectForKey:@"from_addr"];
        LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(LC, [from UTF8String]);
        if (room) {
            linphone_chat_room_mark_as_read(room);
            TabBarView *tab = (TabBarView *)[PhoneMainView.instance.mainViewController
                                             getCachedController:NSStringFromClass(TabBarView.class)];
            [tab update:YES];
            [PhoneMainView.instance updateApplicationBadgeNumber];
        }
        
    } else if ([response.actionIdentifier isEqual:@"Cancel"]) {
        NSLog(@"User declined video proposal");
        if (call == linphone_core_get_current_call(LC)) {
            LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
            linphone_core_accept_call_update(LC, call, params);
            linphone_call_params_destroy(params);
        }
    } else if ([response.actionIdentifier isEqual:@"Accept"]) {
        NSLog(@"User accept video proposal");
        if (call == linphone_core_get_current_call(LC)) {
            [[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
            [PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
            LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
            linphone_call_params_enable_video(params, TRUE);
            linphone_core_accept_call_update(LC, call, params);
            linphone_call_params_destroy(params);
        }
    } else if ([response.actionIdentifier isEqual:@"Confirm"]) {
        if (linphone_core_get_current_call(LC) == call) {
            linphone_call_set_authentication_token_verified(call, YES);
        }
    } else if ([response.actionIdentifier isEqual:@"Deny"]) {
        if (linphone_core_get_current_call(LC) == call) {
            linphone_call_set_authentication_token_verified(call, NO);
        }
    } else if ([response.actionIdentifier isEqual:@"Call"]) {
        
    } else { // in this case the value is : com.apple.UNNotificationDefaultActionIdentifier
        if ([response.notification.request.content.categoryIdentifier isEqual:@"call_cat"]) {
            [PhoneMainView.instance displayIncomingCall:call];
        } else if ([response.notification.request.content.categoryIdentifier isEqual:@"msg_cat"]) {
            [PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
        } else if ([response.notification.request.content.categoryIdentifier isEqual:@"video_request"]) {
            [PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
            NSTimer *videoDismissTimer = nil;
            
            UIConfirmationDialog *sheet =
            [UIConfirmationDialog ShowWithMessage:response.notification.request.content.body
                                    cancelMessage:nil
                                   confirmMessage:NSLocalizedString(@"ACCEPT", nil)
                                    onCancelClick:^() {
                                        NSLog(@"User declined video proposal");
                                        if (call == linphone_core_get_current_call(LC)) {
                                            LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
                                            linphone_core_accept_call_update(LC, call, params);
                                            linphone_call_params_destroy(params);
                                            [videoDismissTimer invalidate];
                                        }
                                    }
                              onConfirmationClick:^() {
                                  NSLog(@"User accept video proposal");
                                  if (call == linphone_core_get_current_call(LC)) {
                                      LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
                                      linphone_call_params_enable_video(params, TRUE);
                                      linphone_core_accept_call_update(LC, call, params);
                                      linphone_call_params_destroy(params);
                                      [videoDismissTimer invalidate];
                                  }
                              }
                                     inController:PhoneMainView.instance];
            
            videoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:30
                                                                 target:self
                                                               selector:@selector(dismissVideoActionSheet:)
                                                               userInfo:sheet
                                                                repeats:NO];
        } else if ([response.notification.request.content.categoryIdentifier isEqual:@"zrtp_request"]) {
            NSString *code = [NSString stringWithUTF8String:linphone_call_get_authentication_token(call)];
            NSString *myCode;
            NSString *correspondantCode;
            if (linphone_call_get_dir(call) == LinphoneCallIncoming) {
                myCode = [code substringToIndex:2];
                correspondantCode = [code substringFromIndex:2];
            } else {
                correspondantCode = [code substringToIndex:2];
                myCode = [code substringFromIndex:2];
            }
            NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Confirm the following SAS with peer:\n"
                                                                             @"Say : %@\n"
                                                                             @"Your correspondant should say : %@",
                                                                             nil),
                                 myCode, correspondantCode];
            [UIConfirmationDialog ShowWithMessage:message
                                    cancelMessage:NSLocalizedString(@"DENY", nil)
                                   confirmMessage:NSLocalizedString(@"ACCEPT", nil)
                                    onCancelClick:^() {
                                        if (linphone_core_get_current_call(LC) == call) {
                                            linphone_call_set_authentication_token_verified(call, NO);
                                        }
                                    }
                              onConfirmationClick:^() {
                                  if (linphone_core_get_current_call(LC) == call) {
                                      linphone_call_set_authentication_token_verified(call, YES);
                                  }
                              }];
        } else if ([response.notification.request.content.categoryIdentifier isEqual:@"lime"]) {
            return;
        } else { // Missed call
            [PhoneMainView.instance changeCurrentView:HistoryListView.compositeViewDescription];
        }
    }
}
/*  Close by Khai Le
- (void)userNotificationCenter:(UNUserNotificationCenter *)center
didReceiveNotificationResponse:(UNNotificationResponse *)response
         withCompletionHandler:(void (^)())completionHandler {
	LOGD(@"UN : response received");
	LOGD(response.description);

	NSString *callId = (NSString *)[response.notification.request.content.userInfo objectForKey:@"CallId"];
	if (!callId) {
		return;
	}
	LinphoneCall *call = [LinphoneManager.instance callByCallId:callId];
	if (call) {
		LinphoneCallAppData *data = (__bridge LinphoneCallAppData *)linphone_call_get_user_data(call);
		if (data->timer) {
			[data->timer invalidate];
			data->timer = nil;
		}
	}

	if ([response.actionIdentifier isEqual:@"Answer"]) {
		// use the standard handler
		[PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
		linphone_core_accept_call(LC, call);
	} else if ([response.actionIdentifier isEqual:@"Decline"]) {
		linphone_core_decline_call(LC, call, LinphoneReasonDeclined);
	} else if ([response.actionIdentifier isEqual:@"Reply"]) {
		LinphoneCore *lc = [LinphoneManager getLc];
		NSString *replyText = [(UNTextInputNotificationResponse *)response userText];
		NSString *from = [response.notification.request.content.userInfo objectForKey:@"from_addr"];
		LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(lc, [from UTF8String]);
		if (room) {
			LinphoneChatMessage *msg = linphone_chat_room_create_message(room, replyText.UTF8String);
			linphone_chat_room_send_chat_message(room, msg);

			if (linphone_core_lime_enabled(LC) == LinphoneLimeMandatory && !linphone_chat_room_lime_available(room)) {
				[LinphoneManager.instance alertLIME:room];
			}
			linphone_chat_room_mark_as_read(room);
			TabBarView *tab = (TabBarView *)[PhoneMainView.instance.mainViewController
				getCachedController:NSStringFromClass(TabBarView.class)];
			[tab update:YES];
			[PhoneMainView.instance updateApplicationBadgeNumber];
		}
	} else if ([response.actionIdentifier isEqual:@"Seen"]) {
		NSString *from = [response.notification.request.content.userInfo objectForKey:@"from_addr"];
		LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(LC, [from UTF8String]);
		if (room) {
			linphone_chat_room_mark_as_read(room);
			TabBarView *tab = (TabBarView *)[PhoneMainView.instance.mainViewController
				getCachedController:NSStringFromClass(TabBarView.class)];
			[tab update:YES];
			[PhoneMainView.instance updateApplicationBadgeNumber];
		}

	} else if ([response.actionIdentifier isEqual:@"Cancel"]) {
		NSLog(@"User declined video proposal");
		if (call == linphone_core_get_current_call(LC)) {
			LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
			linphone_core_accept_call_update(LC, call, params);
			linphone_call_params_destroy(params);
		}
	} else if ([response.actionIdentifier isEqual:@"Accept"]) {
		NSLog(@"User accept video proposal");
		if (call == linphone_core_get_current_call(LC)) {
			[[UNUserNotificationCenter currentNotificationCenter] removeAllDeliveredNotifications];
			[PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
			LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
			linphone_call_params_enable_video(params, TRUE);
			linphone_core_accept_call_update(LC, call, params);
			linphone_call_params_destroy(params);
		}
	} else if ([response.actionIdentifier isEqual:@"Confirm"]) {
		if (linphone_core_get_current_call(LC) == call) {
			linphone_call_set_authentication_token_verified(call, YES);
		}
	} else if ([response.actionIdentifier isEqual:@"Deny"]) {
		if (linphone_core_get_current_call(LC) == call) {
			linphone_call_set_authentication_token_verified(call, NO);
		}
	} else if ([response.actionIdentifier isEqual:@"Call"]) {

	} else { // in this case the value is : com.apple.UNNotificationDefaultActionIdentifier
		if ([response.notification.request.content.categoryIdentifier isEqual:@"call_cat"]) {
			[PhoneMainView.instance displayIncomingCall:call];
		} else if ([response.notification.request.content.categoryIdentifier isEqual:@"msg_cat"]) {
			[PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
		} else if ([response.notification.request.content.categoryIdentifier isEqual:@"video_request"]) {
			[PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
			NSTimer *videoDismissTimer = nil;

			UIConfirmationDialog *sheet =
				[UIConfirmationDialog ShowWithMessage:response.notification.request.content.body
					cancelMessage:nil
					confirmMessage:NSLocalizedString(@"ACCEPT", nil)
					onCancelClick:^() {
					  NSLog(@"User declined video proposal");
					  if (call == linphone_core_get_current_call(LC)) {
						  LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
						  linphone_core_accept_call_update(LC, call, params);
						  linphone_call_params_destroy(params);
						  [videoDismissTimer invalidate];
					  }
					}
					onConfirmationClick:^() {
					  NSLog(@"User accept video proposal");
					  if (call == linphone_core_get_current_call(LC)) {
						  LinphoneCallParams *params = linphone_core_create_call_params(LC, call);
						  linphone_call_params_enable_video(params, TRUE);
						  linphone_core_accept_call_update(LC, call, params);
						  linphone_call_params_destroy(params);
						  [videoDismissTimer invalidate];
					  }
					}
					inController:PhoneMainView.instance];

			videoDismissTimer = [NSTimer scheduledTimerWithTimeInterval:30
																 target:self
															   selector:@selector(dismissVideoActionSheet:)
															   userInfo:sheet
																repeats:NO];
		} else if ([response.notification.request.content.categoryIdentifier isEqual:@"zrtp_request"]) {
			NSString *code = [NSString stringWithUTF8String:linphone_call_get_authentication_token(call)];
			NSString *myCode;
			NSString *correspondantCode;
			if (linphone_call_get_dir(call) == LinphoneCallIncoming) {
				myCode = [code substringToIndex:2];
				correspondantCode = [code substringFromIndex:2];
			} else {
				correspondantCode = [code substringToIndex:2];
				myCode = [code substringFromIndex:2];
			}
			NSString *message = [NSString stringWithFormat:NSLocalizedString(@"Confirm the following SAS with peer:\n"
																			 @"Say : %@\n"
																			 @"Your correspondant should say : %@",
																			 nil),
														   myCode, correspondantCode];
			[UIConfirmationDialog ShowWithMessage:message
				cancelMessage:NSLocalizedString(@"DENY", nil)
				confirmMessage:NSLocalizedString(@"ACCEPT", nil)
				onCancelClick:^() {
				  if (linphone_core_get_current_call(LC) == call) {
					  linphone_call_set_authentication_token_verified(call, NO);
				  }
				}
				onConfirmationClick:^() {
				  if (linphone_core_get_current_call(LC) == call) {
					  linphone_call_set_authentication_token_verified(call, YES);
				  }
				}];
		} else if ([response.notification.request.content.categoryIdentifier isEqual:@"lime"]) {
			return;
		} else { // Missed call
			[PhoneMainView.instance changeCurrentView:HistoryListView.compositeViewDescription];
		}
	}
}   */

- (void)dismissVideoActionSheet:(NSTimer *)timer {
	UIConfirmationDialog *sheet = (UIConfirmationDialog *)timer.userInfo;
	[sheet dismiss];
}

#pragma mark - NSUser notifications

- (void)application:(UIApplication *)application
	handleActionWithIdentifier:(NSString *)identifier
		  forLocalNotification:(UILocalNotification *)notification
			 completionHandler:(void (^)())completionHandler {

	LinphoneCall *call = linphone_core_get_current_call(LC);
	if (call) {
		LinphoneCallAppData *data = (__bridge LinphoneCallAppData *)linphone_call_get_user_data(call);
		if (data->timer) {
			[data->timer invalidate];
			data->timer = nil;
		}
	}
	NSLog(@"%@", NSStringFromSelector(_cmd));
	if (floor(NSFoundationVersionNumber) < NSFoundationVersionNumber_iOS_9_0) {
		NSLog(@"%@", NSStringFromSelector(_cmd));
		if ([notification.category isEqualToString:@"incoming_call"]) {
			if ([identifier isEqualToString:@"answer"]) {
				// use the standard handler
				[PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
				linphone_core_accept_call(LC, call);
			} else if ([identifier isEqualToString:@"decline"]) {
				LinphoneCall *call = linphone_core_get_current_call(LC);
				if (call)
					linphone_core_decline_call(LC, call, LinphoneReasonDeclined);
			}
		} else if ([notification.category isEqualToString:@"incoming_msg"]) {
			if ([identifier isEqualToString:@"reply"]) {
				// use the standard handler
				[PhoneMainView.instance changeCurrentView:ChatsListView.compositeViewDescription];
			} else if ([identifier isEqualToString:@"mark_read"]) {
				NSString *from = [notification.userInfo objectForKey:@"from_addr"];
				LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(LC, [from UTF8String]);
				if (room) {
					linphone_chat_room_mark_as_read(room);
					TabBarView *tab = (TabBarView *)[PhoneMainView.instance.mainViewController
						getCachedController:NSStringFromClass(TabBarView.class)];
					[tab update:YES];
					[PhoneMainView.instance updateApplicationBadgeNumber];
				}
			}
		}
	}
	completionHandler();
}

- (void)application:(UIApplication *)application
	handleActionWithIdentifier:(NSString *)identifier
		  forLocalNotification:(UILocalNotification *)notification
			  withResponseInfo:(NSDictionary *)responseInfo
			 completionHandler:(void (^)())completionHandler {

	LinphoneCall *call = linphone_core_get_current_call(LC);
	if (call) {
		LinphoneCallAppData *data = (__bridge LinphoneCallAppData *)linphone_call_get_user_data(call);
		if (data->timer) {
			[data->timer invalidate];
			data->timer = nil;
		}
	}
	if ([notification.category isEqualToString:@"incoming_call"]) {
		if ([identifier isEqualToString:@"answer"]) {
			// use the standard handler
			[PhoneMainView.instance changeCurrentView:CallView.compositeViewDescription];
			linphone_core_accept_call(LC, call);
		} else if ([identifier isEqualToString:@"decline"]) {
			LinphoneCall *call = linphone_core_get_current_call(LC);
			if (call)
				linphone_core_decline_call(LC, call, LinphoneReasonDeclined);
		}
	} else if ([notification.category isEqualToString:@"incoming_msg"] &&
			   [identifier isEqualToString:@"reply_inline"]) {
		LinphoneCore *lc = [LinphoneManager getLc];
		NSString *replyText = [responseInfo objectForKey:UIUserNotificationActionResponseTypedTextKey];
		NSString *from = [notification.userInfo objectForKey:@"from_addr"];
		LinphoneChatRoom *room = linphone_core_get_chat_room_from_uri(lc, [from UTF8String]);
		if (room) {
			LinphoneChatMessage *msg = linphone_chat_room_create_message(room, replyText.UTF8String);
			linphone_chat_room_send_chat_message(room, msg);

			if (linphone_core_lime_enabled(LC) == LinphoneLimeMandatory && !linphone_chat_room_lime_available(room)) {
				[LinphoneManager.instance alertLIME:room];
			}

			linphone_chat_room_mark_as_read(room);
			[PhoneMainView.instance updateApplicationBadgeNumber];
		}
	}
	completionHandler();
}

- (void)application:(UIApplication *)application didReceiveLocalNotification:(UILocalNotification *)notification {
    NSLog(@"%@", notification);
}

#pragma deploymate pop

#pragma mark - Remote configuration Functions (URL Handler)

- (void)ConfigurationStateUpdateEvent:(NSNotification *)notif {
	LinphoneConfiguringState state = [[notif.userInfo objectForKey:@"state"] intValue];
	if (state == LinphoneConfiguringSuccessful) {
		[NSNotificationCenter.defaultCenter removeObserver:self name:kLinphoneConfiguringStateUpdate object:nil];
		[_waitingIndicator dismissViewControllerAnimated:YES completion:nil];
		UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Success", nil)
																		 message:NSLocalizedString(@"Remote configuration successfully fetched and applied.", nil)
																  preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
																style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		
		[errView addAction:defaultAction];
		[PhoneMainView.instance presentViewController:errView animated:YES completion:nil];

		[PhoneMainView.instance startUp];
	}
	if (state == LinphoneConfiguringFailed) {
		[NSNotificationCenter.defaultCenter removeObserver:self name:kLinphoneConfiguringStateUpdate object:nil];
		[_waitingIndicator dismissViewControllerAnimated:YES completion:nil];
		UIAlertController *errView = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Failure", nil)
																		 message:NSLocalizedString(@"Failed configuring from the specified URL.", nil)
																  preferredStyle:UIAlertControllerStyleAlert];
		
		UIAlertAction* defaultAction = [UIAlertAction actionWithTitle:NSLocalizedString(@"OK", nil)
																style:UIAlertActionStyleDefault
															  handler:^(UIAlertAction * action) {}];
		
		[errView addAction:defaultAction];
		[PhoneMainView.instance presentViewController:errView animated:YES completion:nil];
	}
}

- (void)showWaitingIndicator {
	_waitingIndicator = [UIAlertController alertControllerWithTitle:NSLocalizedString(@"Fetching remote configuration...", nil)
															message:@""
													 preferredStyle:UIAlertControllerStyleAlert];
	
	UIActivityIndicatorView *progress = [[UIActivityIndicatorView alloc] initWithFrame:CGRectMake(125, 60, 30, 30)];
	progress.activityIndicatorViewStyle = UIActivityIndicatorViewStyleWhiteLarge;
	
	[_waitingIndicator setValue:progress forKey:@"accessoryView"];
	[progress setColor:[UIColor blackColor]];
	
	[progress startAnimating];
	[PhoneMainView.instance presentViewController:_waitingIndicator animated:YES completion:nil];
}

- (void)attemptRemoteConfiguration {

	[NSNotificationCenter.defaultCenter addObserver:self
										   selector:@selector(ConfigurationStateUpdateEvent:)
											   name:kLinphoneConfiguringStateUpdate
											 object:nil];
	linphone_core_set_provisioning_uri(LC, [configURL UTF8String]);
	[LinphoneManager.instance destroyLinphoneCore];
	[LinphoneManager.instance startLinphoneCore];
	[LinphoneManager.instance.fastAddressBook reload];
}

#pragma mark - Prevent ImagePickerView from rotating

- (UIInterfaceOrientationMask)application:(UIApplication *)application supportedInterfaceOrientationsForWindow:(UIWindow *)window {
    //	if ([[(PhoneMainView*)self.window.rootViewController currentView] equal:ImagePickerView.compositeViewDescription])
    //	{
    //		//Prevent rotation of camera
    //		NSNumber *value = [NSNumber numberWithInt:UIInterfaceOrientationPortrait];
    //		[[UIDevice currentDevice] setValue:value forKey:@"orientation"];
    //		return UIInterfaceOrientationMaskPortrait;
    //	}
    //	else return UIInterfaceOrientationMaskAll;
    return UIInterfaceOrientationMaskPortrait;
}

#pragma mark - Khai Le functions

//  Login thất bại
- (void)protocolLoginFailed:(NSNotification*)notification {
    NSLog(@"Failed to login xmpp");
}

//  Sau khi login thành công thì active Blacklist
- (void)protocolLoginSuccess: (NSNotification*)notification
{
    [self.xmppChatRooms removeAllObjects];
    
    //  Xoá các user trong request list để thêm lại
    [NSDatabase removeAllUserFromRequestList];
    
    // Send tất cả msg fail của user
    [NSDatabase resendAllFailedMessageOfAccount: USERNAME];
    [self createAndActiveBlacklist];
    
    [NSTimer scheduledTimerWithTimeInterval:5.0 target:self
                                   selector:@selector(updateStatusForAccount)
                                   userInfo:nil repeats:false];
}

//  Cập nhật trạng thái
- (void)updateStatusForAccount {
    NSString *status = [NSDatabase getStatusXmppOfAccount: USERNAME];
    
    if (status == nil || [status isEqualToString: @""]) {
        status = welcomeToCloudFone;
    }
    NSString *user = [NSString stringWithFormat:@"%@@%@", USERNAME, xmpp_cloudfone];
    [myBuddy.protocol setStatus: status withUser: user];
}

//  Active blacklist
- (void)createAndActiveBlacklist {
    NSArray *blackList = [NSDatabase getAllUserInCallnexBlacklist];
    if (blackList.count > 0) {
        [myBuddy.protocol createBlackListOfMe: blackList];
        [myBuddy.protocol activeBlackListOfMe];
    }
}

- (void)checkNetworkStatus:(NSNotification *)notice
{
    // called after network status changes
    NetworkStatus internetStatus = [_internetReachable currentReachabilityStatus];
    switch (internetStatus)
    {
        case NotReachable: {
            NSLog(@"The internet is down.");
            _internetActive = false;
            [[NSNotificationCenter defaultCenter] postNotificationName:networkChanged
                                                                object:nil];
            break;
        }
        case ReachableViaWiFi:
        {
            NSLog(@"The internet is working via WIFI.");
            _internetActive = true;
            [[NSNotificationCenter defaultCenter] postNotificationName:networkChanged
                                                                object:nil];
            break;
        }
        case ReachableViaWWAN:
        {
            NSLog(@"The internet is working via WWAN.");
            _internetActive = true;
            [[NSNotificationCenter defaultCenter] postNotificationName:networkChanged
                                                                object:nil];
            break;
        }
    }
}

#pragma mark - my functions

- (void)getContactsListForFirstLoad
{
    if (listContacts == nil) {
        listContacts = [[NSMutableArray alloc] init];
    }
    [listContacts removeAllObjects];
    
    if (sipContacts == nil) {
        sipContacts = [[NSMutableArray alloc] init];
    }
    [sipContacts removeAllObjects];
    
    if (pbxContacts == nil) {
        pbxContacts = [[NSMutableArray alloc] init];
    }
    [pbxContacts removeAllObjects];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [self getAllIDContactInPhoneBook];
        dispatch_async(dispatch_get_main_queue(), ^(void){
            contactLoaded = YES;
            [[NSNotificationCenter defaultCenter] postNotificationName:finishLoadContacts
                                                                object:nil];
        });
    });
}

//  Lấy tất cả contact trong phonebook
- (void)getAllIDContactInPhoneBook
{
    //  Reset PBX contact id đã lưu khi mới vào app
    [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:0]
                                              forKey:@"PBX_ID_CONTACT"];
    [[NSUserDefaults standardUserDefaults] synchronize];
    //  -------
    
    addressListBook = ABAddressBookCreate();
    NSArray *arrayOfAllPeople = (__bridge  NSArray *) ABAddressBookCopyArrayOfAllPeople(addressListBook);
    NSUInteger peopleCounter = 0;
    
    for (peopleCounter = 0; peopleCounter < [arrayOfAllPeople count]; peopleCounter++)
    {
        ABRecordRef aPerson = (__bridge ABRecordRef)[arrayOfAllPeople objectAtIndex:peopleCounter];
        int idOfContact = ABRecordGetRecordID(aPerson);
        
        ContactObject *aContact = [[ContactObject alloc] init];
        aContact.person = aPerson;
        aContact._id_contact = idOfContact;
        aContact._fullName = [AppUtils getNameOfContact: aPerson];
        
        if (![aContact._fullName isEqualToString:@""]) {
            NSString *convertName = [AppUtils convertUTF8CharacterToCharacter: aContact._fullName];
            aContact._nameForSearch = [AppUtils getNameForSearchOfConvertName: convertName];
        }
        
        aContact._sipPhone = [self getSipIdOfContact: aPerson];
        aContact._avatar = [self getAvatarOfContact: aPerson];
        aContact._listPhone = [self getListPhoneOfContactPerson: aPerson withName: aContact._fullName];
        [listContacts addObject: aContact];
        
        if (![aContact._sipPhone isEqualToString: @""] && [aContact._sipPhone hasPrefix:@"778899"]) {
            [sipContacts addObject: aContact];
            
            [_allPhonesDict setObject:[NSString stringWithFormat:@"%@|%@|%@", aContact._fullName, [AppUtils getNameForSearchOfConvertName: aContact._fullName], aContact._sipPhone] forKey:aContact._sipPhone];
            [_allIDDict setObject:[NSString stringWithFormat:@"%d", idOfContact] forKey:aContact._sipPhone];
        }
        
        //  Kiem tra co phai la contact pbx hay ko?
        NSString *sipNumber = (__bridge NSString *)ABRecordCopyValue(aPerson, kABPersonFirstNamePhoneticProperty);
        if (sipNumber != nil && [sipNumber isEqualToString: keySyncPBX])
        {
            ABMultiValueRef phones = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);
            if (ABMultiValueGetCount(phones) > 0)
            {
                for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
                {
                    CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
                    CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
                    
                    NSString *curPhoneValue = (__bridge NSString *)phoneNumberRef;
                    curPhoneValue = [[curPhoneValue componentsSeparatedByCharactersInSet:[[NSCharacterSet decimalDigitCharacterSet] invertedSet]] componentsJoinedByString:@""];
                    
                    NSString *nameValue = (__bridge NSString *)locLabel;
                    
                    if (curPhoneValue != nil && nameValue != nil) {
                        PBXContact *aContact = [[PBXContact alloc] init];
                        aContact._name = nameValue;
                        aContact._number = curPhoneValue;
                        
                        [pbxContacts addObject: aContact];
                    }
                }
            }
            
            [[NSUserDefaults standardUserDefaults] setObject:[NSNumber numberWithInt:idOfContact]
                                                      forKey:@"PBX_ID_CONTACT"];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }
}

- (NSMutableArray *)getListPhoneOfContactPerson: (ABRecordRef)aPerson withName: (NSString *)contactName
{
    NSMutableArray *result = nil;
    ABMultiValueRef phones = ABRecordCopyValue(aPerson, kABPersonPhoneProperty);
    NSString *strPhone = [[NSMutableString alloc] init];
    if (ABMultiValueGetCount(phones) > 0)
    {
        result = [[NSMutableArray alloc] init];
        
        for(CFIndex j = 0; j < ABMultiValueGetCount(phones); j++)
        {
            CFStringRef phoneNumberRef = ABMultiValueCopyValueAtIndex(phones, j);
            CFStringRef locLabel = ABMultiValueCopyLabelAtIndex(phones, j);
            
            NSString *phoneNumber = (__bridge NSString *)phoneNumberRef;
            phoneNumber = [self removeAllSpecialInString:phoneNumber];
            
            if (phoneNumber != nil) {
                int idOfContact = ABRecordGetRecordID(aPerson);
                
                [_allPhonesDict setObject:[NSString stringWithFormat:@"%@|%@|%@", contactName, [AppUtils getNameForSearchOfConvertName:contactName], phoneNumber] forKey:phoneNumber];
                [_allIDDict setObject:[NSString stringWithFormat:@"%d", idOfContact] forKey:phoneNumber];
            }
            
            strPhone = @"";
            if (locLabel == nil) {
                ContactDetailObj *anItem = [[ContactDetailObj alloc] init];
                anItem._iconStr = @"btn_contacts_home.png";
                anItem._titleStr = [localization localizedStringForKey:text_phone_home];
                anItem._valueStr = [self removeAllSpecialInString:phoneNumber];
                anItem._buttonStr = @"contact_detail_icon_call.png";
                anItem._typePhone = type_phone_home;
                [result addObject: anItem];
            }else{
                if (CFStringCompare(locLabel, kABHomeLabel, 0) == kCFCompareEqualTo) {
                    ContactDetailObj *anItem = [[ContactDetailObj alloc] init];
                    anItem._iconStr = @"btn_contacts_home.png";
                    anItem._titleStr = [localization localizedStringForKey:text_phone_home];
                    anItem._valueStr = [self removeAllSpecialInString:phoneNumber];
                    anItem._buttonStr = @"contact_detail_icon_call.png";
                    anItem._typePhone = type_phone_home;
                    [result addObject: anItem];
                }else if (CFStringCompare(locLabel, kABWorkLabel, 0) == kCFCompareEqualTo)
                {
                    ContactDetailObj *anItem = [[ContactDetailObj alloc] init];
                    anItem._iconStr = @"btn_contacts_work.png";
                    anItem._titleStr = [localization localizedStringForKey:text_phone_work];
                    anItem._valueStr = [self removeAllSpecialInString:phoneNumber];
                    anItem._buttonStr = @"contact_detail_icon_call.png";
                    anItem._typePhone = type_phone_work;
                    [result addObject: anItem];
                }else if (CFStringCompare(locLabel, kABPersonPhoneMobileLabel, 0) == kCFCompareEqualTo)
                {
                    ContactDetailObj *anItem = [[ContactDetailObj alloc] init];
                    anItem._iconStr = @"btn_contacts_mobile.png";
                    anItem._titleStr = [localization localizedStringForKey:text_phone_mobile];
                    anItem._valueStr = [self removeAllSpecialInString:phoneNumber];
                    anItem._buttonStr = @"contact_detail_icon_call.png";
                    anItem._typePhone = type_phone_mobile;
                    [result addObject: anItem];
                }else if (CFStringCompare(locLabel, kABPersonPhoneHomeFAXLabel, 0) == kCFCompareEqualTo)
                {
                    ContactDetailObj *anItem = [[ContactDetailObj alloc] init];
                    anItem._iconStr = @"btn_contacts_fax.png";
                    anItem._titleStr = [localization localizedStringForKey:text_phone_fax];
                    anItem._valueStr = [self removeAllSpecialInString:phoneNumber];
                    anItem._buttonStr = @"contact_detail_icon_call.png";
                    anItem._typePhone = type_phone_fax;
                    [result addObject: anItem];
                }else if (CFStringCompare(locLabel, kABOtherLabel, 0) == kCFCompareEqualTo)
                {
                    ContactDetailObj *anItem = [[ContactDetailObj alloc] init];
                    anItem._iconStr = @"btn_contacts_fax.png";
                    anItem._titleStr = [localization localizedStringForKey:text_phone_other];
                    anItem._valueStr = [self removeAllSpecialInString:phoneNumber];
                    anItem._buttonStr = @"contact_detail_icon_call.png";
                    anItem._typePhone = type_phone_other;
                    [result addObject: anItem];
                }else{
                    ContactDetailObj *anItem = [[ContactDetailObj alloc] init];
                    anItem._iconStr = @"btn_contacts_mobile.png";
                    anItem._titleStr = [localization localizedStringForKey:text_phone_mobile];
                    anItem._valueStr = [self removeAllSpecialInString:phoneNumber];
                    anItem._buttonStr = @"contact_detail_icon_call.png";
                    anItem._typePhone = type_phone_mobile;
                    [result addObject: anItem];
                }
            }
        }
    }
    return result;
}

//  Hàm loại bỏ tất cả các ký tự ko là số ra khỏi chuỗi
- (NSString *)removeAllSpecialInString: (NSString *)phoneString {
    
    NSString *resultStr = @"";
    for (int strCount=0; strCount<phoneString.length; strCount++) {
        char characterChar = [phoneString characterAtIndex: strCount];
        NSString *characterStr = [NSString stringWithFormat:@"%c", characterChar];
        if ([listNumber containsObject: characterStr]) {
            resultStr = [NSString stringWithFormat:@"%@%@", resultStr, characterStr];
        }
    }
    return resultStr;
}

- (NSString *)getAvatarOfContact: (ABRecordRef)aPerson
{
    NSString *avatar = @"";
    if (aPerson != nil) {
        NSData  *imgData = (__bridge NSData *)ABPersonCopyImageData(aPerson);
        if (imgData != nil) {
            UIImage *imageAvatar = [UIImage imageWithData: imgData];
            CGRect rect = CGRectMake(0,0,120,120);
            UIGraphicsBeginImageContext(rect.size );
            [imageAvatar drawInRect:rect];
            UIImage *picture1 = UIGraphicsGetImageFromCurrentImageContext();
            UIGraphicsEndImageContext();
            NSData *tmpImgData = UIImagePNGRepresentation(picture1);
            if ([[[UIDevice currentDevice] systemVersion] floatValue] >= 7) {
                avatar = [tmpImgData base64EncodedStringWithOptions: 0];
            }
        }
    }
    return avatar;
}

- (NSString *)getSipIdOfContact: (ABRecordRef)aPerson {
    if (aPerson != nil) {
        NSString *sipNumber = (__bridge NSString *)ABRecordCopyValue(aPerson, kABPersonFirstNamePhoneticProperty);
        if (sipNumber == nil) {
            sipNumber = @"";
        }
        [sipNumber stringByReplacingOccurrencesOfString:@"'" withString:@"''"];
        return sipNumber;
    }
    return @"";
}

// copy database
- (void)copyFileDataToDocument : (NSString *)filename {
    NSArray *arrPath = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentPath = [arrPath objectAtIndex:0];
    NSString *pathString = [documentPath stringByAppendingPathComponent:filename];
    _databasePath = [[NSString alloc] initWithString: pathString];
    NSFileManager *fileManager = [NSFileManager defaultManager];
    
    [fileManager setAttributes:[NSDictionary dictionaryWithObject:NSFileProtectionNone forKey:NSFileProtectionKey] ofItemAtPath:[NSHomeDirectory() stringByAppendingFormat:@"/Documents"] error:NULL];
    
    if (![fileManager fileExistsAtPath:pathString]) {
        NSError *error;
        @try {
            NSString *bundlePath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:filename];
            [fileManager copyItemAtPath:bundlePath toPath:pathString error:&error];
            if (error != nil ) {
                //                @throw [NSException exceptionWithName:@"Error copy file ! " reason:@"Can not copy file to Document" userInfo:nil];
            }
        }
        @catch (NSException *exception) {
            NSLog(@"%@",exception.description);
        }
    }
}

//   Tạo folder cho ghi âm cuộc gọi
- (void)createFolderRecordsIfNotExists: (NSString *)folderName
{
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    NSString *documentsDirectory = [paths objectAtIndex:0];
    
    // Kiểm tra folder có tồn tại hay không?
    NSString *folderPath = [documentsDirectory stringByAppendingPathComponent:[NSString stringWithFormat:@"/%@", folderName]];
    BOOL isDir;
    BOOL exists = [fileManager fileExistsAtPath:folderPath isDirectory:&isDir];
    if (!exists) {
        [[NSFileManager defaultManager] createDirectoryAtPath:folderPath withIntermediateDirectories:NO attributes:nil error: nil];
    }else {
        NSLog(@"%@", [NSString stringWithFormat:@"Folder %@ da ton tai", folderName]);
    }
}

- (NSString *)getNameOfContactWithPhoneNumber: (NSString *)phonenumber
{
    NSString *fullName = @"";
    
    NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_sipPhone == %@", phonenumber];
    NSArray *filter = [listContacts filteredArrayUsingPredicate: predicate];
    if (filter.count > 0) {
        ContactObject *aContact = [filter objectAtIndex: 0];
        fullName = aContact._fullName;
    }else{
        for (int iCount=0; iCount<listContacts.count; iCount++) {
            ContactObject *contact = [listContacts objectAtIndex: iCount];
            predicate = [NSPredicate predicateWithFormat:@"_valueStr = %@", phonenumber];
            filter = [contact._listPhone filteredArrayUsingPredicate: predicate];
            if (filter.count > 0) {
                fullName = contact._fullName;
                break;
            }
        }
    }
    return fullName;
}

//  Add new by Khai Le on 01/12/2017
- (NSString *)getNameForCurrentPhoneNumber: (NSString *)callerId {
    NSString *result = @"";
    if ([callerId hasPrefix:@"778899"]) {
        result = callerId;
    }else{
        ABRecordRef contact = [self getPBXContactInPhoneBook];
        if (contact != nil) {
            result = [AppUtils getNameOfPhoneOfContact:contact andPhoneNumber:callerId];
            if ([result isEqualToString:@""]) {
                result = callerId;
            }else{
                result = [NSString stringWithFormat:@"%@ - %@", result, callerId];
            }
        }else{
            result = callerId;
        }
    }
    return result;
}

- (ABRecordRef)getPBXContactInPhoneBook
{
    ABAddressBookRef addressListBook = ABAddressBookCreateWithOptions(NULL, NULL);
    NSArray *arrayOfAllPeople = (__bridge  NSArray *) ABAddressBookCopyArrayOfAllPeople(addressListBook);
    NSUInteger peopleCounter = 0;
    
    for (peopleCounter = 0; peopleCounter < [arrayOfAllPeople count]; peopleCounter++)
    {
        ABRecordRef aPerson = (__bridge ABRecordRef)[arrayOfAllPeople objectAtIndex:peopleCounter];
        NSString *sipNumber = (__bridge NSString *)ABRecordCopyValue(aPerson, kABPersonFirstNamePhoneticProperty);
        if (sipNumber != nil && [sipNumber isEqualToString: keySyncPBX]) {
            return aPerson;
        }
    }
    return nil;
}

//- (BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray * _Nullable))restorationHandler
//{
////    [[NSUserDefaults standardUserDefaults] setObject:@"YES" forKey:@"isGoToHistoryCall"];
////    [[NSUserDefaults standardUserDefaults] synchronize];
////
////    [[NSUserDefaults standardUserDefaults] removeObjectForKey:@"isGoToHistoryCall"];
////    [[NSUserDefaults standardUserDefaults] synchronize];
//
//    //  Di chuyen den view history neu nguoi dung click vao history tu dien thoai de mo app
//    [PhoneMainView.instance changeCurrentView:CallsHistoryViewController.compositeViewDescription];
//
//    NSLog(@"%@", userActivity.activityType);
//    NSLog(@"%@", userActivity.title);
//    NSDictionary *info = userActivity.userInfo;
//    NSLog(@"%@", info);
//
//    return YES;
//}

-(BOOL)application:(UIApplication *)application continueUserActivity:(NSUserActivity *)userActivity restorationHandler:(void (^)(NSArray<id<UIUserActivityRestoring>> * _Nullable))restorationHandler {
    //  Di chuyen den view history neu nguoi dung click vao history tu dien thoai de mo app
    [PhoneMainView.instance changeCurrentView:CallsHistoryViewController.compositeViewDescription];
    
    NSLog(@"%@", userActivity.activityType);
    NSLog(@"%@", userActivity.title);
    NSDictionary *info = userActivity.userInfo;
    NSLog(@"%@", info);
    
    return YES;
}


#pragma mark - sync contact xmpp

- (void)addContactFromSyncXMPP: (NSNotification *)notif {
    id object = [notif object];
    if ([object isKindOfClass:[NSDictionary class]]) {
        NSString *Name = [object objectForKey:@"Name"];
        NSString *Avatar = [object objectForKey:@"Avatar"];
        NSString *Address = [object objectForKey:@"Address"];
        NSString *Email = [object objectForKey:@"Email"];
        NSString *sipPhone = [object objectForKey:@"CloudFoneID"];
        
        NSPredicate *predicate = [NSPredicate predicateWithFormat:@"_sipPhone == %@", sipPhone];
        NSArray *filter = [listContacts filteredArrayUsingPredicate: predicate];
        if (filter.count == 0) {
            //  Thêm contact mới vào phone book
            [self addNewContactToPhoneBookWithFirstName:Name LastName:@"" Company:@"" SipPhone:sipPhone Email:Email Avatar:Avatar ListPhone:nil Address:Address withContactId: 0];
        }else{
            //  Edit contact
            ContactObject *curContact = [filter objectAtIndex: 0];
            if (curContact != nil) {
                int idPerson = curContact._id_contact;
                ABRecordRef aPerson = ABAddressBookGetPersonWithRecordID(addressListBook, (int)idPerson);
                if (aPerson != nil)
                {
                    CFErrorRef  anError = NULL;
                    
                    //  Nếu tồn tại Name (của xmpp) thì cập nhật
                    if (Name != nil && ![Name isEqualToString: @""]) {
                        // Lưu thông tin
                        ABRecordSetValue(aPerson, kABPersonFirstNameProperty, (__bridge CFTypeRef)(Name), &anError);
                        ABRecordSetValue(aPerson, kABPersonLastNameProperty, (__bridge CFTypeRef)(@""), &anError);
                        
                    }
                    ABRecordSetValue(aPerson, kABPersonFirstNamePhoneticProperty, (__bridge CFTypeRef)(sipPhone), &anError);
                    
                    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                                @"SIP", (NSString*)kABPersonInstantMessageServiceKey,
                                                sipPhone, (NSString*)kABPersonInstantMessageUsernameKey, nil];
                    CFStringRef label = NULL; // in this case 'IM' will be set. But you could use something like = CFSTR("Personal IM");
                    CFErrorRef errorf = NULL;
                    ABMutableMultiValueRef values =  ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
                    BOOL didAdd = ABMultiValueAddValueAndLabel(values, (__bridge CFTypeRef)(dictionary), label, NULL);
                    BOOL didSet = ABRecordSetValue(aPerson, kABPersonInstantMessageProperty, values, &errorf);
                    
                    if (!didAdd || !didSet) {
                        CFStringRef errorDescription = CFErrorCopyDescription(errorf);
                        NSLog(@"%s error %@ while inserting multi dictionary property %@ into ABRecordRef", __FUNCTION__, dictionary, errorDescription);
                        CFRelease(errorDescription);
                    }
                    CFRelease(values);
                    
                    if (Email != nil && ![Email isEqualToString: @""]) {
                        // Lưu thông tin
                        ABMutableMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                        ABMultiValueAddValueAndLabel(email, (__bridge CFTypeRef)(Email), CFSTR("email"), NULL);
                        ABRecordSetValue(aPerson, kABPersonEmailProperty, email, &anError);
                    }
                    
                    if (Avatar != nil && ![Avatar isEqualToString: @""]) {
                        NSData *AvatarData = [NSData dataFromBase64String: Avatar];
                        if (AvatarData != nil) {
                            CFDataRef cfdata = CFDataCreate(NULL,[AvatarData bytes], [AvatarData length]);
                            ABPersonSetImageData(aPerson, cfdata, &anError);
                        }
                    }
                    
                    if (Address != nil && ![Address isEqualToString: @""]) {
                        ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
                        NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] init];
                        [addressDict setObject:Address forKey:(NSString *)kABPersonAddressStreetKey];
                        [addressDict setObject:@"" forKey:(NSString *)kABPersonAddressZIPKey];
                        [addressDict setObject:@"" forKey:(NSString *)kABPersonAddressStateKey];
                        [addressDict setObject:@"" forKey:(NSString *)kABPersonAddressCityKey];
                        [addressDict setObject:@"" forKey:(NSString *)kABPersonAddressCountryKey];
                        ABMultiValueAddValueAndLabel(address, (__bridge CFTypeRef)(addressDict), kABWorkLabel, NULL);
                        ABRecordSetValue(aPerson, kABPersonAddressProperty, address, &anError);
                    }
                    //  Danh sach contact hien tai
                    ABMutableMultiValueRef multiPhone = ABMultiValueCreateMutable(kABMultiStringPropertyType);
                    NSMutableArray *listPhone = [[NSMutableArray alloc] init];
                    
                    for (int iCount=0; iCount<curContact._listPhone.count; iCount++) {
                        ContactDetailObj *aPhone = [curContact._listPhone objectAtIndex: iCount];
                        if ([aPhone._typePhone isEqualToString: type_phone_mobile]) {
                            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(aPhone._valueStr), kABPersonPhoneMobileLabel, NULL);
                            [listPhone addObject: aPhone];
                        }else if ([aPhone._typePhone isEqualToString: type_phone_work]){
                            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(aPhone._valueStr), kABWorkLabel, NULL);
                            [listPhone addObject: aPhone];
                        }else if ([aPhone._typePhone isEqualToString: type_phone_fax]){
                            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(aPhone._valueStr), kABPersonPhoneHomeFAXLabel, NULL);
                            [listPhone addObject: aPhone];
                        }else if ([aPhone._typePhone isEqualToString: type_phone_home]){
                            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(aPhone._valueStr), kABHomeLabel, NULL);
                            [listPhone addObject: aPhone];
                        }else if ([aPhone._typePhone isEqualToString: type_phone_other]){
                            ABMultiValueAddValueAndLabel(multiPhone, (__bridge CFTypeRef)(aPhone._valueStr), kABOtherLabel, NULL);
                            [listPhone addObject: aPhone];
                        }
                    }
                    ABRecordSetValue(aPerson, kABPersonPhoneProperty, multiPhone,nil);
                    CFRelease(multiPhone);
                    
                    anError = nil;
                    BOOL isAdded = ABAddressBookAddRecord (addressListBook, aPerson,&anError);
                    
                    if(isAdded){
                        NSLog(@"added..");
                    }
                    if (anError != NULL) {
                        NSLog(@"ABAddressBookAddRecord %@", anError);
                    }
                    anError = NULL;
                    
                    BOOL isSaved = ABAddressBookSave (addressListBook,&anError);
                    if(isSaved){
                        NSLog(@"saved..");
                    }
                    
                    if (anError != NULL) {
                        NSLog(@"ABAddressBookSave %@", anError);
                    }
                }
            }
        }
    }
}

- (void)addNewContactToPhoneBookWithFirstName: (NSString *)FirstName LastName: (NSString *)LastName Company: (NSString *)Company SipPhone: (NSString *)SipPhone Email: (NSString *)Email Avatar: (NSString *)Avatar ListPhone: (NSArray *)ListPhone Address: (NSString *)Address withContactId: (int)contactId
{
    ABRecordRef aRecord = ABPersonCreate();
    CFErrorRef  anError = NULL;
    
    // Lưu thông tin
    ABRecordSetValue(aRecord, kABPersonFirstNameProperty, (__bridge CFTypeRef)(FirstName), &anError);
    ABRecordSetValue(aRecord, kABPersonLastNameProperty, (__bridge CFTypeRef)(LastName), &anError);
    ABRecordSetValue(aRecord, kABPersonOrganizationProperty, (__bridge CFTypeRef)(Company), &anError);
    ABRecordSetValue(aRecord, kABPersonFirstNamePhoneticProperty, (__bridge CFTypeRef)(SipPhone), &anError);
    
    ABMutableMultiValueRef email = ABMultiValueCreateMutable(kABMultiStringPropertyType);
    ABMultiValueAddValueAndLabel(email, (__bridge CFTypeRef)(Email), CFSTR("email"), NULL);
    ABRecordSetValue(aRecord, kABPersonEmailProperty, email, &anError);
    
    if (Avatar != nil && ![Avatar isEqualToString: @""]) {
        NSData *AvatarData = [NSData dataFromBase64String: Avatar];
        if (AvatarData != nil) {
            CFDataRef cfdata = CFDataCreate(NULL,[AvatarData bytes], [AvatarData length]);
            ABPersonSetImageData(aRecord, cfdata, &anError);
        }
    }
    
    // Instant Message
    NSDictionary *dictionary = [NSDictionary dictionaryWithObjectsAndKeys:
                                @"SIP", (NSString*)kABPersonInstantMessageServiceKey,
                                SipPhone, (NSString*)kABPersonInstantMessageUsernameKey, nil];
    CFStringRef label = NULL; // in this case 'IM' will be set. But you could use something like = CFSTR("Personal IM");
    CFErrorRef errorf = NULL;
    ABMutableMultiValueRef values =  ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    BOOL didAdd = ABMultiValueAddValueAndLabel(values, (__bridge CFTypeRef)(dictionary), label, NULL);
    BOOL didSet = ABRecordSetValue(aRecord, kABPersonInstantMessageProperty, values, &errorf);
    if (!didAdd || !didSet) {
        CFStringRef errorDescription = CFErrorCopyDescription(errorf);
        NSLog(@"%s error %@ while inserting multi dictionary property %@ into ABRecordRef", __FUNCTION__, dictionary, errorDescription);
        CFRelease(errorDescription);
    }
    CFRelease(values);
    
    //Address
    ABMutableMultiValueRef address = ABMultiValueCreateMutable(kABMultiDictionaryPropertyType);
    NSMutableDictionary *addressDict = [[NSMutableDictionary alloc] init];
    [addressDict setObject:Address forKey:(NSString *)kABPersonAddressStreetKey];
    [addressDict setObject:@"" forKey:(NSString *)kABPersonAddressZIPKey];
    [addressDict setObject:@"" forKey:(NSString *)kABPersonAddressStateKey];
    [addressDict setObject:@"" forKey:(NSString *)kABPersonAddressCityKey];
    [addressDict setObject:@"" forKey:(NSString *)kABPersonAddressCountryKey];
    ABMultiValueAddValueAndLabel(address, (__bridge CFTypeRef)(addressDict), kABWorkLabel, NULL);
    ABRecordSetValue(aRecord, kABPersonAddressProperty, address, &anError);
    
    if (anError != NULL) {
        NSLog(@"error while creating..");
    }
    
    CFStringRef firstName, lastName, company;
    firstName = ABRecordCopyValue(aRecord, kABPersonFirstNameProperty);
    lastName  = ABRecordCopyValue(aRecord, kABPersonLastNameProperty);
    company  = ABRecordCopyValue(aRecord, kABPersonOrganizationProperty);
    
    ABAddressBookRef addressBook;
    CFErrorRef error = NULL;
    addressBook = ABAddressBookCreateWithOptions(nil, &error);
    
    BOOL isAdded = ABAddressBookAddRecord (addressBook,aRecord,&error);
    
    if(isAdded){
        NSLog(@"added..");
    }
    if (error != NULL) {
        NSLog(@"ABAddressBookAddRecord %@", error);
    }
    error = NULL;
    
    BOOL isSaved = ABAddressBookSave (addressBook,&error);
    if(isSaved){
        NSLog(@"saved..");
    }
    
    if (error != NULL) {
        NSLog(@"ABAddressBookSave %@", error);
    }

    CFRelease(aRecord);
    CFRelease(firstName);
    CFRelease(lastName);
    CFRelease(company);
    CFRelease(email);
    CFRelease(addressBook);
}

- (void)joinedGroupChat: (NSNotification *)notif {
    id object = [notif object];
    if ([object isKindOfClass:[XMPPRoom class]]) {
        XMPPRoom *room = (XMPPRoom *)object;
        [self getUserInChatRoom: room.roomJID.user];
    }
}

- (void)getUserInChatRoom: (NSString *)roomName
{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        //  CFRunLoopWakeUp(CFRunLoopGetCurrent());
        NSString *strURL = [NSString stringWithFormat:@"%@/%@", link_api, GetUserInChatRoom];
        NSURL *URL = [NSURL URLWithString:strURL];
        NSMutableURLRequest *request = [[NSMutableURLRequest alloc] initWithURL: URL];
        [request setTimeoutInterval: 60];
        
        NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
        [jsonDict setObject:AuthUser forKey:@"AuthUser"];
        [jsonDict setObject:AuthKey forKey:@"AuthKey"];
        [jsonDict setObject:roomName forKey:@"ID"];
        
        NSString *jsonRequest = [jsonDict JSONString];
        NSData *requestData = [jsonRequest dataUsingEncoding:NSUTF8StringEncoding];
        
        [request setHTTPMethod:@"POST"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Accept"];
        [request setValue:@"application/json" forHTTPHeaderField:@"Content-Type"];
        
        [request setValue:[NSString stringWithFormat:@"%d", (int)[requestData length]] forHTTPHeaderField:@"Content-Length"];
        [request setHTTPBody: requestData];
        
        [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse *response, NSData *data, NSError *error){
            if (data){
                //do something with data
                NSString *value = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
                id object = [value objectFromJSONString];
                NSString *result = [object objectForKey:@"result"];
                if (result != nil && [result isEqualToString:@"success"]) {
                    id data = [object objectForKey:@"data"];
                    if ([data isKindOfClass:[NSArray class]]) {
                        [self saveListMember: data forRoomChat: roomName];
                    }
                }
            }
            else if (error)
                NSLog(@"%@",error);
        }];
    });
}

- (void)saveListMember: (NSArray *)listMembers forRoomChat: (NSString *)roomName
{
    dispatch_async(dispatch_get_main_queue(), ^{
        [NSDatabase removeAllUserInGroupChat: roomName];
        for (int iCount=0; iCount<listMembers.count; iCount++) {
            NSDictionary *member = [listMembers objectAtIndex: iCount];
            NSString *userName = [member objectForKey:@"userName"];
            if (userName != nil) {
                NSString *user = [AppUtils getSipFoneIDFromString: userName];
                [NSDatabase saveUser:user toRoomChat:roomName forAccount:USERNAME];
            }
        }
    });
}

- (void)joinAllGroupGetFromServer {
    //  Xoa cac user da luu
    [NSDatabase removeAllUserInGroupChat];
    
    NSString *key = [NSString stringWithFormat:@"GROUPS_%@", USERNAME];
    NSString *groupIds = [[NSUserDefaults standardUserDefaults] objectForKey: key];
    
    if (groupIds != nil && ![groupIds isEqualToString:@""]) {
        NSArray *roomArr = [groupIds componentsSeparatedByString:@","];
        for (int iCount=0; iCount<roomArr.count; iCount++) {
            NSString *roomId = [roomArr objectAtIndex: iCount];
            [myBuddy.protocol acceptJoinToRoomChat: roomId];
        }
    }
}

- (void)reloginToXMPPServer {
    [self pingForConnectToXMPPServer];
}

- (void)pingForConnectToXMPPServer {
    UILocalNotification *messageNotif = [[UILocalNotification alloc] init];
    messageNotif.fireDate = [NSDate dateWithTimeIntervalSinceNow: 0.1];
    messageNotif.timeZone = [NSTimeZone defaultTimeZone];
    messageNotif.timeZone = [NSTimeZone defaultTimeZone];
    messageNotif.soundName = UILocalNotificationDefaultSoundName;
    
    if (!xmppStream.isConnected) {
        messageNotif.alertBody = @"reconnectToXMPPServer";
        [[UIApplication sharedApplication] scheduleLocalNotification: messageNotif];
        
        [AppUtils reconnectToXMPPServer];
    }else{
        messageNotif.alertBody = @"pingForConnectToServer";
        [[UIApplication sharedApplication] scheduleLocalNotification: messageNotif];
        
        [myBuddy.protocol pingForConnectToServer];
    }
}

+(LinphoneAppDelegate*) sharedInstance{
    return ((LinphoneAppDelegate*) [[UIApplication sharedApplication] delegate]);
}

#pragma mark - Web services delegate
- (void)updateCustomerTokenIOS {
    NSMutableDictionary *jsonDict = [[NSMutableDictionary alloc] init];
    [jsonDict setObject:AuthUser forKey:@"AuthUser"];
    [jsonDict setObject:AuthKey forKey:@"AuthKey"];
    [jsonDict setObject:USERNAME forKey:@"UserName"];
    [jsonDict setObject:_deviceToken forKey:@"IOSToken"];
    
    [webService callWebServiceWithLink:ChangeCustomerIOSToken withParams:jsonDict];
}

- (void)failedToCallWebService:(NSString *)link andError:(NSString *)error {
    if ([link isEqualToString:ChangeCustomerIOSToken]) {
        _updateTokenSuccess = false;
    }
}

- (void)successfulToCallWebService:(NSString *)link withData:(NSDictionary *)data {
    if ([link isEqualToString:ChangeCustomerIOSToken]) {
        _updateTokenSuccess = true;
    }
}

-(void)receivedResponeCode:(NSString *)link withCode:(int)responeCode {
    
}


-(void) startKeepAwake
{
    // the iOS4 device will sleep after 10seconds of inactivity
    // On iOS4, playing the sound each 10seconds doesn't work as the system will imediately frozen
    // if you stop playing the sound. The only solution is to play it in loop. This is why
    // the 'repeats' parameter is equal to 'NO'.
    keepAwakeTimer = [[NSTimer alloc] initWithFireDate:[NSDate dateWithTimeIntervalSinceNow:0]
                                              interval:6.f
                                                target:self
                                              selector:@selector(keepAwakeCallback)
                                              userInfo:nil
                                               repeats:YES];
    [[NSRunLoop currentRunLoop] addTimer:keepAwakeTimer forMode:NSRunLoopCommonModes];
}

-(void)keepAwakeCallback{
    AVAudioPlayer *playerKeepAwake;
    if(!playerKeepAwake){
        playerKeepAwake = [self createPlayerWithPath:@"keepawake.wav"];
    }
    if(playerKeepAwake){
        //        UInt32 doSetProperty = TRUE;
        //        [[AVAudioSession sharedInstance] setCategory: AVAudioSessionCategoryPlayAndRecord error: nil];
        //        AudioSessionSetProperty (kAudioSessionProperty_OverrideCategoryMixWithOthers, sizeof(doSetProperty), &doSetProperty);
        
        playerKeepAwake.numberOfLoops = -1;
        [playerKeepAwake play];
    }
}

-(AVAudioPlayer*)createPlayerWithPath:(NSString*)path{
    NSURL *url = [NSURL fileURLWithPath:[NSString stringWithFormat:@"%@/%@", [[NSBundle mainBundle] resourcePath], path]];
    
    NSError *error;
    AVAudioPlayer *player = [[AVAudioPlayer alloc] initWithContentsOfURL:url error:&error];
    if (player == nil){
        NSLog(@"Failed to create audio player(%@): %@", path, error);
    }
    return player;
}

@end
