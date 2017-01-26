/*
*  RMDeviceInventory.h
*  Copyright (c) 2015 CA.  All rights reserved.  
*  This software and all information contained therein is confidential and proprietary 
*  and may not be duplicated, disclosed or reproduced in whole or in part for any purpose
*  except as authorized by the applicable license agreement, without the express written 
*  authorization of CA. All authorized reproductions must be marked with this language.  
*  
*  TO THE EXTENT PERMITTED BY APPLICABLE LAW, CA PROVIDES THIS SOFTWARE “AS IS” WITHOUT 
*  WARRANTY OF ANY KIND, INCLUDING WITHOUT LIMITATION, ANY IMPLIED WARRANTIES OF MERCHANTABILITY, 
*  FITNESS FOR A PARTICULAR PURPOSE OR NONINFRINGEMENT.  IN NO EVENT WILL CA BE LIABLE TO THE  
*  END USER OR ANY THIRD PARTY FOR ANY LOSS OR DAMAGE, DIRECT OR INDIRECT, FROM THE USE OF 
*  THIS MATERIAL, INCLUDING WITHOUT LIMITATION, LOST PROFITS, BUSINESS INTERRUPTION, GOODWILL, 
*  OR LOST DATA, EVEN IF CA IS EXPRESSLY ADVISED OF SUCH LOSS OR DAMAGE.
*/

/*
* This is header file provides interface to CA Mobile DDNA SDK for iOS platform
* It contains signtures of the SDK APIs along with input parameters and expected 
* return values.
*/
#import <Foundation/Foundation.h>

/*
* This is protocol defined for the application which is going to consume the 
* DDNA SDK on iOS platform. This protocol defines the delegation methods for
* notifying the application when device signature generated successfully.
*/
@protocol RMDeviceInventoryDelegate <NSObject>

/*
* This is callback method defined in DDNA SDK which is called back when SDK is finished 
* with collecting device DNA attributes values used for the generating device signature.
* 
* @param deviceDNA [in] device signature collected by DDNA sdk
*
* @return void
*/
@required
- (void)didCompletedCollectingDeviceDNA:(NSString *)deviceDNA;

/*
* This is callback method defined in DDNA SDK which is called back in case of error 
* occurance while collecting the device DNA attributes used for the generating device 
* signature.
*
* @param error [in] in case of failure, error returned by DDNA sdk
*
* @return void
*/

@optional
-(void) didFailWithError:(NSError *)error;
@end

/*
* SDK Operating mode
* Based on the operating mode, SDK will generate unique id as part of the device
* signature and passed in extra attributes bucket
* 
* SERVER : Server provides the unique identifier for the device
* USER   : Client SDK generated the unique identifier for the device which application
*          needs to store at persistent storage so that it can provided by application
*          everytime SDK gets initilized.
* CUSTOM : Customer application will provide unique identifier to the SDK evrytime SDK 
*          gets initialized.
*/
typedef enum {
    SERVER,
    USER,
    CUSTOM
} DDNA_MODE;

/*
* Enumeration identifier for device attributes which can be disabled by application.
* 
* If application wants to disable an attribute which is being used by DDNA SDK, then 
* application needs to use this identifier and pass it to disableAttributes() API. 
* SDK make use of this identifier while deriving device signature in the form of JSON 
* fromat. If an attribute is disabled by an application, the respective value for that
* in JSON for will have value "__DISABLE_ATTRIBUTE__"
* e.g. "accessoriesAttached": "__DISABLE_ATTRIBUTE__"
*/
typedef enum {
    RM_DEVICE_NAME,
    RM_DEVICE_TYPE_FORMAT,
    RM_DEBUGGER,
    RM_PROCESSOR_ACTIVE,
    RM_PROCESSOR_BUS_SPEED,
    RM_ACCESSORIES_ATTACHED,
    RM_ACCESSORIES_NUMBER,
    RM_ACCESSORIES_HEADPHONE,
    RM_CELL_BROADCAST_ADDRESS,
    RM_CELL_IP_ADDRESS,
    RM_CELL_NETMASK_ADDRESS,
    RM_WIFI_NETMASK_ADDRESS,
    RM_WIFI_BROADCAST,
    RM_WIFI_ROUTER,
    RM_PROCESS_NAME,
    RM_DEVICE_ORIENTATION,
    RM_LOCALIZATION_LANGUAGE,
    RM_LOCALIZATION_CURRENCY,
    RM_LOCALIZATION_MEASUREMENT,
    RM_EXTERNAL_IP,
    RM_LOCATION,
    RM_CUSTOM
} DDNA_ATTRIBUTES;

