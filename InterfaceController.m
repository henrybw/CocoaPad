/*
 ---------------------------------------------------------------------------
 CocoaPad -- InterfaceController.m
 By Henry Weiss
 ---------------------------------------------------------------------------
 This works with PreferenceController to create a Preferences feature.  This
 also makes the toolbar, and handles a lot of the format conversion routines.
 
 Major events:
 
 - 01/17/04: CocoaPad started
 - 04/01/04: Added the "secret about box"
 - 04/08/04: Removed all of the debugging stuff, and cleaned up the code
 - 04/26/04: Completed CocoaPad 1.0b1 beta Release 1
 - 05/21/04: Completed toolbar
 - 05/28/04: Moved toolbar to document window
 - 06/09/04: Added background color panel support
 - 06/18/04: Completed CocoaPad 1.0b2 beta Release 2
 - 11/10/04: Made Word format confirmation sheet.  Also made no sheet
             appear if converting from plain text.
 - 11/16/04: Made convert to plain text sheet only appear if formatting
             is present.
 - 01/31/05: Removed debugging stuff, cleaned up the code
 - 02/02/05: Fixed registering defaults issue where we registered two
             show ruler settings instead of a show toolbar setting.
 - 02/02/05: Finished CocoaPad 1.0 pre-release
 - 03/05/05: Re-engineered the Change Background Color methods
 - 03/30/05: Completed Automatic Backup
 - 05/16/05: Added “smart quotes”
 - 05/23/05: Added word count
 - 06/07/05: FINALLY COMPLETED COCOAPAD 1.0!!!
 - 10/14/07: Fixed a bug that prevented CocoaPad from opening Word documents
 - 10/14/07: Released CocoaPad v1.1, with 2 bug fixes!
 
 */

#import "InterfaceController.h"
#import "MyDocument.h"
#import "PreferenceController.h"
#import "LocalizedStrings.h"

/****************************/
/* Declare global variables */
/****************************/

/*
 * Global variables are declared here because
 * InterfaceController loads before any other
 * object loads (including MyDocument).
 */

// These are the keys used in the preference file

NSString *CP_ShowRuler = @"ShowRuler";
NSString *CP_SpellChecking = @"CheckSpellingWhileTyping";
NSString *CP_ShowToolbar = @"ShowToolbar";
NSString *CP_IgnoreFormatting = @"IgnoreFormatting";
NSString *CP_EnableSmartQuotes = @"EnableSmartQuotes";
NSString *CP_BackgroundColor = @"BackgroundColor";
NSString *CP_TextColor = @"TextColor";
NSString *CP_OpenNewDoc = @"OpenNewDoc";
NSString *CP_NewDocFormat = @"NewDocumentFormat";
NSString *CP_SaveBackup = @"SaveBackup";
NSString *CP_SaveBackupInterval = @"SaveBackupInterval";

// These are for the document toolbar

