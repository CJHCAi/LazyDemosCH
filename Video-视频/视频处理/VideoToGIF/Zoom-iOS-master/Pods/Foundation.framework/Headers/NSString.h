/*	NSString.h
	Copyright (c) 1994-2014, Apple Inc. All rights reserved.
*/

typedef unsigned short unichar;

#import <limits.h>
#import <Foundation/NSObject.h>
#import <Foundation/NSRange.h>
#import <stdarg.h>

@class NSData, NSArray, NSDictionary, NSCharacterSet, NSURL, NSError, NSLocale;

FOUNDATION_EXPORT NSString * const NSParseErrorException; // raised by -propertyList

#define NSMaximumStringLength	(INT_MAX-1)

/* These options apply to the various search/find and comparison methods (except where noted).
*/
typedef NS_OPTIONS(NSUInteger, NSStringCompareOptions) {
    NSCaseInsensitiveSearch = 1,
    NSLiteralSearch = 2,		/* Exact character-by-character equivalence */
    NSBackwardsSearch = 4,		/* Search from end of source string */
    NSAnchoredSearch = 8,		/* Search is limited to start (or end, if NSBackwardsSearch) of source string */
    NSNumericSearch = 64,		/* Added in 10.2; Numbers within strings are compared using numeric value, that is, Foo2.txt < Foo7.txt < Foo25.txt; only applies to compare methods, not find */
    NSDiacriticInsensitiveSearch NS_ENUM_AVAILABLE(10_5, 2_0) = 128, /* If specified, ignores diacritics (o-umlaut == o) */
    NSWidthInsensitiveSearch NS_ENUM_AVAILABLE(10_5, 2_0) = 256, /* If specified, ignores width differences ('a' == UFF41) */
    NSForcedOrderingSearch NS_ENUM_AVAILABLE(10_5, 2_0) = 512, /* If specified, comparisons are forced to return either NSOrderedAscending or NSOrderedDescending if the strings are equivalent but not strictly equal, for stability when sorting (e.g. "aaa" > "AAA" with NSCaseInsensitiveSearch specified) */
    NSRegularExpressionSearch NS_ENUM_AVAILABLE(10_7, 3_2) = 1024    /* Applies to rangeOfString:..., stringByReplacingOccurrencesOfString:..., and replaceOccurrencesOfString:... methods only; the search string is treated as an ICU-compatible regular expression; if set, no other options can apply except NSCaseInsensitiveSearch and NSAnchoredSearch */
};

/* Note that in addition to the values explicitly listed below, NSStringEncoding supports encodings provided by CFString.
See CFStringEncodingExt.h for a list of these encodings.
See CFString.h for functions which convert between NSStringEncoding and CFStringEncoding.
*/
enum {
    NSASCIIStringEncoding = 1,		/* 0..127 only */
    NSNEXTSTEPStringEncoding = 2,
    NSJapaneseEUCStringEncoding = 3,
    NSUTF8StringEncoding = 4,
    NSISOLatin1StringEncoding = 5,
    NSSymbolStringEncoding = 6,
    NSNonLossyASCIIStringEncoding = 7,
    NSShiftJISStringEncoding = 8,          /* kCFStringEncodingDOSJapanese */
    NSISOLatin2StringEncoding = 9,
    NSUnicodeStringEncoding = 10,
    NSWindowsCP1251StringEncoding = 11,    /* Cyrillic; same as AdobeStandardCyrillic */
    NSWindowsCP1252StringEncoding = 12,    /* WinLatin1 */
    NSWindowsCP1253StringEncoding = 13,    /* Greek */
    NSWindowsCP1254StringEncoding = 14,    /* Turkish */
    NSWindowsCP1250StringEncoding = 15,    /* WinLatin2 */
    NSISO2022JPStringEncoding = 21,        /* ISO 2022 Japanese encoding for e-mail */
    NSMacOSRomanStringEncoding = 30,

    NSUTF16StringEncoding = NSUnicodeStringEncoding,      /* An alias for NSUnicodeStringEncoding */

    NSUTF16BigEndianStringEncoding = 0x90000100,          /* NSUTF16StringEncoding encoding with explicit endianness specified */
    NSUTF16LittleEndianStringEncoding = 0x94000100,       /* NSUTF16StringEncoding encoding with explicit endianness specified */

