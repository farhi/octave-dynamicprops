# octave-dynamicprops
An Octave class similar to the Matlab dynamicprops

This class allows to add dynamically properties, just as the dynamicprops one works:
- https://fr.mathworks.com/help/matlab/ref/dynamicprops-class.html

Currently, it includes:
- the 'propertyAdded' event
- the addprop method
- a subsref method (called for e.g. obj.property)
- a subsasgn method (called for e.g. obj.property = value)

Usage
=====

The class derives from handle, so that defining your class as:
```matlab
classdef blah < dynamicprops
  ...
end
```
also sets it as a 'handle', that is a reference (pointer) object, with the attached methods and properties.

If you come to redefine 'subsref' and 'subsasgn' methods, you will need to add a line such as:
```
S = subs_added(a,S);
```
to allow the substructure S to search for added properties.
