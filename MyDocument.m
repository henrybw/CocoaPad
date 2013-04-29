/*
 ---------------------------------------------------------------------------
 CocoaPad -- MyDocument.m
 By Henry Weiss
 ---------------------------------------------------------------------------
 MyDocument handles the stuff dealing with the document.  With over 2,000
 lines, this has the most code in the project.
 
 The file is broken up into 4 parts: Initialization Methods, Accessor Methods,
 Toolbar Methods, and Document Methods.
 
 The Initialization Methods override two initialization methods (init and
 windowControllerDidLoadNib) to add initialization code.  init contains
 initialization for the format flags, and windowControllerDidLoadNib
 contains initialization code for documents.
 
 Accessor Methods contains methods for the document string, and the format
 flags: string/setString, plainText, cpd, rtf, rtfd, and doc.  string is the
 variable that contains the text.  plainText, cpd, rtf, rtfd, and doc are all
 accessor methods so that Interface Controller can know which conversion menu
 items should be validated.
 
 Toolbar methods contain the essential code that gives each document's toolbar
 functionality.
 
 Document Methods contain the bulk of the code, and deals with saving, opening,
 printing, text, updating, and deallocating.
 
 Major events:
 
 - 01/17/04: CocoaPad started
 - 03/10/04: Added notification handling
 - 03/16/04: Added plain text ability and tuned up notification handling
 - 03/22/04: CPD format now encodes images into its own documents
 - 03/23/04: Added ability to set default text color
 - 03/26/04: Enabled printing
 - 03/26/04: Added speech features
 - 03/31/04: Added choice of new document format
 - 04/02/04: Added conversion utilities
 - 04/09/04: Added ability to strip graphics and attachments
 - 04/09/04: Removed all of the debugging stuff, and cleaned up the code
 - 04/09/04: Converting format now changes format selected in "File Format:"
             pop-up menu
 - 04/16/04: Finished "utility features"
 - 04/22/04: Fixed "txt" bug; removed "File Format:" pop-up menu in Save dialog
 - 04/26/04: Fixed uppercase/lowercase/capitalize bug that stripped formatting
 - 04/26/04: Completed CocoaPad 1.0b1 beta Release 1
 - 05/17/04: Fixed document-gets-centered-in-page-when-printed bug
 - 05/17/04: Added ability to undo a utility (except format conversion)
 - 05/21/04: Completed toolbar
 - 05/28/04: Added tab stops for the full page
 - 05/28/04: Moved toolbar from floating window to document window
 - 06/01/04: Added ability to open and save RTFD documents
 - 06/18/04: Made the window title temporarily say "Loading..."  It usually
             just says "Window".
 - 06/18/04: Completed CocoaPad 1.0b2 beta Release 2
 - 09/10/04: Fixed text view bug where pressing Tab or Return immediately would
             make the cursor disappear, then the tabs wouldn't work, etc.
 - 09/10/04: CocoaPad can now only run on Mac OS X 10.2 and higher
 - 11/01/04: Added the Find toolbar item
 - 11/10/04: Optimized code by removing unnecessary checks for document types
             with NS___TextDocumentType constants.  Info.plist takes care of
             all of this, so we only need to check *once*.
 - 11/10/04: Added Word support
 - 11/11/04: Fixed bug where document would "revert" when format was switched
 - 11/12/04: Added checks to see if Panther-only functions exist
 - 11/16/04: Removed irritating notification code, made an Apply To All button.
 - 11/16/04: Made convert to plain text sheet only appear if formatting
             is present.
 - 11/19/04: Made our [textView textStorage] an instance variable.
 - 11/19/04: Fixed the ruler bug when converting to Word format.
 - 12/08/04: Cursor now appears at the beginning of an opened document.
 - 12/08/04: Fixed the bug where the the cursor moves to the end of the document
             after a format conversion.
 - 12/08/04: Completely remodeled the updateView: method and changed the
             windowControllerDidLoadNib: method a lot as well.  Moved the
             document loading code from updateView: to windowControllerDidLoad-
             Nib:.
 - 12/08/04: Tuned up the check for formatting.
 - 12/08/04: CocoaPad now can display the text inside any document.
 - 12/26/04: Fixed an issue where attempting to build on Jaguar would fail.
 - 01/27/05: Polished off the tab stops.
 - 01/31/05: Fixed a bug where the Convert to Plain Text? dialog would appear if
             you typed at least one character, yet didn't apply any formatting
             to it.
 - 01/31/05: That last bug was caused because we didn't set the non-plain text
             color in defaultTextAttributes, but we realized that we also forgot
             to set the non-plain text color for a document (embarrassing), so
             we fixed that.
 - 01/31/05: Removed debugging stuff, cleaned up the code
 - 02/02/05: Added open plain text document code if ignore formatting is off,
             which for some strange reason we forgot to add before...
 - 02/02/05: Finished CocoaPad 1.0 pre-release
 - 03/05/05: Added Paste With Current Style to the Edit menu.
 - 03/05/05: Added more toolbar items
 - 03/05/05: Re-engineered the Change Background Color methods
 - 03/05/05: Fixed a small bug which reset the text color when converting to
             a different format.
 - 03/07/05: Fixed a small window-closing bug.
 - 03/30/05: Added Automatic Backup support.
 - 05/16/05: Added “smart quotes”
 - 05/23/05: Added word count
 - 06/07/05: FINALLY COMPLETED COCOAPAD 1.0!!!
 - 10/14/07: Fixed a bug that prevented CocoaPad from opening Word documents
 - 10/14/07: Fixed the bug that makes the cursor reverts to the place where
             you last typed after saving.
 - 10/14/07: Released CocoaPad v1.1, with 2 bug fixes!
 
 Working on:
 
 - Making the Bold, Italic, and Underline toolbar items indicate when they've
   been pressed or not, like some other good word processors.
 - Wrap to Page.
 
 */

#import "MyDocument.h"
#import "InterfaceController.h"
#import "LocalizedStrings.h"

// For AppKit's extension to NSAttributedString
#import <AppKit/NSAttributedString.h>


@implementation MyDocument

/**************************/
/* Initialization methods */
/**************************/

/***** Register MyDocument an observer *****/

- (id)init
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
    
    if (self = [super init])
    {
        // Set the format flags
        
        if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_CPDFormat])
        {
            plainText = NO;
            cpd = YES;
            rtf = NO;
            rtfd = NO;
            doc = NO;
        }
        
        else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_RTFFormat])
        {
            plainText = NO;
            cpd = NO;
            rtf = YES;
            rtfd = NO;
            doc = NO;
        }
        
        else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_RTFDFormat])
        {
            plainText = NO;
            cpd = NO;
            rtf = NO;
            rtfd = YES;
            doc = NO;
        }
        
        else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_TextFormat])
        {
            plainText = YES;
            cpd = NO;
            rtf = NO;
            rtfd = NO;
            doc = NO;
        }
        
        else if ([[prefs stringForKey:CP_NewDocFormat] isEqualToString:CP_WordFormat])
        {
            plainText = NO;
            cpd = NO;
            rtf = NO;
            rtfd = NO;
            doc = YES;
        }
        
        converted = NO;
    }
    
    return self;
}

/***** Initialize using objects we couldn't access in init *****/

- (void)awakeFromNib
{
    [textView setDelegate:self];
    [[textView layoutManager] setDelegate:self];
    [[textView window] setTitle:L_LOADING_WINDOW_TITLE];  // Make the title bar temporarily say "Loading..."
    textStorage = [textView textStorage];  // Initialize the text storage
    
    // Initialize the compatibility flags
    
    supportsFindPanel = [textView respondsToSelector:@selector(performFindPanelAction:)];
    supportsWordFormat = [textStorage respondsToSelector:@selector(docFormatFromRange:documentAttributes:)];
    
    /*
     * This is defined in case someone tries to build CocoaPad on
     * Jaguar.  Apple added all built-in Find panel functions
     * in Panther, and trying to build in Jaguar using this
     * constant will yield an error.
     */
    
    #ifndef NSFindPanelActionShowFindPanel
        #define NSFindPanelActionShowFindPanel 1
        #define NSFindPanelActionNext 2
    #endif
}