/*
* This SDK interface which application will use for the risk evaluation. This is singleton
* object used for the generation of device signature on the client side. It also provide  
* API interface to get device signature, set device id, generate unique identifier for the
* device it is running, set unique idenifier etc.
*/

@interface RMDeviceInventory : NSObject

-(instancetype) init __attribute__((unavailable("init not available")));

/*
* This is class method which returns the signleton object RMDeviceInventory, which can be
* used by application to call SDK APIs. It assumes default operating mode as SERVER, where
* server will unique generate the unque identifier for the device and application will
* set unique identifier within DDNA SDK.
* 
* @param void
*
* @return object instance of the RMDeviceInvetory class
*
*/

+ (instancetype)sharedInstance;

/*
* This is class method which returns the signleton object RMDeviceInventory, which can be
* used by application to call SDK APIs. Based on the operating mode, SDK will generate 
* unique id as part of the device signature and passed in extra attributes bucket.
* 
* SERVER : Server provides the unique identifier for the device
* USER   : Client SDK generated the unique identifier for the device which application
*          needs to store at persistent storage so that it can provided by application
*          everytime SDK gets initilized.
* CUSTOM : Customer application will provide unique identifier to the SDK evrytime SDK 
*          gets initialized.
* 
* @param mode [in] DDNA_MODE enumerator value. It can be one of the SERVER, USER and
*                  CUSTOM
*
* @return object instance of the RMDeviceInvetory class
*
*/

+ (instancetype)sharedInstance:(DDNA_MODE) mode;

/*
* The API collectDeviceDNA collects the  device DNA (device signature) based on the
* set of the device attributes. This method triggers device attribute collection and  
* notifies calling object when it is done with the generation of the device signature.
* This calls back the delegation method didCompletedCollectingDeviceDNA on the 
* RMDeviceInventoryDelegate reference.
*
* @param  id : [in] This is reference to RMDeviceInventoryDelegate protocol implemented 
*                   by the application using DDNA SDK. DDNA SDK makes a call to an API      
*                   didCompletedCollectingDeviceDNA() once SDK is finished with 
*                   generating device signature. With this call back method, SDK returns
*                   generated device DNA string in the calling object in the application.
*                      
*
* @return void   
*         
*         
*/
- (void)collectDeviceDNA:(id<RMDeviceInventoryDelegate>)delegate;

/*
* This API is variation of collectDeviceDNA() with additional input parameter 
* of timeout value. This timeout value is used for limiting the time we spend on 
* detecting device location.
* This collects the  device DNA (device signature) based on the set of the device 
* attributes. This method triggers device attribute collection and notifies  
* calling object when it is done with the generation of the device signature.  
* This API calls back the delegation method didCompletedCollectingDeviceDNA()  
* on the RMDeviceInventoryDelegate reference.
*
* @param  id : [in] This is reference to RMDeviceInventoryDelegate protocol implemented 
*                   by the application using DDNA SDK. DDNA SDK makes a call to an API  
*                   didCompletedCollectingDeviceDNA() once SDK is finished with 
*                   generating device signature. With this call back method, SDK returns
*                   generated device DNA string in the calling object in the application
*                      
*
* @param  withTimeout : [in] timeout value for location services. It will try to get
*                            location details for device within the timeout value 
*							 specified otherwise location details for longitude and
*                            lattitude will be null.
*
* @return void   
*         
*         
*/
- (void)collectDeviceDNA:(id<RMDeviceInventoryDelegate>)delegate withTimeout:(int) timeOut;

