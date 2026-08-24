// Copyright (c) 2025 Armin Frenzel
// License: LGPL-2.1-or-later
//
// defines constants for color data
//

// Data of a color object:
//

// Locations of information in the list:
//
// Position of the color info list
color_data_info     = 0;
//
// Position of color data.
// Contains lists of color values with the names
color_data_list     = 1;
//
// Position of data version
// Different version types have different behavior in speed and data content
// In color dataset you can set the data version you need, then only this version is used.
// You can set one value or a list of values, then 'prepare_color_name()' chose one of them.
// When you leave this empty or 'undef', function 'prepare_color_name()' chose the version.
// Version types:
// - '0'
//   - data contains lists with color and name together
//   - every list represents a language
//   - every entry in a list contains a value '[ color list as rgb, color name as string ]'
//   - the color names are sorted for fast search
// - '1'
//   - The first list contains a list with all rgb entries.
//     This list is not sorted and has the same order as created.
//   - all following lists contains the a name with the positions in the rgb list.
//     As entry '[ index in rgb list, color name as string ]'.
//   - every name list represents a language
//   - the color names are sorted for fast search
color_data_version  = 2;
//
// Position of choice if the list is prepared for use.
// Is set 'true' if this list is prepared.
// Actually unprepared color lists will not work.
// Use function 'prepare_color_name()' to prepare those lists
color_data_prepared = 3;

// Locations of the info list:
//
// Position of the full color name.
// Entry as string
color_info_name      = 0;
//
// Position of the short name for the color.
// Entry as string or a list with strings for multiple short names.
// A string will automatically transformed to a list with short names.
color_info_shortname = 1;
//
// Position of the short codes for language names for the color.
// Defined in a list with strings, each language represents a color name list.
// If a name list has no language, set an empty string for this.
// Example is string "en" for english
color_info_language  = 2;
//
// Position of filter function for color names.
// Set entry 'undef' if not needed.
//
// Function arguments:
// Get the arguments color name and the search language.
// The strings are in lower case letters.
//   function ( name , language short code actually used )
//
// The return value determines the subsequent course of action.
// - a string:
//   Use the string to search for the color name in the list.
// - a numeric value:
//   Specifies the index in the current data list.
// - a list with 2 values:
//   Specifies the number of the data list and the index within that list.
//   Format: '[ number data list, index in this list ]'
// - value 'undef':
//   No match here
// Keep in mind, that the data versions differs.
// - version 0: All lists are sorted by name. The color data may be
//              arranged differently than they were at the creation.
// - version 1: The first data list contains the color data only and has
//              the same order as created. All other lists are sorted by name.
// Maybe you must specify the version in position 'color_data_version'
color_info_function = 3;

// Locations of the color data:
//
color_entry_rgb   = 0;
color_entry_index = 0;
color_entry_name  = 1;

