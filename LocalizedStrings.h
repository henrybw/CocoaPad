/*
 * LocalizedStrings.h
 *
 * Declare #define constants for localized strings
 *
 * Use genstrings to generate a localized string
 * table.  First, cd to the project directory.
 * Then, enter this command:
 *
 * genstrings -u -o English.lproj LocalizedStrings.h
 *
 * One other note: \\U2026 is the Unicode escape
 * code for the ellipses (…).
 */

// Define “, ‘, ’, and ” (gets rid of nasty compiler warnings)

#define L_OPENING_QUOTE NSLocalizedString(@"\\U201c", @"Opening quote")
#define L_CLOSING_QUOTE NSLocalizedString(@"\\U201d", @"Closing quote")
#define L_OPENING_SINGLE_QUOTE NSLocalizedString(@"\\U2018", @"Opening single quote")
#define L_CLOSING_SINGLE_QUOTE NSLocalizedString(@"\\U2019", @"Closing single quote")

// Buttons 'n' things

#define L_LOADING_WINDOW_TITLE NSLocalizedString(@"Loading\\U2026", @"Temporary title bar when loading the document")
#define L_OK_BUTTON NSLocalizedString(@"OK", @"OK button")
#define L_CANCEL_BUTTON NSLocalizedString(@"Cancel", @"Cancel button")
#define L_RESET_BUTTON NSLocalizedString(@"Reset", @"The Reset button (for preferences)")
#define L_APPLY_TO_ALL_BUTTON NSLocalizedString(@"Apply To All", @"The Apply To All button (for preferences)")
#define L_ALT NSLocalizedString(@"About Something\\U2026", nil)
#define L_FORMATTING_STRING NSLocalizedString(@"%@, %g point", @"The formatted string used in the font display")
#define L_NAME NSLocalizedString(@"About CocoaPad", nil)

// Undo menu item titles

#define L_UNDO_UPPERCASE_ITEM_TITLE NSLocalizedString(@"Capitalization", @"Title for undo uppercasing menu item")
#define L_UNDO_LOWERCASE_ITEM_TITLE NSLocalizedString(@"Make Text Lowercase", @"Title for undo lowercasing menu item")
#define L_UNDO_CAPITALIZE_ITEM_TITLE NSLocalizedString(@"First Letter Capitalization", @"Title for undo capitalizing menu item")

// Sheet strings