/***** Override the windowControllerDidLoadNib method so we can add document initialization code *****/

/*
 * Initializing the toolbar, plus executing all the code in here, makes loading
 * the document extremely slow compared to other word processors/text editors.
 */

- (void)windowControllerDidLoadNib:(NSWindowController *)aController
{
    NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];  // Load the preferences
    NSColor *textColor = [NSUnarchiver unarchiveObjectWithData:[prefs objectForKey:CP_TextColor]];
    NSColor *backgroundColor = [NSUnarchiver unarchiveObjectWithData:[prefs objectForKey:CP_BackgroundColor]];
    NSToolbar *toolbar = [[[NSToolbar alloc] initWithIdentifier:CP_ToolbarIdentifier] autorelease];  // Create a new toolbar
    NSArray *tabStops;  // Tab stops will be assigned after document is loaded
    BOOL showRuler = [prefs boolForKey:CP_ShowRuler];  // Get the ruler settings
    BOOL spellChecking = [prefs boolForKey:CP_SpellChecking];  // Get the spell checking settings
    
    [super windowControllerDidLoadNib:aController];  // We just want to add to the method, not redefine it
    
    // Use the find panel if we're on Mac OS X 10.3 Panther
    
    if (supportsFindPanel)
    {
        [textView setUsesFindPanel:YES];
    }
    
    // Configure the toolbar properties
    
    [toolbar setAllowsUserCustomization:YES];  // They can customize the toolbar
    [toolbar setAutosavesConfiguration:YES];  // Save the configuration they made
    [toolbar setDisplayMode:NSToolbarDisplayModeIconAndLabel];  // We want the icon AND label text
    
    // Attach the toolbar to the toolbar window
    
    [toolbar setDelegate:self];  // Assign us as the toolbar delegate
    [[textView window] setToolbar:toolbar];  // Attach the toolbar to the toolbar window
    
    // Don't show the toolbar if the preferences say no
    
    [[[textView window] toolbar] setVisible:[prefs boolForKey:CP_ShowToolbar]];
    
    // Set various settings
    
    [textView setContinuousSpellCheckingEnabled:spellChecking];  // Toggle continuous spell checking
    [textView setBackgroundColor:backgroundColor];  // Set the background color
    
    //
    // Format specific initialization
    //
    
    if (plainText)
    {
        [self setFileType:CP_TextDocument];  // Set the file type
        [textView setFont:[NSFont userFixedPitchFontOfSize:0.0]];  // Our mono font
        [textView setUsesRuler:NO];  // No ruler with plain text
        [textView setImportsGraphics:NO];    // Plain text doesn't have images!
        [textView setTextColor:textColor];  // Set the text color to the default color
        [textView setRichText:NO];  // No graphics or anything
    }
    
    else
    {
        // First set Rich Text-only properties
        
        [textView setImportsGraphics:(cpd || rtfd)];  // CPD and RTFD formats import graphics
        [textView setUsesRuler:YES];  // We do use the ruler
        [textView setRulerVisible:showRuler];  // Toggle the ruler
        [textView setRichText:YES];  // Make the view know this is rich text
        [textView setTextColor:textColor];  // Set the text color
        
        // For new untitled docs only
        
        if ([self fileName] == nil && ![self isDocumentEdited])
        {
            [textView setFont:[NSFont userFontOfSize:0.0]];  // Set the default font
            [textView setTextColor:textColor];  // Set the default text color
        }
    }
    
    // Now load the document
    
    [self loadDocument];
    
    //
    // Replace Apple's default tab stops with our default tab stops
    //
    
    // We can assign the tabStops array because the tab stops have been assigned
    tabStops = [[[textView typingAttributes] objectForKey:NSParagraphStyleAttributeName] tabStops];
    
    // If the document is using Apple's default tab stops, we're gonna replace them with ours
    
    if ([tabStops isEqualToArray:[[NSParagraphStyle defaultParagraphStyle] tabStops]] || tabStops == nil)
    {
        [textView setTypingAttributes:[self defaultTextAttributes]];
    }
    
    [self updateView];  // And update the text view
}

/********************/
/* Accessor methods */
/********************/

/***** The document string *****/

- (NSString *)string
{
    return string;
}

- (void)setString:(NSString *)value
{
    // We'll use a retain then release
    
    [value retain];
    [string release];
    string = value;
}

/***** The document contents *****/

////////////////////////////////////////
// THIS IS FOR RTFD DOCUMENTS ONLY!!! //
////////////////////////////////////////

- (void)setFileWrapper:(NSFileWrapper *)wrapper
{
    // We'll use a retain then release
    
    // Get the data from the RTFD document
    NSAttributedString *tempString = [[[NSAttributedString alloc] initWithRTFDFileWrapper:wrapper documentAttributes:nil] retain];
        
    [fileContents release];
        
    // This is shorter version of "Retain, then Release"
    fileContents = [tempString RTFDFromRange:NSMakeRange(0, [tempString length]) documentAttributes:nil];
    
    [self loadDocument];
}

- (void)setFileContents:(NSData *)data
{
    [data retain];
    [fileContents release];
    
    fileContents = data;
    
    [self loadDocument];
}

/***** Format flags accessor methods *****/

/*
 * The format flags don't need to be set, but they
 * need to be accessed by InterfaceController
 */

- (BOOL)plainText
{
    return plainText;
}

- (BOOL)cpd
{
    return cpd;
}

- (BOOL)rtf
{
    return rtf;
}

- (BOOL)rtfd
{
    return rtfd;
}

- (BOOL)doc
{
    return doc;
}

- (void)setType:(NSString *)type
{
    if ([type isEqualToString:CP_CPDocument])
    {
        cpd = YES;
        rtf = NO;
        rtfd = NO;
        doc = NO;
        plainText = NO;
    }
    
    else if ([type isEqualToString:CP_RTFDocument])
    {
        cpd = NO;
        rtf = YES;
        rtfd = NO;
        doc = NO;
        plainText = NO;
    }
    
    else if ([type isEqualToString:CP_RTFDDocument])
    {
        cpd = NO;
        rtf = NO;
        rtfd = YES;
        doc = NO;
        plainText = NO;
    }
    
    else if ([type isEqualToString:CP_WordDocument])
    {
        cpd = NO;
        rtf = NO;
        rtfd = NO;
        doc = YES;
        plainText = NO;
    }
    
    else if ([type isEqualToString:CP_TextDocument])
    {
        cpd = NO;
        rtf = NO;
        rtfd = NO;
        doc = NO;
        plainText = YES;
    }
}

- (BOOL)supportsWordFormat
{
    return supportsWordFormat;
}

/***** Return the selected text *****/

/*
 * This isn't officially an accessor
 * method, but it sure acts like one.
 */

- (NSString *)selectedText
{
    NSRange selection = [textView selectedRange];
    NSString *document = [textView string];
    
    if ([[document substringWithRange:selection] isEqualToString:@""])
    {
        return nil;
    }
    
    else
    {
        return [document substringWithRange:selection];
    }
}

- (NSWindow *)currentWindow
{
    return [textView window];  // Return the current document's window
}

- (NSTextView *)textView
{
    return textView;  // Return the current text view
}

- (NSString *)windowNibName
{
    return @"MyDocument";  // The name of the nib file for the documents
}

/*******************/
/* Toolbar methods */
/*******************/

