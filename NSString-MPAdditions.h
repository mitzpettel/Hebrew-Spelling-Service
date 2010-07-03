/*
 *  NSString-MPAdditions.h
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

#import <Foundation/Foundation.h>


@interface NSString (NSStringMPAdditions)

- (NSString *)stringByReplacing:(NSString *)searchString with:(NSString *)replacement;
- (NSString *)stringByReplacing:(NSString *)searchString with:(NSString *)replacement options:(unsigned)mask;
+ (NSString *)stringWithCString:(const char *)bytes encoding:(NSStringEncoding)encoding;
- (const char *)cStringWithEncoding:(NSStringEncoding)encoding;
- (NSComparisonResult)displayNameCompare:(NSString *)string;

@end
