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
// Position of choice if the list is prepared for use.
// Is set 'true' if this list is prepared.
// Actually unprepared color lists will not work.
// Use function 'prepare_color_name()' to prepare those lists
color_data_prepared = 2;
//
// Position of data version
// Different version types have different behavior in speed and data content
// Version types:
// - '0'
//   - data contains lists with color and name together
//   - every list represents a language
//   - every entry in a list contains a value '[ color list as rgb, color name as string ]'
//   - the color names are sorted for fast search
// - '1'
//   - first list contains a list with all rgb entries
//   - all following lists contains the a name with the positions in the rgb list.
//     As entry '[ index in rgb list, color name as string ]'.
//   - every name list represents a language
//   - the color names are sorted for fast search
color_data_version  = 3;

// Locations of the info list:
//
// Position of the full color name
color_info_name      = 0;
//
// Position of the short name for the color.
color_info_shortname = 1;
//
// Position of the short codes for language names for the color.
// Defined in a list with strings, each language represents a color name list.
// If a name list has no language, set an empty for this.
// Example is string "en" for english
color_info_language  = 2;
//
// Position of filter function for color names.
// Returns a color name in the list from argument name and the search language
// Set 'undef' if not needed.
// Function arguments:
//   function ( name , short code for language actually used )
color_info_function = 3;

// Locations of the color data:
//
color_entry_rgb   = 0;
color_entry_index = 0;
color_entry_name  = 1;

