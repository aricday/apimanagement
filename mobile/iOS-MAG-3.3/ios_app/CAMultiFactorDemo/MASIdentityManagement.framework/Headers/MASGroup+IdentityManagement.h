//
//  MASGroup+IdentityManagement.h
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
 *  This category enables Identity Management features to the group object
 */
@interface MASGroup (IdentityManagement)


# pragma mark - Group Retrieval

///--------------------------------------
/// @name Group Retrieval
///--------------------------------------


/**
 * Retrieves an array of 'MASGroup'.  Note, this version has no paging or filtering at all.  You will
 * receive not only all of the 'MASGroup' instances, but all their fields as well.
 *
 * @param completion Completion block with either the array of 'MASGroup' or 'NSError'.
 */
+ (void)getAllGroupsWithCompletion:(nullable void (^)(NSArray * _Nullable groupList, NSError * _Nullable error, NSUInteger totalResults))completion;


/**
 * Retrieves an array of 'MASGroup' with various sorting, paging and included/excluded attribute options.
 *
 * @param sortByAttribute An attribute of the 'MASGroup' that can be used to sort the results. (optional)
 * @param sortOrder The 'MASFilteringRequestSortOrder' direction of the results.  Valid values are
 *     'MASFilteringRequestSortOrderAscending' and 'MASFilteringRequestSortOrderDescending'.
 * @param pageRange 'NSRange' containing pagination values.
 * @param includedAttributes 'NSArray' of 'NSString' attribute names to include in the results for each object.
 *     Note, if there attribute names included the excluded attributes are ignored. (optional)
 * @param excludedAttributes 'NSArray' of 'NSString' attribute names to exclude from the results for each object.
 *     Note, these will only take effect if there are no 'includedAttributes'. (optional)
 * @param completion Completion block with either the array of 'MASGroup' or 'NSError'.
 */
+ (void)getAllGroupsSortedByAttribute:(nonnull NSString *)sortByAttribute
                            sortOrder:(MASFilteredRequestSortOrder)sortOrder
                            pageRange:(NSRange)pageRange
                   includedAttributes:(nullable NSArray *)includedAttributes
                   excludedAttributes:(nullable NSArray *)excludedAttributes
                           completion:(nullable void (^)(NSArray * _Nullable groupList, NSError * _Nullable error, NSUInteger totalResults))completion;


/**
 * Retrieves a 'MASGroup' matching the objectId.
 *
 * @param objectId The object identifier used to locate the group.
 * @param completion Completion block with either the 'MASGroup' or 'NSError'.
 */
+ (void)getGroupByObjectId:(nonnull NSString *)objectId
                completion:(nullable void (^)(MASGroup * _Nullable group, NSError * _Nullable error))completion;


/**
 * Retrieves a 'MASGroup' object matching the objectId with specific attributes.
 *
 * @param objectId The object id used to locate the 'MASGroup'.
 * @param includedAttributes 'NSArray' of 'NSString' attribute names to include in the results for each object.
 *     Note, if there attribute names included the excluded attributes are ignored. (optional)
 * @param excludedAttributes 'NSArray' of 'NSString' attribute names to exclude from the results for each object.
 *     Note, these will only take effect if there are no 'includedAttributes'. (optional)
 * @param completion Completion block with either the 'MASGroup' or 'NSError'.
 */
+ (void)getGroupByObjectId:(nonnull NSString *)objectId
        includedAttributes:(nullable NSArray *)includedAttributes
        excludedAttributes:(nullable NSArray *)excludedAttributes
                completion:(nullable void (^)(MASUser * _Nullable user, NSError * _Nullable error))completion;


/**
 * Retrieves a 'MASGroup' matching the groupName.
 *
 * @param groupName The group name used to locate the 'MASGroup'.
 * @param completion Completion block with either the 'MASGroup' or 'NSError'.
 */
+ (void)getGroupByGroupName:(nonnull NSString *)groupName
                 completion:(nullable void (^)(MASGroup * _Nullable group, NSError * _Nullable error))completion;