NSString *CP_ToolbarIdentifier = @"Toolbar";
NSString *CP_BoldToolbarItemIdentifier = @"BoldToolbarItemIdentifier";
NSString *CP_ItalicToolbarItemIdentifier = @"ItalicToolbarItemIdentifier";
NSString *CP_UnderlineToolbarItemIdentifier = @"UnderlineToolbarItemIdentifier";
NSString *CP_NewDocToolbarItemIdentifier = @"NewDocToolbarItemIdentifier";
NSString *CP_SaveToolbarItemIdentifier = @"SaveToolbarItemIdentifier";
NSString *CP_SaveAsToolbarItemIdentifier = @"SaveAsToolbarItemIdentifier";
NSString *CP_OpenToolbarItemIdentifier = @"OpenToolbarItemIdentifier";
NSString *CP_PrefsToolbarItemIdentifier = @"PrefsToolbarItemIdentifier";
NSString *CP_FindToolbarItemIdentifier = @"FindToolbarItemIdentifier";
NSString *CP_FindNextToolbarItemIdentifier = @"FindNextToolbarItemIdentifier";
NSString *CP_BackgroundColorToolbarItemIdentifier = @"BackgroundColorToolbarItemIdentifier";
NSString *CP_BiggerToolbarItemIdentifier = @"BiggerToolbarItemIdentifier";
NSString *CP_SmallerToolbarItemIdentifier = @"SmallerToolbarItemIdentifier";
NSString *CP_UppercaseToolbarItemIdentifier = @"UppercaseToolbarItemIdentifier";
NSString *CP_LowercaseToolbarItemIdentifier = @"LowercaseToolbarItemIdentifier";
NSString *CP_CapitalizeToolbarItemIdentifier = @"CapitalizeToolbarItemIdentifier";
NSString *CP_ConvertToCPDToolbarItemIdentifier = @"ConvertToCPDToolbarItemIdentifier";
NSString *CP_ConvertToRTFToolbarItemIdentifier = @"ConvertToRTFToolbarItemIdentifier";
NSString *CP_ConvertToRTFDToolbarItemIdentifier = @"ConvertToRTFDToolbarItemIdentifier";
NSString *CP_ConvertToTXTToolbarItemIdentifier = @"ConvertToTXTToolbarItemIdentifier";
NSString *CP_ConvertToDocToolbarItemIdentifier = @"ConvertToDocToolbarItemIdentifier";

// Document formats defined in Info.plist

NSString *CP_CPDocument = @"CPDocument";
NSString *CP_RTFDocument = @"RTFDocument";
NSString *CP_RTFDDocument = @"RTFDDocument";
NSString *CP_TextDocument = @"Plain Text Document";
NSString *CP_WordDocument = @"Microsoft Word Document";

// Document formats used in the preference file

NSString *CP_DefaultFormat = @"CPD";
NSString *CP_CPDFormat = @"CPD";
NSString *CP_RTFFormat = @"RTF";
NSString *CP_RTFDFormat = @"RTFD";
NSString *CP_WordFormat = @"Word";
NSString *CP_TextFormat = @"Text";

// Default fonts

NSString *CP_RTFFont = @"Helvetica";
NSString *CP_TextFont = @"Monaco";


@implementation InterfaceController

/***** Register the preferences *****/

+ (void)initialize
{
    // Create a new dictionary to hold the preferences
    NSMutableDictionary *defaultValues = [NSMutableDictionary dictionary];
    
    // Store the color objects as NSData
    NSData *colorAsData = [NSArchiver archivedDataWithRootObject:[NSColor whiteColor]];
    NSData *textColorAsData = [NSArchiver archivedDataWithRootObject:[NSColor blackColor]];
    
    // Put defaults into the dictionary
    
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:CP_ShowRuler];
    [defaultValues setObject:[NSNumber numberWithBool:NO] forKey:CP_SpellChecking];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:CP_ShowToolbar];
    [defaultValues setObject:[NSNumber numberWithBool:NO] forKey:CP_IgnoreFormatting];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:CP_EnableSmartQuotes];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:CP_OpenNewDoc];
    [defaultValues setObject:[NSNumber numberWithBool:YES] forKey:CP_SaveBackup];
    [defaultValues setObject:[NSNumber numberWithInt:5] forKey:CP_SaveBackupInterval];
    [defaultValues setObject:colorAsData forKey:CP_BackgroundColor];
    [defaultValues setObject:textColorAsData forKey:CP_TextColor];
    
    [NSFont setUserFont:nil];  // nil means use the system's default
    [NSFont setUserFixedPitchFont:nil];  // nil means use the system's default
    
    [defaultValues setObject:CP_DefaultFormat forKey:CP_NewDocFormat];
    
    // Register the dictionary of defaults
    [[NSUserDefaults standardUserDefaults] registerDefaults:defaultValues];
}

