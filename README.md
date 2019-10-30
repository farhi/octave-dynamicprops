# octave-dynamicprops
An Octave class similar to the Matlab dynamicprops

**dynamicprops** is a class derived from the ```handle``` class. Subclass ```dynamicprops``` to define classes that support dynamic properties.
Dynamic properties are associated with a specific object of the class, but are not part of the class definition. Use dynamic properties to attach temporary data to objects. 

This class allows to add dynamically properties, just as the dynamicprops one works:
- https://fr.mathworks.com/help/matlab/ref/dynamicprops-class.html

Currently, it includes:
- the ```PropertyAdded``` event (but not supported by Octave 4.2)
- the ```addprop``` method
- a ```subsref``` method (called with syntax e.g. ```obj.property```)
- a ```subsasgn``` method (called with syntax e.g. ```obj.property = value```)

Usage
=====
The class derives from ```handle```, so that defining your class as:
```matlab
classdef blah < dynamicprops
  ...
end
```
also sets it as a 'handle', that is a reference (pointer) object, with the attached methods and properties.
See https://octave.org/doc/v4.2.2/Value-Classes-vs_002e-Handle-Classes.html#Value-Classes-vs_002e-Handle-Classes

Then use:
```matlab
obj = blah;
addprop(obj, 'field')
obj.field = 42;
```

Example
=======
You may test the ```dynamicprops`` class by running:
```matlab
addpath /path/to/octave-dynamicprops
dynamicprops_demo
```
which should return 'OK'. Look at its source to see how to use the class.

NOTE
====
If you come to redefine 'subsref' and 'subsasgn' methods, you will need to add a line such as:
```
S = subs_added(a,S);
```
when entering these methods, to allow the substructure S to search for added properties.

The ```dynamicprops_added``` property is used to store additional, dynamic properties. As opposed to matlab, it is here visible so that other Octave built-in methods work.

Credits
=======
(c) E. Farhi / Synchrotron Soleil (2019), GPL 2.