/***** Return an array of what items can be on the toolbar *****/

- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar *)toolbar
{
    NSMutableArray *array = [NSMutableArray arrayWithObjects:
        CP_NewDocToolbarItemIdentifier,
        CP_SaveToolbarItemIdentifier,
        CP_SaveAsToolbarItemIdentifier,
        CP_OpenToolbarItemIdentifier,
        CP_PrefsToolbarItemIdentifier,
        CP_BoldToolbarItemIdentifier,
        CP_ItalicToolbarItemIdentifier,
        CP_UnderlineToolbarItemIdentifier,
        NSToolbarShowFontsItemIdentifier,
        NSToolbarShowColorsItemIdentifier,
        CP_BackgroundColorToolbarItemIdentifier,
        CP_BiggerToolbarItemIdentifier,
        CP_SmallerToolbarItemIdentifier,
        CP_UppercaseToolbarItemIdentifier,
        CP_LowercaseToolbarItemIdentifier,
        CP_CapitalizeToolbarItemIdentifier,
        CP_ConvertToCPDToolbarItemIdentifier,
        CP_ConvertToRTFToolbarItemIdentifier,
        CP_ConvertToRTFDToolbarItemIdentifier,
        CP_ConvertToTXTToolbarItemIdentifier,
        CP_ConvertToDocToolbarItemIdentifier,
        NSToolbarPrintItemIdentifier,
        NSToolbarCustomizeToolbarItemIdentifier,
        NSToolbarSeparatorItemIdentifier,
        nil];
    
    // Add the find panel item ONLY if we're on Panther
    
    if (supportsFindPanel)
    {
        [array addObject:CP_FindToolbarItemIdentifier];
        [array addObject:CP_FindNextToolbarItemIdentifier];
    }
    
    return array;
}

/***** Return an array of what items are on the toolbar by default *****/

- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar *)toolbar
{
    return [NSArray arrayWithObjects:CP_NewDocToolbarItemIdentifier,
        CP_SaveToolbarItemIdentifier,
        CP_SaveAsToolbarItemIdentifier,
        CP_OpenToolbarItemIdentifier,
        CP_PrefsToolbarItemIdentifier,
        NSToolbarSeparatorItemIdentifier,
        CP_BoldToolbarItemIdentifier,
        CP_ItalicToolbarItemIdentifier,
        CP_UnderlineToolbarItemIdentifier,
        NSToolbarSeparatorItemIdentifier,
        NSToolbarShowFontsItemIdentifier,
        NSToolbarShowColorsItemIdentifier,
        NSToolbarSeparatorItemIdentifier,
        NSToolbarPrintItemIdentifier,
        nil];
}

/***** Configure our custom toolbar items *****/

- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar itemForItemIdentifier:(NSString *)itemIdentifier willBeInsertedIntoToolbar:(BOOL)flag
{
    /*
     * Create a toolbar item that corresponds to the identifier given.
     * We are autoreleasing because we will return the toolbar item,
     * but then we don't know what will happen to it.
     */
    
    NSToolbarItem *toolbarItem = [[[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier] autorelease];
    
    if ([itemIdentifier isEqualToString:CP_NewDocToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_NEW_DOC_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_NEW_DOC_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_NEW_DOC_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"new"]];
        [toolbarItem setAction:@selector(new)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_SaveToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_SAVE_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_SAVE_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_SAVE_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"save"]];
        [toolbarItem setAction:@selector(save)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_SaveAsToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_SAVE_AS_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_SAVE_AS_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_SAVE_AS_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"save"]];
        [toolbarItem setAction:@selector(saveAs)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_OpenToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_OPEN_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_OPEN_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_OPEN_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"open"]];
        [toolbarItem setAction:@selector(open)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_PrefsToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_PREFS_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_PREFS_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_PREFS_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"prefs"]];
        [toolbarItem setAction:@selector(showPreferencePanel:)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_BoldToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_BOLD_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_BOLD_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_BOLD_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"bold"]];
        [toolbarItem setAction:@selector(bold)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_ItalicToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_ITALIC_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_ITALIC_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_ITALIC_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"italic"]];
        [toolbarItem setAction:@selector(italic)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_UnderlineToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_UNDERLINE_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_UNDERLINE_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_UNDERLINE_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"underline"]];
        [toolbarItem setAction:@selector(underline)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_FindToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_FIND_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_FIND_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_FIND_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"find"]];
        [toolbarItem setAction:@selector(find)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_FindNextToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_FIND_NEXT_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_FIND_NEXT_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_FIND_NEXT_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"findnext"]];
        [toolbarItem setAction:@selector(findNext)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_BiggerToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_BIGGER_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_BIGGER_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_BIGGER_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"bigger"]];
        [toolbarItem setAction:@selector(bigger)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_SmallerToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_SMALLER_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_SMALLER_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_SMALLER_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"smaller"]];
        [toolbarItem setAction:@selector(smaller)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_UppercaseToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_UPPERCASE_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_UPPERCASE_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_UPPERCASE_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"uppercase"]];
        [toolbarItem setAction:@selector(uppercase:)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_LowercaseToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_LOWERCASE_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_LOWERCASE_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_LOWERCASE_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"lowercase"]];
        [toolbarItem setAction:@selector(lowercase:)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_CapitalizeToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_CAPITALIZE_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_CAPITALIZE_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_CAPITALIZE_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"capitalize"]];
        [toolbarItem setAction:@selector(capitalize:)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_ConvertToCPDToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_CONVERT_TO_CPD_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_CONVERT_TO_CPD_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_CONVERT_TO_CPD_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"convertcpd"]];
        [toolbarItem setAction:@selector(convertToCPD)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_ConvertToRTFToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_CONVERT_TO_RTF_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_CONVERT_TO_RTF_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_CONVERT_TO_RTF_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"convertrtf"]];
        [toolbarItem setAction:@selector(convertToRTF)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_ConvertToRTFDToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_CONVERT_TO_RTFD_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_CONVERT_TO_RTFD_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_CONVERT_TO_RTFD_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"convertrtf"]];
        [toolbarItem setAction:@selector(convertToRTFD)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_ConvertToTXTToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_CONVERT_TO_TXT_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_CONVERT_TO_TXT_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_CONVERT_TO_TXT_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"converttxt"]];
        [toolbarItem setAction:@selector(convertToPlainText)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_ConvertToDocToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_CONVERT_TO_DOC_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_CONVERT_TO_DOC_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_CONVERT_TO_DOC_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"convertdoc"]];
        [toolbarItem setAction:@selector(convertToDocFormat)];
    }
    
    else if ([itemIdentifier isEqualToString:CP_BackgroundColorToolbarItemIdentifier])
    {
        [toolbarItem setLabel:L_CHANGE_BG_COLOR_TOOLBAR_ITEM];
        [toolbarItem setPaletteLabel:L_CHANGE_BG_COLOR_TOOLBAR_ITEM];
        [toolbarItem setToolTip:L_CHANGE_BG_COLOR_HELP_TAG];
        [toolbarItem setImage:[NSImage imageNamed:@"bgcolor"]];
        [toolbarItem setAction:@selector(changeBackgroundColor)];
    }    
    
    return toolbarItem;
}

//
// Toolbar action methods
//

/***** New *****/

- (void)new
{
    // Get the document controller to create a new panel
    [[NSDocumentController sharedDocumentController] newDocument:nil];
}

/***** Save *****/

- (void)save
{
    // Get MyDocument to save the current document
    [self saveDocument:nil];
}

/***** Save *****/

- (void)saveAs
{
    // Get MyDocument to save the current document
    [self saveDocumentAs:nil];
}

/***** Open *****/