- (void)awakeFromNib
{
    BOOL backupsPurged = YES;
    NSString *type, *title, *file, *string;
    NSDirectoryEnumerator *backupFolder = [[NSFileManager defaultManager] enumeratorAtPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Resources/Backups"]];
    NSFileWrapper *fileWrapper;
    NSData *data;
    MyDocument *document = nil;
    
    // Check if there were any backups in the Backups folder
    // (which should have been purged when last quit)
    
    while (file = [backupFolder nextObject])
    {
        backupsPurged = NO;
        
        if ([[file pathExtension] isEqualToString:@"rtfd"])
        {
            [backupFolder skipDescendents];  // Don't enumerate this directory
            
            // Get the window title (minus our extension)
            title = [file substringWithRange:NSMakeRange(0, [file length] - 5)];
            
            // And the file type
            type = CP_RTFDDocument;
            [document setType:CP_RTFDDocument];
            
            // Create the document...
            
            fileWrapper = [[NSFileWrapper alloc] initWithPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"Contents/Resources/Backups/", file]]];
            
            document = [[NSDocumentController sharedDocumentController] openUntitledDocumentOfType:type display:YES];
            
            // ...set the file type...
            [document setFileType:type];
            
            // ...set the document title...
            [[document currentWindow] setTitle:title];
            
            // ...and set its contents
            [document setFileWrapper:fileWrapper];
            
            // Oh, and make it unsaved too.
            [document updateChangeCount:NSChangeDone];
            
            [fileWrapper release];
        }
        
        else if ([[file pathExtension] isEqualToString:@"cpd"] || [[file pathExtension] isEqualToString:@"rtf"] || [[file pathExtension] isEqualToString:@"doc"] || [[file pathExtension] isEqualToString:@"txt"])
        {            
            // Get the window title (minus our extension)
            title = [file substringWithRange:NSMakeRange(0, [file length] - 4)];
            
            // And the file type
            
            if ([[file pathExtension] isEqualToString:@"cpd"])
            {
                type = CP_CPDocument;
            }
            
            else if ([[file pathExtension] isEqualToString:@"rtf"])
            {
                type = CP_RTFDocument;
            }
            
            else if ([[file pathExtension] isEqualToString:@"doc"])
            {
                type = CP_WordDocument;
            }
            
            else
            {
                type = CP_TextDocument;
            }
            
            // Create the document...
            
            document = [[NSDocumentController sharedDocumentController] openUntitledDocumentOfType:type display:YES];
            
            // ...set the file type...
            [document setType:type];
            
            if (type != CP_TextDocument)
            {
                data = [NSData dataWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"Contents/Resources/Backups/%@", file]]];
                
                [document setFileContents:data];
            }
            
            else
            {
                string = [NSString stringWithContentsOfFile:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:[NSString stringWithFormat:@"Contents/Resources/Backups/%@", file]]];
                
                [document setString:string];
                [document loadDocument];
            }
            
            // ...set the document title...
            [[document currentWindow] setTitle:title];
            
            // Oh, and make it unsaved too.
            [document updateChangeCount:NSChangeDone];
            
            [document updateView];
        }
    }
    
    if (!backupsPurged)
    {
        NSRunAlertPanel(L_BACKUPS_RECOVERED_SHEET_TITLE, L_BACKUPS_RECOVERED_SHEET_DESCRIPTION, L_OK_BUTTON, nil, nil);
        
        [[document currentWindow] makeKeyWindow];  // Return focus to the last document to open
    }
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(createNewBackupTimer:) name:@"BackupIntervalDidChange" object:nil];
    
    [self createNewBackupTimer:nil];
}

