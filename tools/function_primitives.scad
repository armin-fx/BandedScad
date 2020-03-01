// primitives.scad
//
// Enthält Funktionen, die die Daten für primitive Objekte erzeugen
// Es wird versucht, die originalen Module von OpenSCAD nachzubilden
//
// Rückgabe der Funktionen:
// [0][x] - Typ des Datenfeldes
// [0][0] - Dimensionen
//          2 = 2 Dimensionen
//          3 = 3 Dimensionen
//
// [1][x] - Datenfeld, welches mit polygon() (2D) oder polyhedron() (3D) verarbeitet werden kann
// 2D:
// [1][0] - polygon() - Argument points
// 3D:
// [1][0] - polyhedron() - Argument points
// [1][1] - polyhedron() - Argument faces