- (void)open
{
    // Get the document controller to display the open panel
    [[NSDocumentController sharedDocumentController] openDocument:nil];
}

/***** Bold *****/

- (void)bold
{
    NSFontManager *fontManager = [NSFontManager sharedFontManager];  // Get the font manager
    NSFont *currentFont = [fontManager convertFont:[fontManager selectedFont]];  // Get the current font
    
    // Make a "sender" so addFontTrait/removeFontTrait can tell what trait to add/remove
    
    NSMenuItem *boldMenuItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
    [boldMenuItem setTag:NSBoldFontMask];  // The font manager queries the tag to tell what trait to add/remove
    
    // This tests to see if the current font is bold or not
    
    if (![[fontManager convertFont:currentFont toHaveTrait:NSBoldFontMask] isEqual:currentFont])
    {
        [fontManager addFontTrait:boldMenuItem];  // Make the text bold
    }
    
    else
    {
        [fontManager removeFontTrait:boldMenuItem];  // Make the text NOT bold
    }
    
    [boldMenuItem release];
}

/***** Italic *****/

- (void)italic
{
    NSFontManager *fontManager = [NSFontManager sharedFontManager];  // Get the font manager
    NSFont *currentFont = [fontManager convertFont:[fontManager selectedFont]];  // Get the current font
    
    // Make a "sender" so addFontTrait/removeFontTrait can tell what trait to add/remove
    
    NSMenuItem *italicMenuItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
    [italicMenuItem setTag:NSItalicFontMask];  // The font manager queries the tag to tell what trait to add/remove
    
    // This tests to see if the current font is italic or not
    
    if (![[fontManager convertFont:currentFont toHaveTrait:NSItalicFontMask] isEqual:currentFont])
    {
        [fontManager addFontTrait:italicMenuItem];  // Make the text italic
    }
    
    else
    {
        [fontManager removeFontTrait:italicMenuItem];  // Make the text NOT italic
    }
    
    [italicMenuItem release];
}

/***** Underline *****/

- (void)underline
{
    [textView underline:nil];
}

/***** Find *****/

- (void)find
{
    // This code should ONLY run on Mac OS X 10.3 Panther
    
    if (supportsFindPanel)
    {
        // Make a "sender" so performFindPanel: can tell what action it must do
        
        NSMenuItem *findMenuItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
        [findMenuItem setTag:NSFindPanelActionShowFindPanel];  // The find panel queries the tag to tell what to do
        
        [textView performFindPanelAction:findMenuItem];
        
        [findMenuItem release];
    }
    
    else
    {
        // We can't run the find panel
        
        NSRunAlertPanel(L_FIND_FAILED_SHEET_TITLE, L_FIND_FAILED_SHEET_DESCRIPTION, L_OK_BUTTON, @"", nil);
        
        return;
    }
}

/***** Find Next *****/

- (void)findNext
{
    // This code should ONLY run on Mac OS X 10.3 Panther
    
    if (supportsFindPanel)
    {
        // Make a "sender" so performFindPanel: can tell what action it must do
        
        NSMenuItem *findMenuItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
        [findMenuItem setTag:NSFindPanelActionNext];  // The find panel queries the tag to tell what to do
        
        [textView performFindPanelAction:findMenuItem];
        
        [findMenuItem release];
    }
    
    else
    {
        // We can't run the find panel
        
        NSRunAlertPanel(L_FIND_FAILED_SHEET_TITLE, L_FIND_FAILED_SHEET_DESCRIPTION, L_OK_BUTTON, @"", nil);
        
        return;
    }
}

/***** Bigger *****/

- (void)bigger
{
    NSFontManager *fontManager = [NSFontManager sharedFontManager];  // Get the font manager
    
    // Make a "sender" so modifyFont can tell what trait to add/remove
    
    NSMenuItem *biggerMenuItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
    [biggerMenuItem setTag:NSSizeUpFontAction];  // The font manager queries the tag to tell what to do
    
    [fontManager modifyFont:biggerMenuItem];
}

/***** Smaller *****/

- (void)smaller
{
    NSFontManager *fontManager = [NSFontManager sharedFontManager];  // Get the font manager
    
    // Make a "sender" so modifyFont can tell what trait to add/remove
    
    NSMenuItem *smallerMenuItem = [[NSMenuItem alloc] initWithTitle:@"" action:nil keyEquivalent:@""];
    [smallerMenuItem setTag:NSSizeDownFontAction];  // The font manager queries the tag to tell what to do
    
    [fontManager modifyFont:smallerMenuItem];
}

/********************/
/* Document methods */
/********************/

//
// Document read/write methods
//

/***** Save as if the document was converted *****/

- (void)saveDocument:(id)sender
{
    NSString *fileExtension = [[self fileName] pathExtension];
    
    // We can only save Word files on Panther or later
    
    if (doc && !supportsWordFormat)
    {  
        NSRunAlertPanel(L_WORD_FAILED_SHEET_TITLE, L_WORD_FAILED_SHEET_DESCRIPTION, L_OK_BUTTON, @"", nil);
        
        return;
    }
    
    if (plainText && ([fileExtension isEqualToString:@"cpd"] || [fileExtension isEqualToString:@"rtf"] || [fileExtension isEqualToString:@"rtfd"] || [fileExtension isEqualToString:@"doc"]))
    {
        [self setFileName:[[[self fileName] stringByDeletingPathExtension] stringByAppendingPathExtension:@"txt"]];
    }
    
    // Save
    
    if (converted)
        [super saveDocumentAs:sender];
    
    else
        [super saveDocument:sender];
    
    // Return the plain text document to its original, untitled name (no extension)
    
    if (untitledDocument && plainText)
    {
        [self setFileName:nil];
        untitledDocument = NO;
    }
}

/***** Prepare the save panel *****/

- (BOOL)prepareSavePanel:(NSSavePanel *)savePanel
{
    if (plainText)
    {
        // Update the filename to include the .txt extension
        
        if ([self fileName] == nil)
        {
            [self setFileName:[[[textView window] title] stringByAppendingPathExtension:@"txt"]];
            untitledDocument = YES;  // We know this really has no filename
        }
        
        // We are SHOWING the .txt or whatever extension!
        
        [savePanel setExtensionHidden:NO];
    }
    
    else if (cpd)
    {
        [savePanel setRequiredFileType:@"cpd"];
    }
    
    else if (rtf)
    {
        [savePanel setRequiredFileType:@"rtf"];
    }
    
    else if (rtfd)
    {
        [savePanel setRequiredFileType:@"rtfd"];
    }
    
    else if (doc)
    {
        [savePanel setRequiredFileType:@"doc"];
    }
    
    return YES;
}

/***** Disable the file format popup menu *****/

- (BOOL)shouldRunSavePanelWithAccessoryView
{
    return NO;  // This fixes the "txt" bug, making you choose the file format from Format menu
}

/***** Return the data that will be saved *****/

