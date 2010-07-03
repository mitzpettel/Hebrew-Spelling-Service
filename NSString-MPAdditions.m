/*
 *  NSString-MPAdditions.m
 *  Icy Juice
 *
 *  Created by Mitz Pettel on Fri Mar 15 2002.
 *  Copyright (c) 2001-2003 Mitz Pettel <source@mitzpettel.com>. All rights reserved.
 *
 *  Modifications suggested by Nir Soffer
 *  	(see <456BF303-0BAF-11D8-851B-000502B6C537@freeshell.org>)
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

+ (NSString *)stringWithCString:(const char *)bytes CFStringEncoding:(CFStringEncoding)encoding
{
    if (bytes==nil)
        return nil;
    return [(NSString *)CFStringCreateWithCString(kCFAllocatorDefault, bytes, encoding) autorelease];
}

- (const char *)cStringWithEncoding:(NSStringEncoding)encoding
{
    CFIndex length;
    NSMutableData *data;
    char *bytes;
    // get the required length
    CFStringGetBytes((CFStringRef)self, CFRangeMake(0, [self length]), encoding, '?', NO, nil, 0, &length);
    // allocate a buffer large enough
    data = [NSMutableData dataWithLength:length+1];
    bytes = [data mutableBytes];
    // do the actual conversion
    CFStringGetBytes((CFStringRef)self, CFRangeMake(0, [self length]), encoding, '?', NO, (UInt8 *)bytes, length, &length);
    bytes[length] = 0;
    return bytes;
}

- (NSString *)stringByReplacingStraightQuotesWithGershayim
{
    static NSCharacterSet *straightQuotes = nil;
    if (!straightQuotes)
        straightQuotes = [[NSCharacterSet characterSetWithCharactersInString:@"\"'"] retain];

    if (![self rangeOfCharacterFromSet:straightQuotes].length)
        return self;

    NSString *result = [self stringByReplacingOccurrencesOfString:@"'" withString:@"׳"];
    return [result stringByReplacingOccurrencesOfString:@"\"" withString:@"״"];
}

@end
