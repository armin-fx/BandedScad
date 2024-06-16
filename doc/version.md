Version
=======

### defined in file
`banded/version.scad`  
` `|  
` `+--> `banded/version_helper.scad`  

[<-- file overview](file_overview.md)  
[<-- table of contents](contents.md)  

### Contents
[contents]: #contents "Up to Contents"
- [Versioning](#version---)
  - [Current version](#current-version-)
    - [`version_banded()`][version_banded]
    - [`date_banded()`][date_banded]
  - [Version check](#version-check-)
    - [`is_compatible()`][is_compatible]
    - [`is_compatible_openscad()`][is_compatible_openscad]
    - [`required_version()`][required_version]
  - [Convert version format](#convert-version-format-)
    - [`version_to_str()`][version_to_str]
    - [`str_to_version()`][str_to_version]
    - [`convert_version()`][convert_version]
    - [`convert_version_list()`][convert_version_list]
  - [Deprecated functionality](#deprecated-functionality-)
    - [`deprecated()`][deprecated]


Versioning [^][contents]
-----------------------

Contains functions and modules to manage versioning.

The version data are stored in file `version.scad`.  
The helper functions and modules are in file `version_helper.scad`
and were automatically included with `version.scad`.


### Current version [^][contents]

Get the version data of this bibliothek.

#### function version_banded() [^][contents]
[version_banded]: #function-version_banded-
Returns this version of BandedScad as a list.  
Uses Semantic Versioning.  
Versioning details see: <https://semver.org/>

Given a version number MAJOR.MINOR.PATCH, increment the:
- MAJOR version when you make incompatible API changes
- MINOR version when you add functionality in a backward compatible manner
- PATCH version when you make backward compatible bug fixes

Format: `[ MAJOR, MINOR, PATCH ]`  
or:     `[ MAJOR, MINOR, PATCH, "pre-release" ]`

This value is even stored in variable `version_banded`.

#### function date_banded() [^][contents]
[date_banded]: #function-date_banded-
Returns the build date of this version as number.  
Number format: year 4 digit - month 2 digit - day 2 digit
- e.g. number `20240227` means date `27.2.2024`

This value is even stored in variable `date_banded`.


### Version check [^][contents]

Functions and modules to check the compatibility of the version.

#### function is_compatible() [^][contents]
[is_compatible]: #function-is_compatible-
Test if this version of BandedScad is compatible with the destinated version.  
Compare Semantic Versioning scheme.

_Rules of the version to the current version:_
- The MAJOR version part must be the same number.
- The MINOR version part must be the same or less.
- If the MINOR version part is the same,
  the PATCH version part must be the same or less.
- If the version parts are equal:
  Pre-release versions have a lower precedence than the associated normal version.
  The pre-release string will be separated by dots and every entry will be
  compared until a difference is found and have following rules:
  - Identifiers consisting of only digits are compared numerically.
  - Identifiers with letters or hyphens are compared lexically in ASCII sort order.
  - Numeric identifiers always have lower precedence than non-numeric identifiers.
  - A larger set of pre-release fields has a higher precedence than a smaller set,
    if all of the preceding identifiers are equal

_Arguments:_
```OpenSCAD
is_compatible (version, current)
```
- `version`
  - the desired version
  - can be a list with versions, then one of the versions must be compatible.
    This is useful if the model is designed for an older version
    and the changes in the next major release are not used or have no effect in this version.
  - The version can be a version list or a version string
- `current`
  - optional, by default the current version of BandedScad
  - can be used to check other bibliothek versions with the same version scheme
  - must set as version list

#### function is_compatible_openscad() [^][contents]
[is_compatible_openscad]: #function-is_compatible_openscad-
Test if this version of OpenSCAD is compatible with the destinated version.

_Arguments:_
```OpenSCAD
is_compatible_openscad (version, current)
```
- `version`
  - the desired version as number, e.g. from `version_num()`
- `current`
  - optional, by default the current version of OpenSCAD as number

#### module required_version() [^][contents]
[required_version]: #module-required_version-
Assert if the current version is incompatible with the desired version.  
Compare Semantic Versioning scheme in a list.

_Arguments:_
```OpenSCAD
required_version (version, current)
```
- `version`
  - the desired version
  - can be a list with versions, then one of the versions must be compatible.
    This is useful if the model is designed for an older version
    and the changes in the next major release are not used or have no effect in this version.
- `current`
  - optional, by default the current version of BandedScad
  - can be used to check other bibliothek versions with the same version scheme

You can use this to ensure that you use the correct version.  
_Example:_
```OpenSCAD
// Assert a message if the current version is incompatible:
required_version ([1,0,0]);
```


### Convert version format [^][contents]

#### function version_to_str() [^][contents]
[version_to_str]: #function-version_to_str-
Convert a version number list to a printable string.  
The first 3 version parts MAJOR, MINOR and PATCH are separated by a dot `.`.
Missing version parts are filled with zero `0`.
If a pre-release part is set,
this will append to the string and separated by a minus `-`.  
E.g.
- `[1,2,3]`         -> `"1.2.3"`
- `[1,2]`           -> `"1.2.0"`
- `[1,2,3,"alpha"]` -> `"1.2.3-alpha"`

_Arguments:_
```OpenSCAD
version_to_str (version, default)
```
- `version`
  - the version as list in Semantic Versioning scheme
- `default`
  - optional, the version which will returned if the version is impossible to convert
  - default = `""`, an empty string

#### function str_to_version() [^][contents]
[str_to_version]: #function-str_to_version-
Convert a version number as string to a version list.

_Arguments:_
```OpenSCAD
str_to_version (txt)
```
- `txt`
  - the version as string in Semantic Versioning scheme

_Way of working:_
- Ignore first letter until the first number
- Parts of version number must separated with a dot `.`.  
  A pre-release version part must separated with a minus `-`.  
  E.g. MAJOR.MINOR.PATCH or MAJOR.MINOR.PATCH-PRERELEASE
- Missing version parts are filled with zero `0`
- First occur of another letter then a number or a dot
  will append the remain string as pre-release string.
  An occur of minus `-` will set the remain string as pre-release string.
  A number with following another letter will even seen as pre-release string.

#### function convert_version() [^][contents]
[convert_version]: #function-convert_version-
Convert a version in multiple format to a version list.

_Arguments:_
```OpenSCAD
convert_version (version, default)
```
- `version`
  - the version in Semantic Versioning scheme
- `default`
  - optional, the version which will returned if the version is impossible to convert
  - default = `[0,0,0]`

_Version formats:_
- As string, see [`str_to_version()`][str_to_version]..
  e.g. `"v.2.3.0"` -> `[2,3,0]`
- As list in format `[ MAJOR, MINOR, PATCH ]` or `[ MAJOR, MINOR, PATCH, "pre" ]`  
  e.g. `[2,3,0]` or `[2,3,0,"alpha"]`
- Missing version parts will be filled with `0`  
  e.g. `[3]` -> `[3,0,0]`

#### function convert_version_list() [^][contents]
[convert_version_list]: #function-convert_version_list-
Convert a version in multiple format to a version list.

_Arguments:_
```OpenSCAD
convert_version_list (list, default)
```
- `list`
  - a list with versions in Semantic Versioning scheme
- `default`
  - optional, the version which will returned if the version is impossible to convert
  - default = `[0,0,0]`



### Deprecated functionality [^][contents]

#### module and function deprecated() [^][contents]
[deprecated]: #module-and-function-deprecated-
Yield a 'deprecated' message in console.  
You can put this in deprecated modules or functions.
Then it will show a message if these are executed.

_Arguments:_
```OpenSCAD
deprecated (old, alternative, message)
```
- `old`
  - old deprecated name of functionality as string
- `alternative`
  - optional, alternative name of functionality as string
- `message`
  - optional, an additional text

