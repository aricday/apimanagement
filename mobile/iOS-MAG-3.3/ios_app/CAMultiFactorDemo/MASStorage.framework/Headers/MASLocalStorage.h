//
//  MASLocalStorage.h
//  MASStorage
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <Foundation/Foundation.h>
#import <MASFoundation/MASFoundation.h>

/**
 *  Cloud Storage Segment
 */
typedef NS_ENUM(NSInteger, MASLocalStorageSegment) {
    /**
     *  Unknown Mode
     */
    MASLocalStorageSegmentUnknown = -1,
    /**
     *  Data in this mode is stored and available in an Application Level
     */
    MASLocalStorageSegmentApplication,
    /**
     *  Data in this mode is stored and available in an Application for a specific User
     */
    MASLocalStorageSegmentApplicationForUser
};


/**
 *  This class exposes Local Storage features
 */
@interface MASLocalStorage : NSObject


# pragma mark - Lifecycle

/**
 *  Singleton instance of MASLocalStorage.
 *
 *  It creates the local storage database in case it doesn't exist
 *
 *  @return Singleton instance of MASLocalStorage.
 */
+ (nonnull instancetype)enableLocalStorage;


#pragma mark - Find methods

/**
 *  Find an object from Local Storage based on a specific key
 *
 *  @param key        The key used to get the object from local storage
 *  @param mode       The MASStorageMode to be used in the search
 *  @param completion A (MASObject *object, NSError *error) completion block
 */
+ (void)findObjectUsingKey:(nonnull NSString *)key
                      mode:(MASLocalStorageSegment)mode
                completion:(nullable void (^)(MASObject * _Nullable object, NSError * _Nullable error))completion;



/**
 *  Find objects in Local Storage based on the MASStorageMode
 *
 *  @param mode       The MASStorageMode to be used in the search
 *  @param completion A (NSArray *objects, NSError *error) completion block
 */
+ (void)findObjectsUsingMode:(MASLocalStorageSegment)mode
                  completion:(nullable void (^)(NSArray * _Nullable objects, NSError * _Nullable error))completion;



#pragma mark - Save/Update method

/**
 *  Save an object into Local Storage.
 *
 *  @param object     Object to be saved. It must conform to NSObject
 *  @param key        Key to be used when saving the object.
 *  @param type       Type of the object been saved.
 *  @param mode       The MASStorageMode to be used in the search
 *  @param completion The standard (BOOL success, NSError *error) completion block
 */
+ (void)saveObject:(nonnull NSObject *)object
           withKey:(nonnull NSString *)key
              type:(nonnull NSString *)type
              mode:(MASLocalStorageSegment)mode
        completion:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;



/**
 *  Save an object with encryption to Local Storage.
 *
 *  @param object     Object to be saved. It must conform to NSObject
 *  @param key        Key to be used when saving the object.
 *  @param type       Type of the Object been saved.
 *  @param mode       The MASStorageMode to be used in the search
 *  @param password   Password used for encryption.
 *  @param completion The standard (BOOL success, NSError *error) completion block
 */
+ (void)saveObject:(nonnull NSObject *)object
           withKey:(nonnull NSString *)key
              type:(nonnull NSString *)type
              mode:(MASLocalStorageSegment)mode
          password:(nonnull NSString *)password
        completion:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;



#pragma mark - Delete methods

/**
 *  Delete an object from Local Storage based on a given key
 *
 *  @param key        The key used to delete the object from the storage
 *  @param mode       The MASStorageMode to be used in the search
 *  @param completion The standard (BOOL success, NSError *error) completion block
 */
+ (void)deleteObjectUsingKey:(nonnull NSString *)key
                        mode:(MASLocalStorageSegment)mode
                  completion:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;



/**
 *  Delete all objects from local storage based on a given MASStorageMode
 *
 *  @param mode       The MASStorageMode to be used in the search
 *  @param completion The standard (BOOL success, NSError *error) completion block
 */
+ (void)deleteAllObjectsUsingMode:(MASLocalStorageSegment)mode
                       completion:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;


@end