- (void)createNewBackupTimer:(NSNotification *)notification
{
    if ([[NSUserDefaults standardUserDefaults] boolForKey:CP_SaveBackup])
    {
        // Get rid of our old timer (if we created one)
        
        if (backupTimer != nil)
        {
            [backupTimer invalidate];
        }
        
        backupTimer = [NSTimer scheduledTimerWithTimeInterval:(float)[[NSUserDefaults standardUserDefaults] integerForKey:CP_SaveBackupInterval] * 60 target:self selector:@selector(backupDocuments:) userInfo:nil repeats:YES];
        
        [backupTimer retain];
        
        [[NSFileManager defaultManager] createDirectoryAtPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Resources/Backups"] attributes:nil];
    }
}

- (void)backupDocuments:(NSTimer *)timer
{
    NSEnumerator *documentList = [[[NSDocumentController sharedDocumentController] documents] objectEnumerator];
    MyDocument *document;
    NSString *windowTitle, *backupPath = [[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Resources/Backups"];
    
    // First get rid of the old backups...
    
    if (![[NSFileManager defaultManager] removeFileAtPath:backupPath handler:nil])
    {
        NSLog(@"Something fishy happened when trying to purge the backup files...");
    }
    
    // ...and create a fresh new backup folder
    
    [[NSFileManager defaultManager] createDirectoryAtPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Resources/Backups"] attributes:nil];
    
    // Run through all the documents and back 'em up!
    
    while (document = [documentList nextObject])
    {
        windowTitle = [[document currentWindow] title];
        
        // Save the text view contents
        
        if ([document cpd])
        {
            [[document fileWrapperRepresentationOfType:CP_CPDocument] writeToFile:[backupPath stringByAppendingPathComponent:[windowTitle stringByAppendingPathExtension:@"cpd"]] atomically:YES updateFilenames:YES];
        }
        
        else if ([document rtf])
        {
            [[document fileWrapperRepresentationOfType:CP_RTFDocument] writeToFile:[backupPath stringByAppendingPathComponent:[windowTitle stringByAppendingPathExtension:@"rtf"]] atomically:YES updateFilenames:YES];
        }
        
        else if ([document rtfd])
        {
            [[document fileWrapperRepresentationOfType:CP_RTFDDocument] writeToFile:[backupPath stringByAppendingPathComponent:[windowTitle stringByAppendingPathExtension:@"rtfd"]] atomically:YES updateFilenames:YES];
        }
        
        else if ([document doc] && [document supportsWordFormat])
        {
            [[document fileWrapperRepresentationOfType:CP_WordDocument] writeToFile:[backupPath stringByAppendingPathComponent:[windowTitle stringByAppendingPathExtension:@"doc"]] atomically:YES updateFilenames:YES];
        }
        
        else if ([document plainText])
        {
            [[document fileWrapperRepresentationOfType:CP_TextDocument] writeToFile:[backupPath stringByAppendingPathComponent:[windowTitle stringByAppendingPathExtension:@"txt"]] atomically:YES updateFilenames:YES];
        }
    }
}

/***** Validate menu items when asked for *****/

- (BOOL)validateMenuItem:(NSMenuItem *)menuItem
{
    MyDocument *document = [[NSDocumentController sharedDocumentController] currentDocument];  // Get the current doc
    NSString *selectedText = [document selectedText];  // Now find the selected text
    
    flag = ([selectedText isEqualToString:L_STRING]);
    
    // We identify the menu item by action, so we don't
    // have to worry about name changing or localization
    
    if ([menuItem action] == @selector(showAboutPanel:))
    {
        if (flag)
        {
            [menuItem setTitle:L_ALT];
        }
        
        else
        {
            [menuItem setTitle:L_NAME];
        }
    }
    
    /*
     * These set the menu item on or off depending on what format we're in
     * (because we don't need to convert a CocoaPad document into
     * a CocoaPad document).
     */
    
    else if ([menuItem action] == @selector(makeCPD:))
    {
        return (![document cpd]);
    }
        
    else if ([menuItem action] == @selector(makeRichText:))
    {
        return (![document rtf]);
    }
    
    else if ([menuItem action] == @selector(makeRTFD:))
    {
        return (![document rtfd]);
    }
    
    else if ([menuItem action] == @selector(makeDocFormat:))
    {
        if ([document supportsWordFormat])
        {
            return (![document doc]);
        }
        
        else
        {
            return NO;
        }
    }
    
    else if ([menuItem action] == @selector(makePlainText:))
    {
        return (![document plainText]);
    }
    
    return YES;  // All other menu items should be enabled
}

/***** Should we open a new untitled document on startup? *****/

- (BOOL)applicationShouldOpenUntitledFile:(NSApplication *)sender
{
    // We will see if the prefs say we should open a new doc or not.
    // If not, then supress it by returning NO.
    
    return [[NSUserDefaults standardUserDefaults] boolForKey:CP_OpenNewDoc];
}

/***** Initialize the preference panel *****/

- (IBAction)showPreferencePanel:(id)sender
{
    // Check if we already created an instance of PreferenceController
    
    if (preferenceController == nil)
    {
        // We only want to do this once -- that's why we check if preferenceController is nil
        preferenceController = [[PreferenceController alloc] init];
    }
    
    // Now show the panel that's associated with the PreferenceController
    [preferenceController showWindow:self];
}

- (IBAction)showAboutPanel:(id)sender
{
    if (flag)
    {
        [window makeKeyAndOrderFront:sender];
    }
    
    else
    {
        [NSApp orderFrontStandardAboutPanel:sender];
    }
}

/***************************/
/* Utility trigger methods */
/***************************/

/*
 * These simply trigger the utility methods in MyDocument
 */

/***** Uppercase text *****/

- (IBAction)uppercase:(id)sender
{
    // Get MyDocument to uppercase the text
    [[[NSDocumentController sharedDocumentController] currentDocument] uppercase:nil];
}

/***** Lowercase text *****/

- (IBAction)lowercase:(id)sender
{
    // Get MyDocument to lowercase the text
    [[[NSDocumentController sharedDocumentController] currentDocument] lowercase:nil];
}

/***** Capitalize text *****/

- (IBAction)capitalize:(id)sender
{
    // Get MyDocument to capitalize the text
    [[[NSDocumentController sharedDocumentController] currentDocument] capitalize:nil];
}

/***** Change the background color *****/

- (IBAction)changeBackgroundColor:(id)sender
{
    // Get MyDocument to change the background color
    [[[NSDocumentController sharedDocumentController] currentDocument] changeBackgroundColor];
}

/***** Word count *****/

- (IBAction)wordCount:(id)sender
{
    MyDocument *document = [[NSDocumentController sharedDocumentController] currentDocument];
    NSTextStorage *textStorage = [[document textView] textStorage];
    
    // Only do a word count if there's a document open
    
    if (document != nil)
    {
        // Get the word count
        int words = [[textStorage words] count];
        int paragraphs = [[textStorage paragraphs] count];
        int chars = [[textStorage characters] count];
        
        NSBeginInformationalAlertSheet(L_WORD_COUNT_TITLE, L_OK_BUTTON, nil, nil, [document currentWindow], self, nil, nil, nil, [NSString stringWithFormat:L_WORD_COUNT_TEXT, chars, words, paragraphs], nil);
    }
}

//
// Format conversion methods
//

/***** Convert to CPD format *****/

- (IBAction)makeCPD:(id)sender
{
    // Set the format to CPD
    [[[NSDocumentController sharedDocumentController] currentDocument] convertToCPD];
}

/***** Convert to RTF format *****/

- (IBAction)makeRichText:(id)sender
{
    MyDocument *document = [[NSDocumentController sharedDocumentController] currentDocument];
    SEL selector = @selector(convertRTFSheetDidEnd:returnCode:contextInfo:);  // The "sheetDidEnd" method
    
    /*
     * RTF and Word are basically the same, so don't show a sheet
     * if we're converting from one of those formats.  Also, don't
     * show a sheet when converting from plain text.
     */
    
    if (![document doc] && ![document plainText] && [[[document textView] textStorage] containsAttachments])
    {
        NSBeginAlertSheet(L_CONVERT_RTF_SHEET_TITLE, L_OK_BUTTON, L_CANCEL_BUTTON, nil, [[[NSDocumentController sharedDocumentController] currentDocument] currentWindow], self, nil, selector, nil, L_CONVERT_RTF_SHEET_DESCRIPTION, nil);
    }
    
    else
    {
        // Set the format to rich text, no questions asked.
        [[[NSDocumentController sharedDocumentController] currentDocument] convertToRTF];
    }
}

// Handle post-sheet displayed stuff

- (void)convertRTFSheetDidEnd:(NSWindow *)sheet returnCode:(int)result contextInfo:(void *)contextInfo
{
    if (result == NSAlertDefaultReturn)
    {
        // Set the format to rich text
        [[[NSDocumentController sharedDocumentController] currentDocument] convertToRTF];
    }
}

/***** Convert to RTFD format *****/

- (IBAction)makeRTFD:(id)sender
{
    // Set the format to RTFD, no questions asked.
    [[[NSDocumentController sharedDocumentController] currentDocument] convertToRTFD];
}

/***** Convert to Word format *****/

- (IBAction)makeDocFormat:(id)sender
{
    MyDocument *document = [[NSDocumentController sharedDocumentController] currentDocument];
    SEL selector = @selector(convertWordSheetDidEnd:returnCode:contextInfo:);  // The "sheetDidEnd" method
    
    /*
     * RTF and Word are basically the same, so don't show a sheet
     * if we're converting from one of those formats.  Also, don't
     * show a sheet when converting from plain text.
     */
    
    if (![document doc] && ![document plainText] && [[[document textView] textStorage] containsAttachments])
    {
        NSBeginAlertSheet(L_CONVERT_WORD_SHEET_TITLE, L_OK_BUTTON, L_CANCEL_BUTTON, nil, [[[NSDocumentController sharedDocumentController] currentDocument] currentWindow], self, nil, selector, nil, L_CONVERT_WORD_SHEET_DESCRIPTION, nil);
    }
    
    else
    {
        // Set the format to Word, no questions asked.
        [[[NSDocumentController sharedDocumentController] currentDocument] convertToDocFormat];
    }
}

// Handle post-sheet displayed stuff

- (void)convertWordSheetDidEnd:(NSWindow *)sheet returnCode:(int)result contextInfo:(void *)contextInfo
{
    if (result == NSAlertDefaultReturn)
    {
        // Set the format to Word
        [[[NSDocumentController sharedDocumentController] currentDocument] convertToDocFormat];
    }
}

/***** Convert to Plain Text *****/

- (IBAction)makePlainText:(id)sender
{
    MyDocument *document = [[NSDocumentController sharedDocumentController] currentDocument];
    SEL selector = @selector(convertTXTSheetDidEnd:returnCode:contextInfo:);  // The "sheetDidEnd" method
    
    // Run a warning sheet if the document contains any formatting,
    // which will get nuked when converting to plain text.
    
    if ([document containsFormatting])
    {
        NSBeginAlertSheet(L_CONVERT_TXT_SHEET_TITLE, L_OK_BUTTON, L_CANCEL_BUTTON, nil, [[[NSDocumentController sharedDocumentController] currentDocument] currentWindow], self, nil, selector, nil, L_CONVERT_TXT_SHEET_DESCRIPTION, nil);
    }
    
    else
    {
        // Set the format to plain text, no questions asked.
        [[[NSDocumentController sharedDocumentController] currentDocument] convertToTXT];
    }
}

// Handle post-sheet displayed stuff

- (void)convertTXTSheetDidEnd:(NSWindow *)sheet returnCode:(int)result contextInfo:(void *)contextInfo
{
    if (result == NSAlertDefaultReturn)
    {
        // Set the format to plain text
        [[[NSDocumentController sharedDocumentController] currentDocument] convertToTXT];
    }
}

// Delete the backup files when quitting

- (void)applicationWillTerminate:(NSNotification *)notification
{
    if (![[NSFileManager defaultManager] removeFileAtPath:[[[NSBundle mainBundle] bundlePath] stringByAppendingPathComponent:@"Contents/Resources/Backups"] handler:nil])
    {
        NSLog(@"Something fishy happened when trying to purge the backup data...");
    }
}

/***** Override the dealloc method so we can release our own objects *****/

// We're tidy programmers, so we have to clean up after ourselves when we're done

- (void)dealloc:(id)sender
{
    [preferenceController release];  // We must deallocate our instance of PreferenceController
    [super dealloc];  // ...we now return to the previously scheduled deallocation. 
}

@end