    NSUTF32StringEncoding = 0x8c000100,                   
    NSUTF32BigEndianStringEncoding = 0x98000100,          /* NSUTF32StringEncoding encoding with explicit endianness specified */
    NSUTF32LittleEndianStringEncoding = 0x9c000100        /* NSUTF32StringEncoding encoding with explicit endianness specified */
};
typedef NSUInteger NSStringEncoding;

typedef NS_OPTIONS(NSUInteger, NSStringEncodingConversionOptions) {
    NSStringEncodingConversionAllowLossy = 1,
    NSStringEncodingConversionExternalRepresentation = 2
};

FOUNDATION_EXPORT NSString * const NSCharacterConversionException;


@interface NSString : NSObject <NSCopying, NSMutableCopying, NSSecureCoding>

/* NSString primitive (funnel) methods. A minimal subclass of NSString just needs to implement these, although we also recommend getCharacters:range:. See below for the other methods.
*/
@property (readonly) NSUInteger length;
- (unichar)characterAtIndex:(NSUInteger)index;
- (instancetype)init NS_DESIGNATED_INITIALIZER;
- (instancetype)initWithCoder:(NSCoder *)aDecoder NS_DESIGNATED_INITIALIZER;

@end

@interface NSString (NSStringExtensionMethods)

- (void)getCharacters:(unichar *)buffer range:(NSRange)aRange;

- (NSString *)substringFromIndex:(NSUInteger)from;
- (NSString *)substringToIndex:(NSUInteger)to;
- (NSString *)substringWithRange:(NSRange)range;    // Hint: Use with rangeOfComposedCharacterSequencesForRange: to avoid breaking up composed characters

/* In the compare: methods, the range argument specifies the subrange, rather than the whole, of the receiver to use in the comparison. The range is not applied to the search string.  For example, [@"AB" compare:@"ABC" options:0 range:NSMakeRange(0,1)] compares "A" to "ABC", not "A" to "A", and will return NSOrderedAscending.
*/
- (NSComparisonResult)compare:(NSString *)string;
- (NSComparisonResult)compare:(NSString *)string options:(NSStringCompareOptions)mask;
- (NSComparisonResult)compare:(NSString *)string options:(NSStringCompareOptions)mask range:(NSRange)compareRange;
- (NSComparisonResult)compare:(NSString *)string options:(NSStringCompareOptions)mask range:(NSRange)compareRange locale:(id)locale; // locale arg used to be a dictionary pre-Leopard. We now accept NSLocale. Assumes the current locale if non-nil and non-NSLocale. nil continues to mean canonical compare, which doesn't depend on user's locale choice.
- (NSComparisonResult)caseInsensitiveCompare:(NSString *)string;
- (NSComparisonResult)localizedCompare:(NSString *)string;
- (NSComparisonResult)localizedCaseInsensitiveCompare:(NSString *)string;

/* localizedStandardCompare:, added in 10.6, should be used whenever file names or other strings are presented in lists and tables where Finder-like sorting is appropriate.  The exact behavior of this method may be tweaked in future releases, and will be different under different localizations, so clients should not depend on the exact sorting order of the strings.
*/
- (NSComparisonResult)localizedStandardCompare:(NSString *)string NS_AVAILABLE(10_6, 4_0);

- (BOOL)isEqualToString:(NSString *)aString;

- (BOOL)hasPrefix:(NSString *)aString;
- (BOOL)hasSuffix:(NSString *)aString;

/* containsString: returns YES if the target string is contained within the receiver. Same as calling rangeOfString:options: with no options, thus doing a case-sensitive, non-literal search. localizedCaseInsensitiveContainsString: is the case-insensitive variant. Note that it takes the current locale into effect as well.  Locale-independent case-insensitive operation, and other needs can be achieved by calling rangeOfString:options:range:locale: directly.
 */
- (BOOL)containsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0);
- (BOOL)localizedCaseInsensitiveContainsString:(NSString *)aString NS_AVAILABLE(10_10, 8_0);


/* These methods return length==0 if the target string is not found. So, to check for containment: ([str rangeOfString:@"target"].length > 0).  Note that the length of the range returned by these methods might be different than the length of the target string, due composed characters and such.
*/
- (NSRange)rangeOfString:(NSString *)aString;
- (NSRange)rangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask;
- (NSRange)rangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange;
- (NSRange)rangeOfString:(NSString *)aString options:(NSStringCompareOptions)mask range:(NSRange)searchRange locale:(NSLocale *)locale NS_AVAILABLE(10_5, 2_0);