- (NSFileWrapper *)fileWrapperRepresentationOfType:(NSString *)aType
{
    NSUndoManager *undoManager = [self undoManager];  // This will be explained later
    
    // Save a CocoaPad document
    
    if ([aType isEqualToString:CP_CPDocument])
    {
        [fileContents release];  // Get rid of the old fileContents
        fileContents = [[textStorage RTFDFromRange:NSMakeRange(0, [[textView string] length]) documentAttributes:nil] retain];  // Get the RTFD data
        
        // Update the format flags
        
        plainText = NO;
        cpd = YES;
        rtf = NO;
        rtfd = NO;
        doc = NO;
        
        converted = NO;
        
        // We have to bite the bullet and follow what TextEdit does here, since
        // the undo manager simply refuses to register any more actions after
        // saving otherwise...
        
        [undoManager removeAllActions];
        
        return [[[NSFileWrapper alloc] initRegularFileWithContents:fileContents] autorelease];
    }
    
    // Save a Rich Text Format document
    
    else if ([aType isEqualToString:CP_RTFDocument])
    {
        [self removeAttachments];  // Strip the document of all offending graphics and such
        
        [fileContents release];  // Get rid of the old fileContents
        fileContents = [[textStorage RTFFromRange:NSMakeRange(0, [[textView string] length]) documentAttributes:nil] retain];  // Get the RTF data
        
        // Update the format flags
        
        plainText = NO;
        cpd = NO;
        rtf = YES;
        rtfd = NO;
        doc = NO;
        
        converted = NO;
        
        // We have to bite the bullet and follow what TextEdit does here, since
        // the undo manager simply refuses to register any more actions after
        // saving otherwise...
        
        [undoManager removeAllActions];
        
        return [[[NSFileWrapper alloc] initRegularFileWithContents:fileContents] autorelease];
    }
    
    // Save an RTFD document
    
    else if ([aType isEqualToString:CP_RTFDDocument])
    {
        [fileContents release];  // Get rid of the old fileContents
        fileContents = [[textStorage RTFDFromRange:NSMakeRange(0, [[textView string] length]) documentAttributes:nil] retain];  // Get the RTFD data
        
        // Update the format flags
        
        plainText = NO;
        cpd = NO;
        rtf = NO;
        rtfd = YES;
        doc = NO;
        
        converted = NO;
        
        // We have to bite the bullet and follow what TextEdit does here, since
        // the undo manager simply refuses to register any more actions after
        // saving otherwise...
        
        [undoManager removeAllActions];
        
        return [textStorage RTFDFileWrapperFromRange:NSMakeRange(0, [[textView string] length]) documentAttributes:nil];
    }
    
    // Save a Word document
    
    else if ([aType isEqualToString:CP_WordDocument] && supportsWordFormat)
    {
        [self removeAttachments];  // Strip the document of all offending graphics and such
        
        [fileContents release];  // Get rid of the old fileContents
        fileContents = [[textStorage docFormatFromRange:NSMakeRange(0, [[textView string] length]) documentAttributes:nil] retain];  // Get the Word data
        
        // Update the format flags
        
        plainText = NO;
        cpd = NO;
        rtf = NO;
        rtfd = NO;
        doc = YES;
        
        converted = NO;
        
        // We have to bite the bullet and follow what TextEdit does here, since
        // the undo manager simply refuses to register any more actions after
        // saving otherwise...
        
        [undoManager removeAllActions];
        
        return [[[NSFileWrapper alloc] initRegularFileWithContents:fileContents] autorelease];
    }
       
    // Save a plain text document
    
    else if ([aType isEqualToString:CP_TextDocument])
    {
        // Update the format flags
        
        plainText = YES;
        cpd = NO;
        rtf = NO;
        rtfd = NO;
        doc = NO;
        
        converted = NO;
        
        // We have to bite the bullet and follow what TextEdit does here, since
        // the undo manager simply refuses to register any more actions after
        // saving otherwise...
        
        [undoManager removeAllActions];
        
        [self removeAttachments];  // Strip the document of all offending graphics and such
        [self updateView];  // Now update the text view
        
        // We use Unicode UTF-8
        return [[[NSFileWrapper alloc] initRegularFileWithContents:[string dataUsingEncoding:NSUTF8StringEncoding]] autorelease];
    }
    
    return nil;  // Otherwise, the document could not be saved
}

/***** Load the data from the file provided into a document *****/

/*
 * Instead of overriding loadFileWrapperRepresentation: or
 * loadDataRepresentation:, we override readFromFile: so we 
 * can load whatever text we can find, in the file, may it
 * be a text file, PHP file, JPEG file, Stuffed file, etc.
 */

- (BOOL)readFromFile:(NSString *)fileName ofType:(NSString *)docType
{
    if (![[NSUserDefaults standardUserDefaults] boolForKey:CP_IgnoreFormatting])
    {
        // Open a CocoaPad document
        
        if ([docType isEqualToString:CP_CPDocument])
        {
            // Read the data from the file
            NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
            
            fileContents = [data retain];  // This is shorter version of "Retain, then Release"
            [self setFileType:docType];  // Set the file type
            
            // Update the format flags
            
            plainText = NO;
            cpd = YES;
            rtf = NO;
            rtfd = NO;
            doc = NO;
            
            converted = NO;
            
            [data release];  // We're done with the file data
            
            return YES;
        }
        
        // Open an RTF document
        
        else if ([docType isEqualToString:CP_RTFDocument])
        {
            // Read the data from the file
            NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
            
            fileContents = [data retain];  // This is shorter version of "Retain, then Release"
            [self setFileType:docType];  // Set the file type
            
            // Update the format flags
            
            plainText = NO;
            cpd = NO;
            rtf = YES;
            rtfd = NO;
            doc = NO;
            
            converted = NO;
            
            [data release];  // We're done with the file data
            
            return YES;
        }
        
        // Open an RTFD document
        
        else if ([docType isEqualToString:CP_RTFDDocument])
        {
            // Read the data from the file (wrapper)
            NSFileWrapper *wrapper = [[NSFileWrapper alloc] initWithPath:fileName];
            
            // Get the data from the RTFD document
            NSAttributedString *tempString = [[NSAttributedString alloc] initWithRTFDFileWrapper:wrapper documentAttributes:nil];
            
            // This is shorter version of "Retain, then Release"
            fileContents = [[tempString RTFDFromRange:NSMakeRange(0, [tempString length]) documentAttributes:nil] retain];
            
            [self setFileType:docType];  // Set the file type
            
            // Update the format flags
            
            plainText = NO;
            cpd = NO;
            rtf = NO;
            rtfd = YES;
            doc = NO;
            
            converted = NO;
            
            [tempString release];  // We're done with the temporary string
            [wrapper release];  // We're done with our file wrapper
            
            return YES;
        }
        
        // Open a Word document
        
        else if ([docType isEqualToString:CP_WordDocument])
        {
            // We can't use supportsWordFormat because awakeFromNib hasn't been called yet
            
            NSAttributedString *attributedString = [[[NSAttributedString alloc] init] autorelease];
            
            if ([attributedString respondsToSelector:@selector(docFormatFromRange:documentAttributes:)])
            {
                // Read the data from the file
                NSData *data = [[NSData alloc] initWithContentsOfFile:fileName];
                
                fileContents = [data retain];  // This is shorter version of "Retain, then Release"
                [self setFileType:docType];  // Set the file type
                
                // Update the format flags
                
                plainText = NO;
                cpd = NO;
                rtf = NO;
                rtfd = NO;
                doc = YES;
                
                converted = NO;
                
                [data release];  // We're done with the file data
                
                return YES;
            }
            
            // This is for Mac OS X versions prior to Panther, which don't support Word format
            
            else
            {
                // This will give more information than Cocoa's generic "Can't open file 'xxx.xxx'." alert.
                // It will run an alert panel, and then let Apple let us know it couldn't be opened.
                
                NSRunAlertPanel(L_WORD_FAILED_SHEET_TITLE, L_WORD_FAILED_SHEET_DESCRIPTION, L_OK_BUTTON, @"", nil);
                
                return NO;
            }
        }
        
        // Otherwise, open whatever text is in the file
        
        else
        {
            NSString *plainTextString = [[NSString alloc] initWithContentsOfFile:fileName];
            
            if (plainTextString == nil)
            {
                // This will give more information than Cocoa's generic "Can't open file 'xxx.xxx'." alert.
                // It will run an alert panel, and then let Apple let us know it couldn't be opened.
                
                NSRunAlertPanel(L_OPEN_FAILED_SHEET_TITLE, L_OPEN_FAILED_SHEET_DESCRIPTION, L_OK_BUTTON, @"", nil);
                
                return NO;
            }
            
            // Update the format flags
            
            plainText = YES;
            cpd = NO;
            rtf = NO;
            rtfd = NO;
            doc = NO;
            
            converted = NO;
            
            // Update everything
            
            [self setString:plainTextString];  // The string is now the loaded data, and retained by us
            [plainTextString release];  // The string did its job -- we don't need it anymore
            
            return YES;
        }
    }
    
    // Otherwise, open whatever text is in the file (even if it's CPD, RTF, etc.)
    
    else
    {
        NSString *plainTextString = [[NSString alloc] initWithContentsOfFile:fileName];
        
        if (plainTextString == nil)
        {
            // This will give more information than Cocoa's generic "Can't open file 'xxx.xxx'." alert.
            // It will run an alert panel, and then let Apple let us know it couldn't be opened.
            
            NSRunAlertPanel(L_OPEN_FAILED_SHEET_TITLE, L_OPEN_FAILED_SHEET_DESCRIPTION, L_OK_BUTTON, @"", nil);
            
            return NO;
        }
        
        // Update the format flags
        
        plainText = YES;
        cpd = NO;
        rtf = NO;
        rtfd = NO;
        doc = NO;
        
        converted = NO;
        
        // Update everything
        
        [self setString:plainTextString];  // The string is now the loaded data, and retained by us
        [plainTextString release];  // The string did its job -- we don't need it anymore
        
        return YES;
    }
    
    return YES;
}

