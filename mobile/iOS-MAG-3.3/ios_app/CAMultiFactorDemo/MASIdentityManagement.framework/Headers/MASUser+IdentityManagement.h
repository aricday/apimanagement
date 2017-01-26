//
//  MASUser+IdentityManagement.h
//  MASIdentityManagement
//
//  Copyright (c) 2016 CA. All rights reserved.
//
//  This software may be modified and distributed under the terms
//  of the MIT license. See the LICENSE file for details.
//

#import <MASFoundation/MASFoundation.h>


@class MASFilteredRequest;


/**
 * The supported SCIM attribute options.
 */
typedef NS_OPTIONS(NSInteger, MASUserAttributes)
{
    MASUserAttributeAll = 1 << 0,
    MASUserAttributeName = 1 << 1,
    MASUserAttributeUserName = 1 << 2,
    MASUserAttributeActive = 1 << 3,
    MASUserAttributeAddresses = 1 << 4,
    MASUserAttributeEmailAddresses = 1 << 5,
    MASUserAttributeGroups = 1 << 6,
    MASUserAttributePhoneNumbers = 1 << 7,
    MASUserAttributePhotos = 1 << 8
};


/**
 *  This category enables Identity Management feature to the authenticated user
 */
@interface MASUser (IdentityManagement)



# pragma mark - User Retrieval

///--------------------------------------
/// @name User Retrieval
///--------------------------------------


/**
 * Retrieves an array of 'MASUser' with various sorting, paging and included/excluded attribute options.
 *
 * @param sortByAttribute An attribute of the 'MASUser' that can be used to sort the results. (optional)
 * @param sortOrder The 'MASFilteringRequestSortOrder' direction of the results.  Valid values are
 *     'MASFilteringRequestSortOrderAscending' and 'MASFilteringRequestSortOrderDescending'.
 * @param pageRange 'NSRange' containing pagination values.
 * @param includedAttributes 'NSArray' of 'NSString' attribute names to include in the results for each object.
 *     Note, if there attribute names included the excluded attributes are ignored. (optional)
 * @param excludedAttributes 'NSArray' of 'NSString' attribute names to exclude from the results for each object.
 *     Note, these will only take effect if there are no 'includedAttributes'. (optional)
 * @param completion Completion block with either the array of 'MASUser' or 'NSError'.
 */
+ (void)getAllUsersSortedByAttribute:(nullable NSString *)sortByAttribute
                           sortOrder:(MASFilteredRequestSortOrder)sortOrder
                           pageRange:(NSRange)pageRange
                  includedAttributes:(nullable NSArray *)includedAttributes
                  excludedAttributes:(nullable NSArray *)excludedAttributes
                          completion:(nullable void (^)(NSArray * _Nullable userList, NSError * _Nullable error, NSUInteger totalResults))completion;


/**
 * Retrieves all 'MASUser' objects that matches the userName parameter. It is a complete match, not a
 * partial match. It uses a default of 10 for the itemsPerPage for the pagination.
 *
 * @param value The 'NSString' full user name to match.
 * @param sortByAttribute An attribute of the 'MASUser' that can be used to sort the results. (optional)
 * @param sortOrder The 'MASFilteringRequestSortOrder' direction of the results.  Valid values are
 *     'MASFilteringRequestSortOrderAscending' and 'MASFilteringRequestSortOrderDescending'.
 * @param pageRange 'NSRange' containing pagination values.
 * @param includedAttributes 'NSArray' of 'NSString' attribute names to include in the results for each object.
 *     Note, if there attribute names included the excluded attributes are ignored. (optional)
 * @param excludedAttributes 'NSArray' of 'NSString' attribute names to exclude from the results for each object.
 *     Note, these will only take effect if there are no 'includedAttributes'. (optional)
 * @param completion Completion block with either the array of 'MASUser' or the 'NSError'.
 */
+ (void)getAllUsersWithUsernameContaining:(nonnull NSString *)value
                          sortByAttribute:(nullable NSString *)sortByAttribute
                                sortOrder:(MASFilteredRequestSortOrder)sortOrder
                                pageRange:(NSRange)pageRange
                       includedAttributes:(nullable NSArray *)includedAttributes
                       excludedAttributes:(nullable NSArray *)excludedAttributes
                               completion:(nullable void (^)(NSArray * _Nullable userList, NSError * _Nullable error, NSUInteger totalResults))completion;


/**
 * Retrieves a 'MASUser' matching the objectId.
 *
 * @param objectId The object id used to locate the 'MASUser'.
 * @param completion Completion block with either the 'MASUser' or 'NSError'.
 */
+ (void)getUserByObjectId:(nonnull NSString *)objectId
               completion:(nullable void (^)(MASUser * _Nullable user, NSError * _Nullable error))completion;


/**
 * Retrieves a 'MASUser' matching the objectId with specific attributes.
 *
 * @param objectId The object id used to locate the 'MASUser'.
 * @param includedAttributes 'NSArray' of 'NSString' attribute names to include in the results for each object.
 *     Note, if there attribute names included the excluded attributes are ignored. (optional)
 * @param excludedAttributes 'NSArray' of 'NSString' attribute names to exclude from the results for each object.
 *     Note, these will only take effect if there are no 'includedAttributes'. (optional)
 * @param completion Completion block with either the 'MASUser' or 'NSError'.
 */
+ (void)getUserByObjectId:(nonnull NSString *)objectId
       includedAttributes:(nullable NSArray *)includedAttributes
       excludedAttributes:(nullable NSArray *)excludedAttributes
               completion:(nullable void (^)(MASUser * _Nullable user, NSError * _Nullable error))completion;


/**
 * Retrieves a 'MASUser' matching the user name.
 *
 * @param userName The user name used to locate the 'MASUser'.
 * @param completion Completion block with either the 'MASUser' or 'NSError'.
 */
