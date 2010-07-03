/*
 *  NSString-MPAdditions.m
 *  Icy Juice
 *
 *  Created by Mitz Pettel on Fri Mar 15 2002.
 *  Copyright (c) 2001 Mitz Pettel <source@mitzpettel.com>. All rights reserved.
 *
 * This program is free software; you can redistribute it and/or modify
 * it under the terms of the GNU General Public License as published by
 * the Free Software Foundation; either version 2 of the License, or (at
 * your option) any later version.
 *
 * This program is distributed in the hope that it will be useful, but
 * WITHOUT ANY WARRANTY; without even the implied warranty of
 * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
 * General Public License for more details.
 *
 * You should have received a copy of the GNU General Public License
 * along with this program; if not, write to the Free Software
 * Foundation, Inc., 675 Mass Ave, Cambridge, MA 02139, USA.
 *
 */

#import "NSString-MPAdditions.h"


@implementation NSString (NSStringMPAdditions)

- (NSString *)stringByReplacing:(NSString *)searchString with:(NSString *)replacement
{
    return [self stringByReplacing:searchString with:replacement options:0];
}

- (NSString *)stringByReplacing:(NSString *)searchString with:(NSString *)replacement options:(unsigned)mask
{
    NSMutableString *result = [self mutableCopy];
    NSRange searchRange = NSMakeRange(0, [self length]);
    NSRange matchRange;
    
    while (searchRange.length)
    {
        matchRange = [result rangeOfString:searchString options:mask range:searchRange];
        if (matchRange.location==NSNotFound)
            return result;
        [result replaceCharactersInRange:matchRange withString:replacement];
        searchRange.location += [replacement length];
        searchRange.length = [result length]-searchRange.location;
    }
    return result;
}

+ (NSString *)stringWithCString:(const char *)bytes encoding:(NSStringEncoding)encoding
{
    if (bytes==nil)
        return nil;
    return [(NSString *)CFStringCreateWithCString(nil, bytes, encoding) autorelease];
}

- (const char *)cStringWithEncoding:(NSStringEncoding)encoding
{
    CFIndex length;
    char *messageCString;
    NSMutableData *data;
    char *bytes;
    // get the required length
    CFStringGetBytes((CFStringRef)self, CFRangeMake(0, [self length]), encoding, '?', NO, nil, 0, &length);
    // allocate a buffer large enough
    data = [NSMutableData dataWithLength:length+1];
    bytes = [data mutableBytes];
    messageCString = malloc(length+1);
    // do the actual conversion
    CFStringGetBytes((CFStringRef)self, CFRangeMake(0, [self length]), encoding, '?', NO, bytes, length, &length);
    bytes[length] = 0;
    return bytes;
}

- (NSComparisonResult)displayNameCompare:(NSString *)string
{
    NSFileManager *manager = [NSFileManager defaultManager];
    return [[manager displayNameAtPath:self] caseInsensitiveCompare:[manager displayNameAtPath:string]];
}

@end