/***** This actually loads the document *****/

/*
 * This is used when recovering backup data,
 * so we don't have to deal with messy file
 * paths and stuff -- we'll just create a new,
 * untitled document, and then load the contents!
 */

- (void)loadDocument
{
    NSRange documentLength = NSMakeRange(0, [[textView string] length]);  // The document length
    
    //
    // Set the file type and load the document
    //
    
    if (cpd)
    {
        // Load the document with RTFD (CPD) data (if it's not nil)
        
        if (fileContents != nil)
        {
            NSAttributedString *docString = [[NSAttributedString alloc] initWithRTFD:fileContents documentAttributes:nil];
            
            // If we don't check, new documents will give an "Unable to
            // read RTFD from data:0x0" when we update the text view...
            
            [textView replaceCharactersInRange:documentLength withRTFD:fileContents];
            
            [docString release];
        }
        
        else
        {
            [textView setTypingAttributes:[self defaultTextAttributes]];
        }
        
        [self setFileType:CP_CPDocument];  // Set the file type
    }
    
    else if (rtf)
    {
        // Load the document with RTF data (if it's not nil)
        
        if (fileContents != nil)
        {
            NSAttributedString *docString = [[NSAttributedString alloc] initWithRTF:fileContents documentAttributes:nil];
            
            // Although RTF and Word data don't complain like RTFD does,
            // it doesn't hurt to check if the data is nil, right?
            
            [textView replaceCharactersInRange:documentLength withRTF:fileContents];
            
            [docString release];
        }
        
        else
        {
            [textView setTypingAttributes:[self defaultTextAttributes]];
        }
        
        [self setFileType:CP_RTFDocument];  // Set the file type
    }
    
    else if (rtfd)
    {
        // Load the document with RTFD data (if it's not nil)
        
        if (fileContents != nil)
        {
            NSAttributedString *docString = [[NSAttributedString alloc] initWithRTFD:fileContents documentAttributes:nil];
            
            // If we don't check, new documents will give an "Unable to
            // read RTFD from data:0x0" when we update the text view...
            
            [textView replaceCharactersInRange:documentLength withRTFD:fileContents];                
            
            [docString release];
        }
        
        else
        {
            [textView setTypingAttributes:[self defaultTextAttributes]];
        }
        
        [self setFileType:CP_RTFDDocument];  // Set the file type
    }
    
    else if (doc)
    {
        // Load the Word data (my code was buggy as hell, so I just copied
        // Ali Ozer's code from TextEdit... heh heh).
        
        if (fileContents != nil)
        {
            NSLayoutManager *layoutManager = [textView layoutManager];
            NSURL *url = [NSURL fileURLWithPath:[self fileName]];
            NSMutableDictionary *options = [NSMutableDictionary dictionary];
            
            // Temporarily remove layout manager so it doesn't do any work while loading
            [layoutManager retain];
            [textStorage removeLayoutManager:layoutManager];
            
            [textStorage beginEditing];
            [textStorage readFromURL:url options:options documentAttributes:nil];  // Read!
            [textStorage endEditing];
            
            // Hook layout manager back up
            [textStorage addLayoutManager:layoutManager];
            [layoutManager release];
        }
        
        else
        {
            [textView setTypingAttributes:[self defaultTextAttributes]];
        }
        
        [self setFileType:CP_WordDocument];  // Set the file type
    }
    
    else
    {
        [textView setString:(string == nil) ? @"" : [self string]];  // Load the text (if it's not nil)
    }
    
    [textView moveToBeginningOfDocument:nil];  // Move the cursor the top of the document
}

/***** Print the document *****/

- (void)printShowingPrintPanel:(BOOL)flag
{
    NSPrintInfo *printInfo = [self printInfo];
    NSPrintOperation *printOperation;
    
    // Format the document
    
    [printInfo setHorizontalPagination:NSFitPagination];
    [printInfo setHorizontallyCentered:NO];
    [printInfo setVerticallyCentered:NO];
    [printInfo setLeftMargin:72.0];
    [printInfo setRightMargin:72.0];
    [printInfo setTopMargin:72.0];
    [printInfo setBottomMargin:72.0];
    
    // Setup the print operation
    
    printOperation = [NSPrintOperation printOperationWithView:textView printInfo:printInfo];
    [printOperation setShowPanels:flag];
    
    // This prints the document as a sheet, instead of a modal dialog.  Also, we don't care about
    // what happens after the sheet ran, so we put nil in delegate, didRunSelector, and contextInfo.
    
    [printOperation runOperationModalForWindow:[textView window] delegate:nil didRunSelector:nil contextInfo:nil];
}

/*******************/
/* Utility methods */
/*******************/

//
// General text utilities
//

/*
 * In all of the text utilities, an attributed string containing a
 * "snapshot" of the old text is passed.  This snapshot is taken
 * whenever we register with the undo manager (by copying the text
 * storage object).  Most of the time, this string is nil, and we
 * just do a regular uppercase/lowercase/capitalize.  If the string
 * is set, though, it's basically saying "Undo", so instead of doing
 * regular stuff, we replace the current text with the snapshot we took.
 */

/***** Uppercase *****/

- (void)uppercase:(NSAttributedString *)attributedString
{
    NSString *document;
    NSRange selectedRange;
    NSUndoManager *undoManager = [self undoManager];
    
    if ([self selectedText] == nil)
        selectedRange = NSMakeRange(0, [[textView string] length]);
    
    else
        selectedRange = [textView selectedRange];
    
    // Register with undo manager
    
    [undoManager registerUndoWithTarget:self selector:@selector(uppercase:) object:[textStorage copy]];
    [undoManager setActionName:L_UNDO_UPPERCASE_ITEM_TITLE];
    
    [textStorage beginEditing];  // We're gonna edit the text
    
    if (attributedString == nil || [attributedString isKindOfClass:[NSToolbarItem class]])
    {
        // This replaces the text without harming the text's formatting
        
        document = [[[textView string] substringWithRange:selectedRange] uppercaseString];
        [textStorage replaceCharactersInRange:selectedRange withString:document];
    }
    
    else
    {
        [textStorage setAttributedString:attributedString];  // Undo the action
    }
    
    [textStorage endEditing];  // Okay, we're done
    
    [self updateView];  // Update the text view
}

