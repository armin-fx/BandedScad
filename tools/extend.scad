// Copyright (c) 2020 Armin Frenzel
// License: LGPL-2.1-or-later
//
// erweitert einige eingebaute Module um weitere Eigenschaften,
// steuern die Auflösungsgenauigkeit der kurvigen Objekte
//
// Aufbau:
//     <Modulname>_extend
//
// hinzugefügte Eigenschaften:
//  - Variablen mit weiteren Begrenzungen, wenn $fn nicht gesetzt ist ($fn=0). deaktiviert, wenn auf 0 gesetzt.
//      $fn_min  - Objekte werden in mindestens so viele Fragmente gebaut wie angegeben,
//      $fn_max  - Objekte werden in höchstens so viele Fragmente gebaut wie angegeben,
//      $fd      - maximale Abweichung des Modells in mm
//      $fq      - Fragmenteanzahl quantisieren = durch diese Zahl teilbar, wenn angegeben
//                 TODO - noch nicht implementiert -
//      $fn_safe - Anzahl der Fragmente, wenn alle Begrenzungen deaktiviert wurden. Standardwert = 12
// veränderte Eigenschaften:
//  - interne Variablen können deaktiviert werden mit entsprechende Schalter.
//    wird aktiviert mit true (Standart), deaktiviert mit false
//      $fa_enabled - für $fa = kleinster Winkel pro Fragmente
//      $fs_enabled - für $fs = kleinste Größe eines Fragments in mm

include <tools/extend_logic.scad>
include <tools/extend_object.scad>