/* These return the range of the first character from the set in the string, not the range of a sequence of characters. 
*/
- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet;
- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask;
- (NSRange)rangeOfCharacterFromSet:(NSCharacterSet *)aSet options:(NSStringCompareOptions)mask range:(NSRange)searchRange;

- (NSRange)rangeOfComposedCharacterSequenceAtIndex:(NSUInteger)index;
- (NSRange)rangeOfComposedCharacterSequencesForRange:(NSRange)range NS_AVAILABLE(10_5, 2_0);

- (NSString *)stringByAppendingString:(NSString *)aString;
- (NSString *)stringByAppendingFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

/* The following convenience methods all skip initial space characters (whitespaceSet) and ignore trailing characters. NSScanner can be used for more "exact" parsing of numbers.
*/
@property (readonly) double doubleValue;
@property (readonly) float floatValue;
@property (readonly) int intValue;
@property (readonly) NSInteger integerValue NS_AVAILABLE(10_5, 2_0);
@property (readonly) long long longLongValue NS_AVAILABLE(10_5, 2_0);
@property (readonly) BOOL boolValue NS_AVAILABLE(10_5, 2_0);  // Skips initial space characters (whitespaceSet), or optional -/+ sign followed by zeroes. Returns YES on encountering one of "Y", "y", "T", "t", or a digit 1-9. It ignores any trailing characters.

- (NSArray *)componentsSeparatedByString:(NSString *)separator;
- (NSArray *)componentsSeparatedByCharactersInSet:(NSCharacterSet *)separator NS_AVAILABLE(10_5, 2_0);

- (NSString *)commonPrefixWithString:(NSString *)aString options:(NSStringCompareOptions)mask;

/* The following three case methods perform the canonical (non-localized) mappings. They are suitable for programming operations that require stable results not depending on the user's locale preference.  For localized case mapping for strings presented to users, use their corresponding methods with locale argument below.
 */
@property (readonly, copy) NSString *uppercaseString;
@property (readonly, copy) NSString *lowercaseString;
@property (readonly, copy) NSString *capitalizedString;

/* The following methods perform localized case mappings based on the locale specified. Passing nil indicates the canonical mapping.  For the user preference locale setting, specify +[NSLocale currentLocale].
 */
- (NSString *)uppercaseStringWithLocale:(NSLocale *)locale NS_AVAILABLE(10_8, 6_0);
- (NSString *)lowercaseStringWithLocale:(NSLocale *)locale NS_AVAILABLE(10_8, 6_0);
- (NSString *)capitalizedStringWithLocale:(NSLocale *)locale NS_AVAILABLE(10_8, 6_0);

- (NSString *)stringByTrimmingCharactersInSet:(NSCharacterSet *)set;
- (NSString *)stringByPaddingToLength:(NSUInteger)newLength withString:(NSString *)padString startingAtIndex:(NSUInteger)padIndex;

- (void)getLineStart:(NSUInteger *)startPtr end:(NSUInteger *)lineEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range;
- (NSRange)lineRangeForRange:(NSRange)range;

- (void)getParagraphStart:(NSUInteger *)startPtr end:(NSUInteger *)parEndPtr contentsEnd:(NSUInteger *)contentsEndPtr forRange:(NSRange)range;
- (NSRange)paragraphRangeForRange:(NSRange)range;

typedef NS_OPTIONS(NSUInteger, NSStringEnumerationOptions) {
    // Pass in one of the "By" options:
    NSStringEnumerationByLines = 0,                       // Equivalent to lineRangeForRange:
    NSStringEnumerationByParagraphs = 1,                  // Equivalent to paragraphRangeForRange:
    NSStringEnumerationByComposedCharacterSequences = 2,  // Equivalent to rangeOfComposedCharacterSequencesForRange:
    NSStringEnumerationByWords = 3,
    NSStringEnumerationBySentences = 4,
    // ...and combine any of the desired additional options:
    NSStringEnumerationReverse = 1UL << 8,
    NSStringEnumerationSubstringNotRequired = 1UL << 9,
    NSStringEnumerationLocalized = 1UL << 10              // User's default locale
};