#define L_WORD_COUNT_TITLE NSLocalizedString(@"Word Count", @"Title for the word count sheet.")
#define L_WORD_COUNT_TEXT NSLocalizedString(@"Characters:\t%d\nWords:\t\t%d\nParagraphs:\t%d", @"Text used in the word count sheet.")
#define L_CONVERT_RTF_SHEET_TITLE NSLocalizedString(@"Are you sure you want to convert your document to Rich Text Format?", @"Title of the RTF format conversion sheet")
#define L_CONVERT_RTF_SHEET_DESCRIPTION NSLocalizedString(@"This will strip your document of all graphics, but leave formatting intact.", @"Description of the RTF format conversion sheet")
#define L_CONVERT_WORD_SHEET_TITLE NSLocalizedString(@"Are you sure you want to convert your document to Microsoft Word format?", @"Title of the Word format conversion sheet")
#define L_CONVERT_WORD_SHEET_DESCRIPTION NSLocalizedString(@"This will strip your document of all graphics, but leave formatting intact.\n\nCocoaPad does not support all Microsoft Word document features, such as tables, macros, and graphics, so you cannot use graphics when editing Word documents in CocoaPad.", @"Title of the Word format conversion sheet")
#define L_CONVERT_TXT_SHEET_TITLE NSLocalizedString(@"Are you sure you want to convert your document to plain text?", @"Title of the plain text format conversion sheet")
#define L_CONVERT_TXT_SHEET_DESCRIPTION NSLocalizedString(@"This will strip your document of all graphics and formatting.", @"Description of the plain text format conversion sheet")
#define L_RESET_PREFS_SHEET_TITLE NSLocalizedString(@"Are you sure you want to reset your preferences to their original settings?", @"Title of the reset preferences confirmation sheet")
#define L_RESET_PREFS_SHEET_DESCRIPTION NSLocalizedString(@"Choosing Reset will restore all settings to the state they were in when CocoaPad was first installed.\n\nThis cannot be undone.", @"Description of the reset preferences confirmation sheet")
#define L_APPLY_TO_ALL_SHEET_TITLE NSLocalizedString(@"Are you sure you want to apply your preferences to all open documents?", @"Title of the apply prefs to all documents confirmation sheet")
#define L_APPLY_TO_ALL_SHEET_DESCRIPTION NSLocalizedString(@"Choosing Apply To All will apply your current settings to all of the currently open documents in CocoaPad, so if you took the ruler off of a document, for example, and you set the preference to show the ruler, then the ruler would reappear.\n\nThis cannot be undone.", @"Description of the apply prefs to all documents confirmation sheet")
#define L_OPEN_FAILED_SHEET_TITLE NSLocalizedString(@"CocoaPad can't open this file.", @"Title of the failed to open file sheet")
#define L_OPEN_FAILED_SHEET_DESCRIPTION NSLocalizedString(@"CocoaPad can only open its own documents, rich text documents, and plain text documents.", @"Description of the failed to open file sheet")
#define L_WORD_FAILED_SHEET_TITLE NSLocalizedString(@"Mac OS X 10.3 or later is required to save and open Microsoft Word files.", @"Title of the failed to open Word file sheet")
#define L_WORD_FAILED_SHEET_DESCRIPTION NSLocalizedString(@"CocoaPad can only save and open Word files if you are running Mac OS X version 10.3 or higher.", @"Description of the failed to open Word file sheet")
#define L_FIND_FAILED_SHEET_TITLE NSLocalizedString(@"Mac OS X 10.3 or later is required to use the find panel.", @"Title of the Find not available sheet")
#define L_FIND_FAILED_SHEET_DESCRIPTION NSLocalizedString(@"CocoaPad can only find and replace text if you are running Mac OS X version 10.3 or higher.", @"Description of the Find not available sheet")
#define L_BACKUPS_RECOVERED_SHEET_TITLE NSLocalizedString(@"Automatic Backup crash recovery", @"Title of the Automatic Backup recovery sheet")
#define L_BACKUPS_RECOVERED_SHEET_DESCRIPTION NSLocalizedString(@"CocoaPad was not properly quit last time, which may have resulted in unsaved work being lost.  Because Automatic Backup was turned on, CocoaPad was able to recover the documents from the last automatic backup.  Please re-save these files.", @"Description of the Automatic Backup recovery sheet")
#define L_STRING NSLocalizedString(@"secret about box", nil)

// Toolbar strings