/*
* This API returns the device identifier set by the application by calling setRMDeviceId()
* API.
*
* @param  void
*                      
* @return device identifier for device, set by application for this device
*         by calling setRMDeviceId()
*         
*/
- (NSString *) getRMDeviceId;

/*
* This API sets the device identifier into SDK. The device identifier is received from the 
* server for this device.
*
* @param  rmDeviceId : [in] device identifier for this device
*                      
* @return void
*         
*/
- (void) setRMDeviceId:(NSString *)rmDeviceId;

/*
* This API returns the current IP address of the device. If device is connected to wi-fi
* then it returns wi-fi IP address otherwise it returns the cellular network ip address.
* If wi-fi/cellular network is disabled then in that case it is null.
*
* @param void
*                      
* @return current IP address of the device.
*         
*/
- (NSString *) currentIPAddress;

/*
* This API enables logging in case of error occured while collecting the device DNA 
* attributes.
*
* @param  val : [in] should be set to TRUE if application needs to enable logging for 
*                    DDNA SDK.
*                      
* @return void
*         
*/
- (void) setDebugLoggable:(BOOL) val;

/*
* Return the DDNA SDK version to the caller.
*
* @param  void
*                      
* @return version string value.
*         
*/
- (NSString *) getVersion;

/*
* Application uses this API to set the custom attributes which can used by SDK for 
* generating device signature. Application can pass the additional attributes as name
* value pairs in the dictionary object to this API. The SDK can use these additional
* attributes for generating device signature in JSON form. 
*
* @param  attrDictList : [in] This is dictionary object containing name-value pairs for
*                             custom attributes providd by the application. SDK can make
*                             use of these attributes while genrating device signature.
*                      
* @return void.
*         
*/
- (void) useCustomAttributes:(NSDictionary *) attrDictList;

/*
* Application uses this API to disable the attributes which are by DDNA SDK for generating
* device signature. To disable the attribute used by the SDK for generating device signature,
* application needs to pass attribute identifier defined by the DDNA_ATTRIBUTES enumerator 
* in the array object to this API. The DDNA SKD will disbale the attribute specified by the 
* DDNA_ATTRIBUTES identifier in the array list.
*  
* SDK make use of this identifier while deriving device signature in the form of JSON 
* format. If an attribute is disabled by an application, the respective value for that
* in JSON for will have value "__DISABLE_ATTRIBUTE__"
* e.g. "accessoriesAttached": "__DISABLE_ATTRIBUTE__"
*
* @param  attrList : [in] This is array object containing DDNA_ATTRIBUTES enumerator
*                         identifier for attributes used by the DDNA SDK. SDK will discard 
*                         the attribute value while generating device signature.
*                      
* @return void.
*         
*/
- (void) disableAttributes:(NSArray *) attrList;

/*
* This API returns unique identifier value saved into the NSUserDefaults settings. The
* setUniqueID() API sets the value of unique identifier into NSUserDefaults.
*
* @param  void
*                      
* @return returns the unique identifier string set by the application.
*         
*/
- (NSString *) getUniqueID;

/*
* This API sets the unique identifier (stored into keychain by an application) into SDK.
* Application can provide unique identifier on its own or it can use getCFUUID() API to
* generate the unique identifier for the SDK.  It will save the uniue identifier value 
* into the NSUserDefaults so that it can be fetched later by the DDNA SDK.
*
* @param  cfuuid : [in] unique identifier used in device signature
*                      
* @return void
*         
*/
- (void) setUniqueID:(NSString *) cfuuid;

/*
* This API returns CFUUID generated by the DDNA SDK. The application can make use of this
* API to generate the unique identifier and then it make a call to setUniueID() API to
* save this unique identifier into NSUserDefaults.
*
* @param  void
*                      
* @return returns the CFUUID value generated DDNA SDK.
*         
*/
- (NSString *) createCFUUID;

@end
