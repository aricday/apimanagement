//
//  MASConnectaConstants.h
//  MASConnecta
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

///--------------------------------------
/// @name Server API Topic Version
///--------------------------------------

static NSString *const apiTopicVersion = @"2.0";


///--------------------------------------
/// @name Error
///--------------------------------------

# pragma mark - Error

typedef NS_ENUM (NSUInteger, MASConnectaError)
{
    //
    // MQTT
    //
    MASConnectaErrorConnectingMQTT = 511001,
    MASConnectaErrorSubscribingMQTT = 511002,
    
    //
    // Validation
    //
    MASConnectaErrorMessageObjectNotSupported = 500001,
    MASConnectaErrorRecipientInvalidOrNil = 500002,
    MASConnectaErrorParameterInvalidOrNil = 500003,
    
    
    //
    // User
    //
    MASConnectaErrorUserInvalidOrNil = 530003,
    MASConnectaErrorUserNotAuthenticated = 530004,
    MASConnectaErrorUserSessionIsCurrentlyLocked = 530008,
};


#define kSDKErrorDomain     @"com.ca.MASConnecta:ErrorDomain"


///--------------------------------------
/// @name Enumerations
///--------------------------------------

# pragma mark - Enumerations

/**
 * Message Sender Type
 */
typedef NS_ENUM(NSInteger, MASSenderType)
{
    /**
     * Unknown
     */
    MASSenderTypeUnknown = -1,
    
    /**
     * MASApplication
     */
    MASSenderTypeApplication,
    
    /**
     * MASDevice
     */
    MASSenderTypeDevice,
    
    /**
     * MASGroup
     */
    MASSenderTypeGroup,
    
    /**
     * MASUser
     */
    MASSenderTypeUser
};


static NSString *const MASSenderTypeApplicationValue = @"APPLICATION";
static NSString *const MASSenderTypeDeviceValue = @"DEVICE";
static NSString *const MASSenderTypeGroupValue = @"GROUP";
static NSString *const MASSenderTypeUserValue = @"USER";



///--------------------------------------
/// @name Notifications
///--------------------------------------

# pragma mark - Notifications

/**
 * The NSString constant for the message received notification.
 */
static NSString *const MASConnectaMessageReceivedNotification = @"MASConnectaMessageReceivedNotification";


/**
 * The NSString constant for the message sent notification.
 */
static NSString *const MASConnectaMessageSentNotification = @"MASConnectaMessageSentNotification";



///--------------------------------------
/// @name Notification Keys
///--------------------------------------

# pragma mark - Notification Keys

/**
 * The NSString constant for the message key object within the userInfo of the notification.
 */
static NSString *const MASConnectaMessageKey = @"MASConnectaMessageKey";
