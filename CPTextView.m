/*
 ---------------------------------------------------------------------------
 CocoaPad -- CPTextView.m
 By Henry Weiss
 ---------------------------------------------------------------------------
 Handles Òsmart quotes.Ó
 
 Major events:
 
 - 06/07/05: FINALLY COMPLETED COCOAPAD 1.0!!!
 - 10/14/07: Released CocoaPad v1.1, with 2 bug fixes!
 
 */

#import "CPTextView.h"
#import "InterfaceController.h"
#import "LocalizedStrings.h"


@implementation CPTextView

/***** Intercept strait quotes and replace with smart quotes *****/

- (void)keyDown:(NSEvent *)event
{
    NSString *input = [event characters];
    
    [super keyDown:event];  // Don't want to eat the key events
    
    // If smart quotes is enabled...
    
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CP_EnableSmartQuotes])
    {
        if ([input isEqualToString:@"\""])
        {
            int previousCharLocation = [self selectedRange].location - 1;
            
            // Insert a "Ò" -- we're at the beginning of the document
            
            if (previousCharLocation <= 0)
            {            
                [self replaceCharactersInRange:NSMakeRange(0, 1) withString:L_OPENING_QUOTE];
            }
            
            else
            {
                NSString *previousChar = [[self string] substringWithRange:NSMakeRange(previousCharLocation - 1, 1)];
                
                // If the previous character is a space, tab, return, or opening parentheses, insert a "Ò"
                
                if ([previousChar isEqualToString:@" "] || [previousChar isEqualToString:@"\t"] || [previousChar isEqualToString:@"\n"] || [previousChar isEqualToString:@"("])
                {
                    [self replaceCharactersInRange:NSMakeRange(previousCharLocation, 1) withString:L_OPENING_QUOTE];
                }
                
                // Otherwise, insert a "Ó"
                
                else
                {
                    [self replaceCharactersInRange:NSMakeRange(previousCharLocation, 1) withString:L_CLOSING_QUOTE];
                }
            }
        }
        
        if ([input isEqualToString:@"'"])
        {
            int previousCharLocation = [self selectedRange].location - 1;
            
            // Insert a "Ô" -- we're at the beginning of the document
            
            if (previousCharLocation <= 0)
            {            
                [self replaceCharactersInRange:NSMakeRange(0, 1) withString:L_OPENING_SINGLE_QUOTE];
            }
            
            else
            {
                NSString *previousChar = [[self string] substringWithRange:NSMakeRange(previousCharLocation - 1, 1)];
                
                // If the previous character is a space, tab, return, or opening parentheses, insert a "Ô"
                
                if ([previousChar isEqualToString:@" "] || [previousChar isEqualToString:@"\t"] || [previousChar isEqualToString:@"\n"] || [previousChar isEqualToString:@"("])
                {
                    [self replaceCharactersInRange:NSMakeRange(previousCharLocation, 1) withString:L_OPENING_SINGLE_QUOTE];
                }
                
                // Otherwise, insert a "Õ"
                
                else
                {
                    [self replaceCharactersInRange:NSMakeRange(previousCharLocation, 1) withString:L_CLOSING_SINGLE_QUOTE];
                }
            }
        }
    }
}

@end