/**
 * Retrieves a 'MASGroup' by matching group name, this is a full 'equalsTo' comparison.
 *
 * @param objectId The object id used to locate the 'MASGroup'.
 * @param includedAttributes 'NSArray' of 'NSString' attribute names to include in the results for each object.
 *     Note, if there attribute names included the excluded attributes are ignored. (optional)
 * @param excludedAttributes 'NSArray' of 'NSString' attribute names to exclude from the results for each object.
 *     Note, these will only take effect if there are no 'includedAttributes'. (optional)
 * @param completion Completion block with either the the 'MASGroup' or 'NSError'.
 */
+ (void)getGroupByGroupName:(nonnull NSString *)groupName
         includedAttributes:(nullable NSArray *)includedAttributes
         excludedAttributes:(nullable NSArray *)excludedAttributes
                 completion:(nullable void (^)(MASUser * _Nullable user, NSError * _Nullable error))completion;



# pragma mark - Filtered Request Group Retrieval

///---------------------------------------------
/// @name Filtered Request Group Retrieval
///---------------------------------------------


/**
 * Retrieves 'MASGroup' objects that matches the 'MASFilteredRequest'.
 *
 * @param filter The 'MASFilteredRequest; to filter results.
 * @param completion Completion block with either the array of 'MASGroup' objects or the 'NSError'.
 */
+ (void)getGroupsByFilteredRequest:(nonnull MASFilteredRequest *)filteredRequest
                        completion:(nullable void (^)(NSArray * _Nullable groupList, NSError * _Nullable error, NSUInteger totalResults))completion;



# pragma mark - Advanced Filtering Group Retrieval

///----------------------------------------
/// @name Advanced Filtering Group Retrieval
///----------------------------------------


/**
 * Retrieves 'MASGroup' objects that matches the custom built filter expression and additional options.
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
 * @param completion Completion block with either the array of 'MASGroup' objects or NSError.
 */
+ (void)getGroupsByFilterExpression:(nonnull NSString *)filterExpression
                    sortByAttribute:(nullable NSString *)sortByAttribute
                          sortOrder:(MASFilteredRequestSortOrder)sortOrder
                          pageRange:(NSRange)pageRange
                 includedAttributes:(nullable NSArray *)includedAttributes
                 excludedAttributes:(nullable NSArray *)excludedAttributes
                         completion:(nullable void (^)(NSArray * _Nullable groupList, NSError * _Nullable error, NSUInteger totalResults))completion;



# pragma mark - Instance Methods

///----------------------------------------
/// @name Instance Methods
///----------------------------------------

/**
 * Saves the group object in the cloud.
 *
 * @param completion Completion block with either the MASGroup object or the Error message.
 */
- (void)saveInBackgroundWithCompletion:(nullable void (^)(MASGroup * _Nullable group, NSError * _Nullable error))completion;


/**
 * Deletes the group object from the cloud.
 *
 * @param completion Completion block with either Success boolean or the Error message.
 */
- (void)deleteInBackgroundWithCompletion:(nullable void (^)(BOOL success, NSError * _Nullable error))completion;


/**
 *  Adds an user to the group.
 *
 *  @param user MASUser object
 *  @param completion Completion block with either the MASGroup object or the Error message
 */
- (void)addMember:(nonnull MASUser *)user completion:(nullable void (^)(MASGroup * _Nullable group, NSError * _Nullable error))completion;


/**
 * Removes an user from the group
 *
 * @param user MASUser object
 * @param completion Completion block with either the MASGroup object or the Error message
 */
- (void)removeMember:(nonnull MASUser *)user completion:(nullable void (^)(MASGroup * _Nullable group, NSError * _Nullable error))completion;



# pragma mark - Print Attributes

///--------------------------------------
/// @name Print Attributes
///--------------------------------------


/**
 *  List all attributes from the Object
 */
- (void)listAttributes;

@end