#define L_SHOW_TOOLBAR NSLocalizedString(@"Show Toolbar", @"Show Toolbar menu item")
#define L_HIDE_TOOLBAR NSLocalizedString(@"Hide Toolbar", @"Hide Toolbar menu item")
#define L_NEW_DOC_TOOLBAR_ITEM NSLocalizedString(@"New", @"New toolbar item")
#define L_NEW_DOC_HELP_TAG NSLocalizedString(@"Creates a new document", @"New help tag")
#define L_SAVE_TOOLBAR_ITEM NSLocalizedString(@"Save", @"Save toolbar item")
#define L_SAVE_HELP_TAG NSLocalizedString(@"Saves changes made to the current document", @"Save help tag")
#define L_SAVE_AS_TOOLBAR_ITEM NSLocalizedString(@"Save As\\U2026", @"Save As toolbar item")
#define L_SAVE_AS_HELP_TAG NSLocalizedString(@"Saves the current document with a different name", @"Save As help tag")
#define L_OPEN_TOOLBAR_ITEM NSLocalizedString(@"Open", @"Open toolbar item")
#define L_OPEN_HELP_TAG NSLocalizedString(@"Lets you choose another document to open", @"Open help tag")
#define L_PREFS_TOOLBAR_ITEM NSLocalizedString(@"Preferences", @"Preferences toolbar item")
#define L_PREFS_HELP_TAG NSLocalizedString(@"Customize CocoaPad's settings", @"Preferences help tag")
#define L_BOLD_TOOLBAR_ITEM NSLocalizedString(@"Bold", @"Bold toolbar item")
#define L_BOLD_HELP_TAG NSLocalizedString(@"Makes the selected text bold", @"Bold help tag")
#define L_ITALIC_TOOLBAR_ITEM NSLocalizedString(@"Italic", @"Italic toolbar item")
#define L_ITALIC_HELP_TAG NSLocalizedString(@"Makes the selected text italic", @"Italic help tag")
#define L_UNDERLINE_TOOLBAR_ITEM NSLocalizedString(@"Underline", @"Underline toolbar item")
#define L_UNDERLINE_HELP_TAG NSLocalizedString(@"Underlines the selected text", @"Underline help tag")
#define L_FIND_TOOLBAR_ITEM NSLocalizedString(@"Find", @"Find toolbar item (Panther and up)")
#define L_FIND_HELP_TAG NSLocalizedString(@"Shows the find and replace panel", @"Find help tag (Panther and up)")
#define L_FIND_NEXT_TOOLBAR_ITEM NSLocalizedString(@"Find Next", @"Find Next toolbar item (Panther and up)")
#define L_FIND_NEXT_HELP_TAG NSLocalizedString(@"Highlights the next occurance of whatever text you are Finding", @"Find Next help tag (Panther and up)")
#define L_CHANGE_BG_COLOR_TOOLBAR_ITEM NSLocalizedString(@"Change Background", @"Change background color toolbar item")
#define L_CHANGE_BG_COLOR_HELP_TAG NSLocalizedString(@"Brings up a color panel, where you can change the document's background color", @"Change background color help tag")
#define L_BIGGER_TOOLBAR_ITEM NSLocalizedString(@"Bigger", @"Bigger size toolbar item")
#define L_BIGGER_HELP_TAG NSLocalizedString(@"Make the selected text one point bigger", @"Bigger size help tag")
#define L_SMALLER_TOOLBAR_ITEM NSLocalizedString(@"Smaller", @"Smaller size toolbar item")
#define L_SMALLER_HELP_TAG NSLocalizedString(@"Make the selected text one point smaller", @"Smaller size help tag")
#define L_UPPERCASE_TOOLBAR_ITEM NSLocalizedString(@"Capitalize", @"Uppercase toolbar item")
#define L_UPPERCASE_HELP_TAG NSLocalizedString(@"Make the selected text UPPERCASE", @"Uppercase help tag")
#define L_LOWERCASE_TOOLBAR_ITEM NSLocalizedString(@"Lowercase", @"Lowercase toolbar item")
#define L_LOWERCASE_HELP_TAG NSLocalizedString(@"Make the selected text lowercase", @"Lowercase help tag")
#define L_CAPITALIZE_TOOLBAR_ITEM NSLocalizedString(@"Capitalize First Words", @"Capitalize toolbar item")
#define L_CAPITALIZE_HELP_TAG NSLocalizedString(@"Capitalizes the first words of the selected text", @"Capitalize help tag")
#define L_CONVERT_TO_CPD_TOOLBAR_ITEM NSLocalizedString(@"Convert to CPD", @"Convert to CPD toolbar item")
#define L_CONVERT_TO_CPD_HELP_TAG NSLocalizedString(@"Converts the document to CocoaPad format", @"Convert to CPD help tag")
#define L_CONVERT_TO_RTF_TOOLBAR_ITEM NSLocalizedString(@"Convert to RTF", @"Convert to RTF toolbar item")
#define L_CONVERT_TO_RTF_HELP_TAG NSLocalizedString(@"Converts the document to Rich Text Format", @"Convert to RTF help tag")
#define L_CONVERT_TO_RTFD_TOOLBAR_ITEM NSLocalizedString(@"Convert to RTFD", @"Convert to RTFD toolbar item")
#define L_CONVERT_TO_RTFD_HELP_TAG NSLocalizedString(@"Converts the document to Rich Text Format with Attachments", @"Convert to RTFD help tag")
#define L_CONVERT_TO_TXT_TOOLBAR_ITEM NSLocalizedString(@"Convert to plain text", @"Convert to TXT toolbar item")
#define L_CONVERT_TO_TXT_HELP_TAG NSLocalizedString(@"Converts the document to plain text format", @"Convert to TXT help tag")
#define L_CONVERT_TO_DOC_TOOLBAR_ITEM NSLocalizedString(@"Convert to Word", @"Convert to Word toolbar item")
#define L_CONVERT_TO_DOC_HELP_TAG NSLocalizedString(@"Converts the document to Microsoft Word format", @"Convert to Word help tag")