/***** Lowercase *****/

- (void)lowercase:(NSAttributedString *)attributedString
{
    NSString *document;
    NSRange selectedRange;
    NSUndoManager *undoManager = [self undoManager];
    
    if ([self selectedText] == nil)
        selectedRange = NSMakeRange(0, [[textView string] length]);
    
    else
        selectedRange = [textView selectedRange];
    
    // Register with undo manager
    
    [undoManager registerUndoWithTarget:self selector:@selector(lowercase:) object:[textStorage copy]];
    [undoManager setActionName:L_UNDO_LOWERCASE_ITEM_TITLE];
    
    [textStorage beginEditing];  // We're gonna edit the text
    
    if (attributedString == nil || [attributedString isKindOfClass:[NSToolbarItem class]])
    {
        // This replaces the text without harming the text's formatting
        
        document = [[[textView string] substringWithRange:selectedRange] lowercaseString];
        [textStorage replaceCharactersInRange:selectedRange withString:document];
    }
    
    else
    {
        [textStorage setAttributedString:attributedString];  // Undo the action
    }
    
    [textStorage endEditing];  // Okay, we're done
    
    [self updateView];  // Update the text view
}

/***** Capitalize *****/

- (void)capitalize:(NSAttributedString *)attributedString
{
    NSString *document;
    NSRange selectedRange;
    NSUndoManager *undoManager = [self undoManager];
    
    if ([self selectedText] == nil)
        selectedRange = NSMakeRange(0, [[textView string] length]);
    
    else
        selectedRange = [textView selectedRange];
    
    // Register with undo manager
    
    [undoManager registerUndoWithTarget:self selector:@selector(capitalize:) object:[textStorage copy]];
    [undoManager setActionName:L_UNDO_CAPITALIZE_ITEM_TITLE];
    
    [textStorage beginEditing];  // We're gonna edit the text
    
    if (attributedString == nil || [attributedString isKindOfClass:[NSToolbarItem class]])
    {
        // This replaces the text without harming the text's formatting
        
        document = [[[textView string] substringWithRange:selectedRange] capitalizedString];
        [textStorage replaceCharactersInRange:selectedRange withString:document];
    }
    
    else
    {
        [textStorage setAttributedString:attributedString];  // Undo the action
    }
    
    [textStorage endEditing];  // Okay, we're done
    
    [self updateView];  // Update the text view
}

/***** Change the document background color *****/

- (void)changeBackgroundColor
{
    NSColorPanel *colorPanel = [NSColorPanel sharedColorPanel];
    NSColor *backgroundColor = [textView backgroundColor];
    
    // So the color panel won't interfere with the text color
    documentTextColor = [textView textColor];
    
    if (documentTextColor == nil)
    {
        // Use the default color instead
        documentTextColor = [NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:CP_TextColor]];
    }
    
    [textView setTextColor:documentTextColor];
    
    // We want to intercept any changes made to the color panel
    
    [colorPanel setAction:@selector(colorDidChange:)];
    [colorPanel setTarget:self];
    [colorPanel setDelegate:self];
    
    // Set the color panel's initial color to the current background
    // color.  We don't want this to be nil, though!
    
    if (backgroundColor != nil)
    {
        [colorPanel setColor:backgroundColor];
    }
    
    else
    {
        [colorPanel setColor:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:CP_BackgroundColor]]];
    }
    
    [colorPanel orderFront:self];  // Show the color panel
}

//
// Color panel stuff
//

/***** Color Picker action methood *****/

- (void)colorDidChange:(id)sender
{
    NSColor *color = [[NSColorPanel sharedColorPanel] color];
    
    [textView setBackgroundColor:color];
    [textView setTextColor:documentTextColor];
}

/***** Resign ourselves from the color panel's focus when it closes *****/

- (BOOL)windowShouldClose:(id)sender
{
    if (![sender isKindOfClass:[NSColorPanel class]])
        return YES;  // We don't want to bog down regular window closing
    
    // We don't want to intercept changes anymore
    
    [sender setDelegate:nil];
    [sender setAction:nil];
    [sender setTarget:nil];
    
    [[[[NSDocumentController sharedDocumentController] currentDocument] textView] setTextColor:documentTextColor];
    
    return YES;
}

//
// Document format conversion utilities
//

/***** Convert to CocoaPad format *****/

- (void)convertToCPD
{
    NSData *textColorAsData;
    
    if (plainText)
    {
        [textView setFont:[NSFont userFontOfSize:0.0]];  // Set the default font
        
        // Set the color to the what the prefs say
        textColorAsData = [[NSUserDefaults standardUserDefaults] objectForKey:CP_TextColor];        
        [textView setTextColor:[NSUnarchiver unarchiveObjectWithData:textColorAsData]];
    }
    
    // Update the format flags
    
    plainText = NO;
    cpd = YES;
    rtf = NO;
    rtfd = NO;
    doc = NO;
    
    converted = YES;
    
    // Update fileContents
    fileContents = [[textStorage RTFDFromRange:NSMakeRange(0, [[textView string] length]) documentAttributes:nil] retain];
        
    [self updateView];  // Update the text view
}

/***** Convert to Rich Text Format *****/

- (void)convertToRTF
{
    NSData *textColorAsData;
    
    if (plainText)
    {
        [textView setFont:[NSFont userFontOfSize:0.0]];  // Set the default font
        
        // Set the text color to the what the preferences say
        textColorAsData = [[NSUserDefaults standardUserDefaults] objectForKey:CP_TextColor];
        [textView setTextColor:[NSUnarchiver unarchiveObjectWithData:textColorAsData]];
    }
    
    // Update the format flags
    
    plainText = NO;
    cpd = NO;
    rtf = YES;
    rtfd = NO;
    doc = NO;
    
    converted = YES;
    
    // Update fileContents
    fileContents = [[textStorage RTFFromRange:NSMakeRange(0, [[textView string] length]) documentAttributes:nil] retain];
        
    [self removeAttachments];  // Get rid of all the graphics and stuff
    [self updateView];  // Update the text view
}

/***** Convert to RTFD format *****/

- (void)convertToRTFD
{
    NSData *textColorAsData;
    
    if (plainText)
    {
        [textView setFont:[NSFont userFontOfSize:0.0]];  // Set the default font
        
        // Set the color to the what the prefs say
        textColorAsData = [[NSUserDefaults standardUserDefaults] objectForKey:CP_TextColor];        
        [textView setTextColor:[NSUnarchiver unarchiveObjectWithData:textColorAsData]];
    }
    
    // Update the format flags
    
    plainText = NO;
    cpd = NO;
    rtf = NO;
    rtfd = YES;
    doc = NO;
    
    converted = YES;
    
    // Update fileContents
    fileContents = [[textStorage RTFDFromRange:NSMakeRange(0, [[textView string] length]) documentAttributes:nil] retain];
        
    [self updateView];  // Update the text view
}

/***** Convert to Word format *****/

- (void)convertToDocFormat
{
    NSData *textColorAsData;
    
    if (plainText)
    {
        [textView setFont:[NSFont userFontOfSize:0.0]];  // Set the default font
        
        // Set the text color to the what the preferences say
        textColorAsData = [[NSUserDefaults standardUserDefaults] objectForKey:CP_TextColor];
        [textView setTextColor:[NSUnarchiver unarchiveObjectWithData:textColorAsData]];
    }
    
    // Update the format flags
    
    plainText = NO;
    cpd = NO;
    rtf = NO;
    rtfd = NO;
    doc = YES;
    
    converted = YES;
    
    // Update fileContents
    fileContents = [[textStorage docFormatFromRange:NSMakeRange(0, [[textView string] length]) documentAttributes:nil] retain];
    
    [self removeAttachments];  // Get rid of all the graphics and stuff
    [self updateView];  // Update the text view
}

