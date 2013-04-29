/*
 ---------------------------------------------------------------------------
 CocoaPad -- MyDocument.h
 By Henry Weiss
 ---------------------------------------------------------------------------
 This is the header file that initializes all the variables, functions, and
 stuff for the MyDocument class.  See "MyDocument.m" for info on the
 MyDocument class.
 
 */

#import <Cocoa/Cocoa.h>
#import "CPTextView.h"

/**********************************/
/* Instance variables and Methods */
/**********************************/

@interface MyDocument : NSDocument
{
    IBOutlet CPTextView *textView;  // The text view
    NSTextStorage *textStorage;  // The text storage
    NSData *fileContents;  // RTF/RTFD/Word data
    NSColor *documentTextColor;  // Used to prevent other color panels from changing the text color
    NSString *string;  // Text contents
    BOOL untitledDocument;  // Is the document untitled (for text files)?
    
    // The format flags
    
    BOOL plainText;
    BOOL cpd;
    BOOL rtf;
    BOOL rtfd;
    BOOL doc;
    BOOL converted;
    
    // Compatibility flags
    
    BOOL supportsFindPanel;
    BOOL supportsWordFormat;
}

/***** Accessor methods *****/

// The text view's string

- (void)setString:(NSString *)value;
- (NSString *)string;

// The format flags

- (BOOL)plainText;
- (BOOL)cpd;
- (BOOL)rtf;
- (BOOL)rtfd;
- (BOOL)doc;
- (void)setType:(NSString *)type;

- (BOOL)supportsWordFormat;

- (NSWindow *)currentWindow;
- (NSTextView *)textView;
- (NSString *)selectedText;
- (void)setFileWrapper:(NSFileWrapper *)fileWrapper;
- (void)setFileContents:(NSData *)data;

// The one read/write method that needs to be declared

- (void)loadDocument;

/***** Utility methods *****/

- (void)updateView;  // Update the interface when necessary
- (void)updateString;  // Update the plain text string when necessary

// Utilities

- (void)uppercase:(NSAttributedString *)attributedString;
- (void)lowercase:(NSAttributedString *)attributedString;
- (void)capitalize:(NSAttributedString *)attributedString;
- (void)changeBackgroundColor;

// Format conversion utilities

- (void)convertToCPD;
- (void)convertToRTF;
- (void)convertToRTFD;
- (void)convertToDocFormat;
- (void)convertToTXT;

- (BOOL)containsFormatting;  // See if the document is not plain text or no
- (NSDictionary *)defaultTextAttributes;  // Get the default text attributes
- (void)removeAttachments;  // This removes all attachments, graphics, etc.

@end