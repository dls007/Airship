/* Copyright 2017 Urban Airship and Contributors */

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

/**
 * Category extensions for URL encoding and decoding of strings.
 */
@interface NSString(UAURLEncoding)

/**
 * URL decodes the receiver.
 * @param encoding The desired NSStringEncoding for the result.
 * @return A URL decoded NSString, or `nil` if decoding failed.
 *
 * @deprecated Deprecated - to be removed in SDK version 9.0
 *
 */
- (nullable NSString *)urlDecodedStringWithEncoding:(NSStringEncoding)encoding DEPRECATED_MSG_ATTRIBUTE("Deprecated - to be removed in SDK version 9.0");

/**
 * URL encodes the receiver.
 * @param encoding The desired NSStringEncoding for the result.
 * @return A URL encoded NSString, or `nil` if encoding failed.
 *
 * @deprecated Deprecated - to be removed in SDK version 9.0
 */
- (nullable NSString *)urlEncodedStringWithEncoding:(NSStringEncoding)encoding DEPRECATED_MSG_ATTRIBUTE("Deprecated - to be removed in SDK version 9.0");


/**
 * URL decodes the receiver with the query allowed character set.
 *
 * @return A URL dencoded NSString, or `nil` if decoding failed.
 *
 */
- (nullable NSString *)urlDecodedQueryString;

/**
 * URL encodes the receiver with the query allowed character set.
 *
 * @return A URL encoded NSString, or `nil` if encoding failed.
 *
 */
- (nullable NSString *)urlEncodedQueryString;


@end

NS_ASSUME_NONNULL_END