/***** Convert to plain text format *****/

- (void)convertToTXT
{
    // Update the format flags
    
    plainText = YES;
    cpd = NO;
    rtf = NO;
    rtfd = NO;
    doc = NO;
    
    converted = YES;
    
    [self removeAttachments];  // Get rid of all the graphics and stuff
    
    // Now update everything
        
    [self updateView];  // Update the text view
}

/***** Convert to plain text format (showing formatting warning sheet) *****/

- (void)convertToPlainText
{
    SEL selector = @selector(sheetDidEnd:returnCode:contextInfo:);  // The "sheetDidEnd" method
    
    // Run a warning sheet if the document contains any formatting,
    // which will get nuked when converting to plain text.
    
    if ([self containsFormatting])
    {
        NSBeginAlertSheet(L_CONVERT_TXT_SHEET_TITLE, L_OK_BUTTON, L_CANCEL_BUTTON, nil, [self currentWindow], self, nil, selector, nil, L_CONVERT_TXT_SHEET_DESCRIPTION, nil);
    }
    
    else
    {
        // Set the format to plain text, no questions asked.
        [self convertToTXT];
    }
}

// Handle post-sheet displayed stuff

- (void)sheetDidEnd:(NSWindow *)sheet returnCode:(int)result contextInfo:(void *)contextInfo
{
    if (result == NSAlertDefaultReturn)
    {
        // Set the format to plain text
        [self convertToTXT];
    }
}

/***** Contains formatting? *****/

/*
 * Used when converting to plain text (to check
 * whether or not to put up a warning sheet).
 *
 * This was originally written by Apple engineer
 * Ali Ozer for TextEdit.
 */

- (BOOL)containsFormatting
{
    int length = [textStorage length];
    NSRange range;
    NSDictionary *attributes;
    
    return (!plainText && (length > 0) && (attributes = [textStorage attributesAtIndex:0 effectiveRange:&range]) && ((attributes == nil) || (range.length < length) || ![[self defaultTextAttributes] isEqual:attributes]));
}

/***** Get the default text attributes *****/

/*
 * This was originally written by Apple engineer
 * Ali Ozer for TextEdit.
 */

- (NSDictionary *)defaultTextAttributes
{
    static NSParagraphStyle *defaultParagraphStyle = nil;
    NSMutableDictionary *textAttributes = [[[NSMutableDictionary alloc] initWithCapacity:2] autorelease];
    
    if (defaultParagraphStyle == nil)
    {
        // We do this once...
        
        int i;
        NSString *measurementUnits = [[NSUserDefaults standardUserDefaults] objectForKey:@"AppleMeasurementUnits"];
        float tabInterval = ([@"Centimeters" isEqual:measurementUnits]) ? (72.0 / 2.54) : (72.0 / 2.0);  // Every cm or half inch
        NSMutableParagraphStyle *paragraphStyle = [[NSMutableParagraphStyle alloc] init];
        
        [paragraphStyle setTabStops:[NSArray array]];  // This first clears all tab stops
        
        for (i = 0; i < 16; i++)
        {
            // Add 16 tab stops, at desired intervals...
            
            NSTextTab *tabStop = [[NSTextTab alloc] initWithType:NSLeftTabStopType location:tabInterval * (i + 1)]; 
            [paragraphStyle addTabStop:tabStop];
            [tabStop release];
        }
        
        defaultParagraphStyle = [paragraphStyle copy];
        [paragraphStyle release];
    }
    
    // This step is necessary in order for the text view to actually work
    [textAttributes setObject:(plainText) ? [NSFont userFixedPitchFontOfSize:0.0] : [NSFont userFontOfSize:0.0] forKey:NSFontAttributeName];
    
    // This step is necessary in order for the containsFormatting check to work
    [textAttributes setObject:[NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:CP_TextColor]] forKey:NSForegroundColorAttributeName];
    
    // Assign our new paragraph style, containing the ruler (unless it's plain text)
    [textAttributes setObject:(plainText) ? [NSParagraphStyle defaultParagraphStyle] : defaultParagraphStyle forKey:NSParagraphStyleAttributeName];
    
    return textAttributes;
}

/***** Remove all attachments, graphics, etc. *****/

/*
 * This was originally written by Apple engineer Ali Ozer for
 * TextEdit.  I cleaned it up a bit and changed the comments.
 */

- (void)removeAttachments
{
    unsigned location = 0;
    unsigned end = [textStorage length];
    
    [textStorage beginEditing];  // We're gonna edit the text
    
    // Go through the document, looking for attachments
    
    while (location < end)
    {
        NSRange attachmentRange;
        NSTextAttachment *attachment = [textStorage attribute:NSAttachmentAttributeName atIndex:location longestEffectiveRange:&attachmentRange inRange:NSMakeRange(location, end - location)];
        
        if (attachment != nil)
        {
            // Okay...I think we found something
            
            unichar currentCharacter = [[textStorage string] characterAtIndex:location];
            
            if (currentCharacter == NSAttachmentCharacter)
            {
                // Yes, it's an attachment -- let's get rid of it
                
                [textStorage replaceCharactersInRange:NSMakeRange(location, 1) withString:nil];
                end = [textStorage length];
            }
            
            else
            {
                location++;  // Keep going...
            }
        }
        
        else
        {
            location = NSMaxRange(attachmentRange);
        }
    }
    
    [textStorage endEditing];  // Okay, we're done
}

/********************/
/* Updating methods */
/********************/

/***** Update the text view *****/

- (void)updateView
{
    // There are different procedures for plain text, RTF, and RTFD (CocoaPad's format), and RTFD packages,
    // so we have to check what we're editing
    
    BOOL showRuler = [[NSUserDefaults standardUserDefaults] boolForKey:CP_ShowRuler];
    NSColor *textColor = [NSUnarchiver unarchiveObjectWithData:[[NSUserDefaults standardUserDefaults] objectForKey:CP_TextColor]];
    
    // Set format-specific properties
    
    if (plainText)
    {
        [self updateString];  // Update the text view's string
        
        // Set the document properties
        
        [self setFileType:CP_TextDocument];  // Set the file type
        [textView setFont:[NSFont userFixedPitchFontOfSize:0.0]];  // Our mono font
        [textView setUsesRuler:NO];  // No ruler with plain text
        [textView setImportsGraphics:NO];  // Plain text doesn't have images!
        [textView setTextColor:textColor];  // Set the text color
        [textView setRichText:NO];  // We're not working with Rich Text
    }
    
    else
    {
        [textView setUsesRuler:YES];  // We do use the ruler
        [textView setRulerVisible:showRuler];  // Set the ruler visibility
        [textView setImportsGraphics:(cpd || rtfd)];  // CPD and RTFD formats import graphics
        [textView setRichText:YES];  // We're working with Rich Text
        
        // Set the file type
        
        if (cpd)
        {
            [self setFileType:CP_CPDocument];
        }
        
        else if (rtf)
        {
            [self setFileType:CP_RTFDocument];
        }
        
        else if (rtfd)
        {
            [self setFileType:CP_RTFDDocument];
        }
        
        else if (doc)
        {
            [self setFileType:CP_WordDocument];
        }
    }
}

/***** Update the string (if this is plain text) *****/

- (void)updateString
{
    // RTF/RTFD doesn't use a string -- it uses a data object
    
    if (plainText)
    {
        [self setString:[textView string]];
    }
}

/***** Override the dealloc method so we can release our own objects *****/

// We're tidy programmers, so we have to clean up after ourselves when we're done

- (void)dealloc
{
    // Release instance objects we allocated memory for
    [fileContents release];
    [textStorage release];
    
    [super dealloc];  // ...we now return to the previously scheduled deallocation.
}

@end