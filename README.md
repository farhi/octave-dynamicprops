# octave-dynamicprops
An Octave superclass allowing to add new properties dynamically

This superclass allows to add dynamically properties to an object.

Currently, it includes:
- the ```PropertyAdded``` event (but not supported by Octave 4.2)
- the ```addprop``` method
- a ```subsref``` method (called with syntax e.g. ```obj.property```)
- a ```subsasgn``` method (called with syntax e.g. ```obj.property = value```)

Usage
=====
The class derives from ```handle```, so that defining your class as:
```octave
classdef blah < dynamicprops
  ...
end
```
also sets it as a 'handle', that is a reference (pointer) object, with the attached methods and properties.
See https://octave.org/doc/v4.2.2/Value-Classes-vs_002e-Handle-Classes.html#Value-Classes-vs_002e-Handle-Classes

Then use:
```octave
obj = blah;
addprop(obj, 'field')
obj.field = 42;
```

Installation
============
Install [dynamicprops-0.1](https://github.com/farhi/octave-dynamicprops/releases/download/0.1/dynamicprops.tar.gz) manually with:

- wget https://github.com/farhi/octave-dynamicprops/releases/download/0.1/dynamicprops.tar.gz
- launch octave
- pkg install dynamicprops.tar.gz
- pkg load dynamicprops

Example
=======
You may test the ```dynamicprops``` class by running [dynamicprops_demo](https://raw.githubusercontent.com/farhi/octave-dynamicprops/master/example/dynamicprops_demo.m):
```octave
addpath /path/to/octave-dynamicprops
cd /path/to/octave-dynamicprops/example
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

The ```dynamicprops_added``` property is used to store additional, dynamic properties.

Credits
=======
(c) E. Farhi / Synchrotron Soleil (2019), GPL 2.