/* In the enumerate methods, the blocks will be invoked inside an autorelease pool, so any values assigned inside the block should be retained.
*/
- (void)enumerateSubstringsInRange:(NSRange)range options:(NSStringEnumerationOptions)opts usingBlock:(void (^)(NSString *substring, NSRange substringRange, NSRange enclosingRange, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);
- (void)enumerateLinesUsingBlock:(void (^)(NSString *line, BOOL *stop))block NS_AVAILABLE(10_6, 4_0);

@property (readonly, copy) NSString *description;

@property (readonly) NSUInteger hash;

/*** Encoding methods ***/

@property (readonly) NSStringEncoding fastestEncoding;    	// Result in O(1) time; a rough estimate
@property (readonly) NSStringEncoding smallestEncoding;   	// Result in O(n) time; the encoding in which the string is most compact

- (NSData *)dataUsingEncoding:(NSStringEncoding)encoding allowLossyConversion:(BOOL)lossy;   // External representation
- (NSData *)dataUsingEncoding:(NSStringEncoding)encoding;                                    // External representation

- (BOOL)canBeConvertedToEncoding:(NSStringEncoding)encoding;

/* Methods to convert NSString to a NULL-terminated cString using the specified encoding. Note, these are the "new" cString methods, and are not deprecated like the older cString methods which do not take encoding arguments.
*/
- (__strong const char *)cStringUsingEncoding:(NSStringEncoding)encoding NS_RETURNS_INNER_POINTER;	// "Autoreleased"; NULL return if encoding conversion not possible; for performance reasons, lifetime of this should not be considered longer than the lifetime of the receiving string (if the receiver string is freed, this might go invalid then, before the end of the autorelease scope)
- (BOOL)getCString:(char *)buffer maxLength:(NSUInteger)maxBufferCount encoding:(NSStringEncoding)encoding;	// NO return if conversion not possible due to encoding errors or too small of a buffer. The buffer should include room for maxBufferCount bytes; this number should accomodate the expected size of the return value plus the NULL termination character, which this method adds. (So note that the maxLength passed to this method is one more than the one you would have passed to the deprecated getCString:maxLength:.)

/* Use this to convert string section at a time into a fixed-size buffer, without any allocations.  Does not NULL-terminate. 
    buffer is the buffer to write to; if NULL, this method can be used to computed size of needed buffer.
    maxBufferCount is the length of the buffer in bytes. It's a good idea to make sure this is at least enough to hold one character's worth of conversion. 
    usedBufferCount is the length of the buffer used up by the current conversion. Can be NULL.
    encoding is the encoding to convert to.
    options specifies the options to apply.
    range is the range to convert.
    leftOver is the remaining range. Can be NULL.
    YES return indicates some characters were converted. Conversion might usually stop when the buffer fills, 
      but it might also stop when the conversion isn't possible due to the chosen encoding. 
*/
- (BOOL)getBytes:(void *)buffer maxLength:(NSUInteger)maxBufferCount usedLength:(NSUInteger *)usedBufferCount encoding:(NSStringEncoding)encoding options:(NSStringEncodingConversionOptions)options range:(NSRange)range remainingRange:(NSRangePointer)leftover;

/* These return the maximum and exact number of bytes needed to store the receiver in the specified encoding in non-external representation. The first one is O(1), while the second one is O(n). These do not include space for a terminating null.
*/
- (NSUInteger)maximumLengthOfBytesUsingEncoding:(NSStringEncoding)enc;	// Result in O(1) time; the estimate may be way over what's needed. Returns 0 on error (overflow)
- (NSUInteger)lengthOfBytesUsingEncoding:(NSStringEncoding)enc;		// Result in O(n) time; the result is exact. Returns 0 on error (cannot convert to specified encoding, or overflow)

@property (readonly, copy) NSString *decomposedStringWithCanonicalMapping;
@property (readonly, copy) NSString *precomposedStringWithCanonicalMapping;
@property (readonly, copy) NSString *decomposedStringWithCompatibilityMapping;
@property (readonly, copy) NSString *precomposedStringWithCompatibilityMapping;

/* Returns a string with the character folding options applied. theOptions is a mask of compare flags with *InsensitiveSearch suffix.
*/
- (NSString *)stringByFoldingWithOptions:(NSStringCompareOptions)options locale:(NSLocale *)locale NS_AVAILABLE(10_5, 2_0);

/* Replace all occurrences of the target string in the specified range with replacement. Specified compare options are used for matching target. If NSRegularExpressionSearch is specified, the replacement is treated as a template, as in the corresponding NSRegularExpression methods, and no other options can apply except NSCaseInsensitiveSearch and NSAnchoredSearch.
*/
- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange NS_AVAILABLE(10_5, 2_0);

/* Replace all occurrences of the target string with replacement. Invokes the above method with 0 options and range of the whole string.
*/
- (NSString *)stringByReplacingOccurrencesOfString:(NSString *)target withString:(NSString *)replacement NS_AVAILABLE(10_5, 2_0);

/* Replace characters in range with the specified string, returning new string.
*/
- (NSString *)stringByReplacingCharactersInRange:(NSRange)range withString:(NSString *)replacement NS_AVAILABLE(10_5, 2_0);

@property (readonly) __strong const char *UTF8String NS_RETURNS_INNER_POINTER;	// Convenience to return null-terminated UTF8 representation

/* User-dependent encoding who value is derived from user's default language and potentially other factors. The use of this encoding might sometimes be needed when interpreting user documents with unknown encodings, in the absence of other hints.  This encoding should be used rarely, if at all. Note that some potential values here might result in unexpected encoding conversions of even fairly straightforward NSString content --- for instance, punctuation characters with a bidirectional encoding.
*/
+ (NSStringEncoding)defaultCStringEncoding;	// Should be rarely used

+ (const NSStringEncoding *)availableStringEncodings;
+ (NSString *)localizedNameOfStringEncoding:(NSStringEncoding)encoding;

/*** Creation methods ***/

/* In general creation methods in NSString do not apply to subclassers, as subclassers are assumed to provide their own init methods which create the string in the way the subclass wishes.  Designated initializers of NSString are thus init and initWithCoder:.
*/
- (instancetype)initWithCharactersNoCopy:(unichar *)characters length:(NSUInteger)length freeWhenDone:(BOOL)freeBuffer;	/* "NoCopy" is a hint */
- (instancetype)initWithCharacters:(const unichar *)characters length:(NSUInteger)length;
- (instancetype)initWithUTF8String:(const char *)nullTerminatedCString;
- (instancetype)initWithString:(NSString *)aString;
- (instancetype)initWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (instancetype)initWithFormat:(NSString *)format arguments:(va_list)argList NS_FORMAT_FUNCTION(1,0);
- (instancetype)initWithFormat:(NSString *)format locale:(id)locale, ... NS_FORMAT_FUNCTION(1,3);
- (instancetype)initWithFormat:(NSString *)format locale:(id)locale arguments:(va_list)argList NS_FORMAT_FUNCTION(1,0);
- (instancetype)initWithData:(NSData *)data encoding:(NSStringEncoding)encoding;
- (instancetype)initWithBytes:(const void *)bytes length:(NSUInteger)len encoding:(NSStringEncoding)encoding;
- (instancetype)initWithBytesNoCopy:(void *)bytes length:(NSUInteger)len encoding:(NSStringEncoding)encoding freeWhenDone:(BOOL)freeBuffer;	/* "NoCopy" is a hint */

+ (instancetype)string;
+ (instancetype)stringWithString:(NSString *)string;
+ (instancetype)stringWithCharacters:(const unichar *)characters length:(NSUInteger)length;
+ (instancetype)stringWithUTF8String:(const char *)nullTerminatedCString;
+ (instancetype)stringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
+ (instancetype)localizedStringWithFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);