+ (void)getUserByUserName:(nonnull NSString *)userName
               completion:(nullable void (^)(MASUser * _Nullable user, NSError * _Nullable error))completion;


/**
 * Retrieves a 'MASUser' by matching user name.  This is a full 'equalsTo' comparison.
 *
 * @param objectId The object id used to locate the 'MASUser'.
 * @param includedAttributes 'NSArray' of 'NSString' attribute names to include in the results for each object.
 *     Note, if there attribute names included the excluded attributes are ignored. (optional)
 * @param excludedAttributes 'NSArray' of 'NSString' attribute names to exclude from the results for each object.
 *     Note, these will only take effect if there are no 'includedAttributes'. (optional)
 * @param completion Completion block with either the MASUser object or the Error message
 */
+ (void)getUserByUserName:(nonnull NSString *)userName
       includedAttributes:(nullable NSArray *)includedAttributes
       excludedAttributes:(nullable NSArray *)excludedAttributes
               completion:(nullable void (^)(MASUser * _Nullable user, NSError * _Nullable error))completion;



# pragma mark - Filtered Request User Retrieval

///---------------------------------------------
/// @name Filtered Request User Retrieval
///---------------------------------------------


/**
 * Retrieves 'MASUser' objects that matches the 'MASFilteredRequest'.
 *
 * @param filter The 'MASFilteredRequest; to filter results.
 * @param completion Completion block with either the array of 'MASUser' objects or the 'NSError'.
 */
+ (void)getUsersByFilteredRequest:(nonnull MASFilteredRequest *)filteredRequest
                       completion:(nullable void (^)(NSArray * _Nullable userList, NSError * _Nullable error, NSUInteger totalResults))completion;



# pragma mark - Advanced Filtering User Retrieval

///----------------------------------------
/// @name Advanced Filtering User Retrieval
///----------------------------------------


/**
 * Retrieves 'MASUser' objects that matches the custom built filter expression and additional options.
 *
 * @param filterExpression The custom build 'NSString' filter expression.
 * @param sortByAttribute An attribute of the 'MASUser' that can be used to sort the results. (optional)
 * @param sortOrder The 'MASFilteringRequestSortOrder' direction of the results.  Valid values are
 *     'MASFilteringRequestSortOrderAscending' and 'MASFilteringRequestSortOrderDescending'.
 * @param pageRange 'NSRange' containing pagination values.
 * @param includedAttributes 'NSArray' of 'NSString' attribute names to include in the results for each object.
 *     Note, if there attribute names included the excluded attributes are ignored. (optional)
 * @param excludedAttributes 'NSArray' of 'NSString' attribute names to exclude from the results for each object.
 *     Note, these will only take effect if there are no 'includedAttributes'. (optional)
 * @param completion Completion block with either the array of 'MASUser' objects or NSError.
 */
+ (void)getUsersByFilterExpression:(nonnull NSString *)filterExpression
                   sortByAttribute:(nullable NSString *)sortByAttribute
                         sortOrder:(MASFilteredRequestSortOrder)sortOrder
                         pageRange:(NSRange)pageRange
                includedAttributes:(nullable NSArray *)includedAttributes
                excludedAttributes:(nullable NSArray *)excludedAttributes
                        completion:(nullable void (^)(NSArray * _Nullable userList, NSError * _Nullable error, NSUInteger totalResults))completion;



# pragma mark - User Image Retrieval

///--------------------------------------
/// @name User Image Retrieval
///--------------------------------------


/**
 * Retrieve the thumbnail 'UIImage' of the 'MASUser'.
 *
 * @param completion Completion block with either the retrieved 'UIImage' or 'NSError'.
 */
- (void)getThumbnailImageWithCompletion:(nullable void (^)(UIImage * _Nullable image, NSError * _Nullable error))completion;



# pragma mark - Instance Methods

///--------------------------------------
/// @name Instance Methods
///--------------------------------------


/**
 * Returns the value associated with a given key.
 *
 * @param key The given identifying key for which to return the corresponding value.
 * @return The value associated with a given key.
 */
- (nullable id)objectForKey:(nonnull id)key;


/**
 * Sets the object associated with a given key.
 *
 * @param object The object for `key`. A strong reference to the object is maintaned by MASObject.
 *   Raises an `NSInvalidArgumentException` if `object` is `nil`.  If you need to represent a `nil`
 *   value - use `NSNull`.
 *
 * @param key The key for `object`. Raises an `NSInvalidArgumentException` if `key` is `nil`.
 */
- (void)setObject:(nonnull id)object forKey:(nonnull id <NSCopying>)key;


/**
 * Returns the value associated with a given key.
 *
 * @discussion This method enables usage of literal syntax on `MASObject`. E.g. `NSString *value = object[@"key"];`
 *
 * @param key The key for which to return the corresponding value.
 * @return The value associated with a given key.
 */
- (nullable id)objectForKeyedSubscript:(nonnull id)key;


/**
 * Returns the value associated with a given key.
 *
 * @discussion This method enables usage of literal syntax on `MASObject`. E.g. `object[@"key"] = @"value";`
 *
 * @param object The object for `key`. A strong reference to the object is maintaned by PFObject.
 *   Raises an `NSInvalidArgumentException` if `object` is `nil`.
 *   If you need to represent a `nil` value - use `NSNull`.
 * @param key The key for `object`. Raises an `NSInvalidArgumentException` if `key` is `nil`.
 */
- (void)setObject:(nonnull id)object forKeyedSubscript:(nonnull id <NSCopying>)key;



# pragma mark - Print Attributes

///--------------------------------------
/// @name Print Attributes
///--------------------------------------


/**
 * List all attributes from the Object.
 */
- (void)listAttributes;

@end