- (instancetype)initWithCString:(const char *)nullTerminatedCString encoding:(NSStringEncoding)encoding;
+ (instancetype)stringWithCString:(const char *)cString encoding:(NSStringEncoding)enc;

/* These use the specified encoding.  If nil is returned, the optional error return indicates problem that was encountered (for instance, file system or encoding errors).
*/
- (instancetype)initWithContentsOfURL:(NSURL *)url encoding:(NSStringEncoding)enc error:(NSError **)error;
- (instancetype)initWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error;
+ (instancetype)stringWithContentsOfURL:(NSURL *)url encoding:(NSStringEncoding)enc error:(NSError **)error;
+ (instancetype)stringWithContentsOfFile:(NSString *)path encoding:(NSStringEncoding)enc error:(NSError **)error;

/* These try to determine the encoding, and return the encoding which was used.  Note that these methods might get "smarter" in subsequent releases of the system, and use additional techniques for recognizing encodings. If nil is returned, the optional error return indicates problem that was encountered (for instance, file system or encoding errors).
*/
- (instancetype)initWithContentsOfURL:(NSURL *)url usedEncoding:(NSStringEncoding *)enc error:(NSError **)error;
- (instancetype)initWithContentsOfFile:(NSString *)path usedEncoding:(NSStringEncoding *)enc error:(NSError **)error;
+ (instancetype)stringWithContentsOfURL:(NSURL *)url usedEncoding:(NSStringEncoding *)enc error:(NSError **)error;
+ (instancetype)stringWithContentsOfFile:(NSString *)path usedEncoding:(NSStringEncoding *)enc error:(NSError **)error;

/* Write to specified url or path using the specified encoding.  The optional error return is to indicate file system or encoding errors.
*/
- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError **)error;
- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile encoding:(NSStringEncoding)enc error:(NSError **)error;

@end


@interface NSMutableString : NSString

/* NSMutableString primitive (funnel) method. See below for the other mutation methods.
*/
- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)aString;

@end

@interface NSMutableString (NSMutableStringExtensionMethods)

- (void)insertString:(NSString *)aString atIndex:(NSUInteger)loc;
- (void)deleteCharactersInRange:(NSRange)range;
- (void)appendString:(NSString *)aString;
- (void)appendFormat:(NSString *)format, ... NS_FORMAT_FUNCTION(1,2);
- (void)setString:(NSString *)aString;

/* In addition to these two, NSMutableString responds properly to all NSString creation methods.
*/
- (NSMutableString *)initWithCapacity:(NSUInteger)capacity;
+ (NSMutableString *)stringWithCapacity:(NSUInteger)capacity;

/* This method replaces all occurrences of the target string with the replacement string, in the specified range of the receiver string, and returns the number of replacements. NSBackwardsSearch means the search is done from the end of the range (the results could be different); NSAnchoredSearch means only anchored (but potentially multiple) instances will be replaced. NSLiteralSearch and NSCaseInsensitiveSearch also apply. NSNumericSearch is ignored. Use NSMakeRange(0, [receiver length]) to process whole string. If NSRegularExpressionSearch is specified, the replacement is treated as a template, as in the corresponding NSRegularExpression methods, and no other options can apply except NSCaseInsensitiveSearch and NSAnchoredSearch.
*/
- (NSUInteger)replaceOccurrencesOfString:(NSString *)target withString:(NSString *)replacement options:(NSStringCompareOptions)options range:(NSRange)searchRange;

@end

@interface NSString (NSStringEncodingDetection)

/*
 This API is used to detect the string encoding of a given raw data. It can also do lossy string conversion. It converts the data to a string in the detected string encoding. The data object contains the raw bytes, and the option dictionary contains the hints and parameters for the analysis. The opts dictionary can be nil. If the string parameter is not NULL, the string created by the detected string encoding is returned. The lossy substitution string is emitted in the output string for characters that could not be converted when lossy conversion is enabled. The usedLossyConversion indicates if there is any lossy conversion in the resulted string. If no encoding can be detected, 0 is returned.
 
 The possible items for the dictionary are:
 1) an array of suggested string encodings (without specifying the 3rd option in this list, all string encodings are considered but the ones in the array will have a higher preference; moreover, the order of the encodings in the array is important: the first encoding has a higher preference than the second one in the array)
 2) an array of string encodings not to use (the string encodings in this list will not be considered at all)
 3) a boolean option indicating whether only the suggested string encodings are considered
 4) a boolean option indicating whether lossy is allowed
 5) an option that gives a specific string to substitude for mystery bytes
 6) the current user's language
 7) a boolean option indicating whether the data is generated by Windows
 
 If the values in the dictionary have wrong types (for example, the value of NSStringEncodingDetectionSuggestedEncodingsKey is not an array), an exception is thrown.
 If the values in the dictionary are unknown (for example, the value in the array of suggested string encodings is not a valid encoding), the values will be ignored.
 */
+ (NSStringEncoding)stringEncodingForData:(NSData *)data
                          encodingOptions:(NSDictionary *)opts
                          convertedString:(NSString **)string
                      usedLossyConversion:(BOOL *)usedLossyConversion NS_AVAILABLE(10_10, 8_0);

@end

/*
 The following keys may be used in the option dictionary.
 */
// NSArray of NSNumbers which contain NSStringEncoding values; if this key is not present in the dictionary, all encodings are weighted the same
FOUNDATION_EXPORT NSString * const NSStringEncodingDetectionSuggestedEncodingsKey NS_AVAILABLE(10_10, 8_0);

// NSArray of NSNumbers which contain NSStringEncoding values; if this key is not present in the dictionary, all encodings are considered
FOUNDATION_EXPORT NSString * const NSStringEncodingDetectionDisallowedEncodingsKey NS_AVAILABLE(10_10, 8_0);

// NSNumber boolean value; if this key is not present in the dictionary, the default value is NO
FOUNDATION_EXPORT NSString * const NSStringEncodingDetectionUseOnlySuggestedEncodingsKey NS_AVAILABLE(10_10, 8_0);

// NSNumber boolean value; if this key is not present in the dictionary, the default value is YES
FOUNDATION_EXPORT NSString * const NSStringEncodingDetectionAllowLossyKey NS_AVAILABLE(10_10, 8_0);

// NSNumber boolean value; if this key is not present in the dictionary, the default value is NO
FOUNDATION_EXPORT NSString * const NSStringEncodingDetectionFromWindowsKey NS_AVAILABLE(10_10, 8_0);

// NSString value; if this key is not present in the dictionary, the default value is U+FFFD
FOUNDATION_EXPORT NSString * const NSStringEncodingDetectionLossySubstitutionKey NS_AVAILABLE(10_10, 8_0);

// NSString value; ISO language code; if this key is not present in the dictionary, no such information is considered
FOUNDATION_EXPORT NSString * const NSStringEncodingDetectionLikelyLanguageKey NS_AVAILABLE(10_10, 8_0);

@interface NSString (NSExtendedStringPropertyListParsing)

/* These methods are no longer recommended since they do not work with property lists and strings files in binary plist format. Please use the APIs in NSPropertyList.h instead.
*/
- (id)propertyList;
- (NSDictionary *)propertyListFromStringsFileFormat;

@end



@interface NSString (NSStringDeprecated)

/* The following methods are deprecated and will be removed from this header file in the near future. These methods use [NSString defaultCStringEncoding] as the encoding to convert to, which means the results depend on the user's language and potentially other settings. This might be appropriate in some cases, but often these methods are misused, resulting in issues when running in languages other then English. UTF8String in general is a much better choice when converting arbitrary NSStrings into 8-bit representations. Additional potential replacement methods are being introduced in NSString as appropriate.
*/
- (const char *)cString NS_RETURNS_INNER_POINTER NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
- (const char *)lossyCString NS_RETURNS_INNER_POINTER NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
- (NSUInteger)cStringLength NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
- (void)getCString:(char *)bytes NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
- (void)getCString:(char *)bytes maxLength:(NSUInteger)maxLength NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);	
- (void)getCString:(char *)bytes maxLength:(NSUInteger)maxLength range:(NSRange)aRange remainingRange:(NSRangePointer)leftoverRange NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

- (BOOL)writeToFile:(NSString *)path atomically:(BOOL)useAuxiliaryFile NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
- (BOOL)writeToURL:(NSURL *)url atomically:(BOOL)atomically NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

- (id)initWithContentsOfFile:(NSString *)path NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
- (id)initWithContentsOfURL:(NSURL *)url NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
+ (id)stringWithContentsOfFile:(NSString *)path NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
+ (id)stringWithContentsOfURL:(NSURL *)url NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

- (id)initWithCStringNoCopy:(char *)bytes length:(NSUInteger)length freeWhenDone:(BOOL)freeBuffer NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
- (id)initWithCString:(const char *)bytes length:(NSUInteger)length NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
- (id)initWithCString:(const char *)bytes NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);	
+ (id)stringWithCString:(const char *)bytes length:(NSUInteger)length NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);
+ (id)stringWithCString:(const char *)bytes NS_DEPRECATED(10_0, 10_4, 2_0, 2_0);

/* This method is unsafe because it could potentially cause buffer overruns. You should use -getCharacters:range: instead.
*/
- (void)getCharacters:(unichar *)buffer;

@end

enum {
    NSProprietaryStringEncoding = 65536    /* Installation-specific encoding */
};

/* The rest of this file is bookkeeping stuff that has to be here. Don't use this stuff, don't refer to it.
*/
#if !defined(_OBJC_UNICHAR_H_)
#define _OBJC_UNICHAR_H_
#endif
#define NS_UNICHAR_IS_EIGHT_BIT 0

@interface NSSimpleCString : NSString {
@package
    char *bytes;
    int numBytes;
#if __LP64__
    int _unused;
#endif
}
@end

@interface NSConstantString : NSSimpleCString
@end

#if __LP64__
#else
extern void *_NSConstantStringClassReference;
#endif



