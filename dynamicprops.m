classdef dynamicprops < handle
% DYNAMICPROPS superclass for classes that support dynamic properties
%
% dynamicprops is a class derived from the handle class. Subclass dynamicprops 
% to define classes that support dynamic properties.
%
% Dynamic properties are associated with a specific object of the class, but are
% not part of the class definition. Use dynamic properties to attach temporary data to objects. 
% 
% See:
%  - https://fr.mathworks.com/help/matlab/ref/dynamicprops-class.html
%
%  Currently, it includes:
%  - the 'propertyAdded' event
%  - the 'addprop' method
%  - a 'subsref' method (called with syntax e.g. 'obj.property')
%  - a 'subsasgn' method (called with syntax e.g. 'obj.property = value')
%
% Usage
% =====
% The class derives from 'handle', so that defining your class as:
%
%   classdef blah < dynamicprops
%   ...
%   end
%  
% also sets it as a 'handle', that is a reference (pointer) object, with the 
% associated methods and properties.
% See https://octave.org/doc/v4.2.2/Value-Classes-vs_002e-Handle-Classes.html#Value-Classes-vs_002e-Handle-Classes
%
% Then use:
%   obj = blah;
%   addprop(obj, 'field')
%   obj.field = 42;
%  
% NOTE
% ====
% If you come to redefine 'subsref' and 'subsasgn' methods, you will need to add a line such as:
% 
%   S = subs_added(a,S);
%  
% to allow the substructure S to search for added properties.
%
% (c) E. Farhi / Synchrotron Soleil (2019), GPL 2.

  properties
    dynamicprops_added = []; % Properties dynamically added
  end
  
  events
    PropertyAdded
  end
  
  methods
    function prop = addprop(h, prop)
      % ADDPROP   Add dynamic property to MATLAB object.
      %  D = ADDPROP(H,'DynamicPropName') adds a dynamic property to the 
      %  objects in array H.  The added property is associated only with
      %  the objects of H.  There is no effect on the class of H.

      %  See also dynamicprops, handle
      if nargin < 2 || ~ischar(prop) || isempty(prop) || isempty(h)
        error([ mfilename ': addprop: Parameter must be a string.' ]); 
      end
      prop = prop(:)';
      if ~isvarname(prop)
        error([ mfilename ': addprop: Parameter must be a valid property name.' ]); 
      end
      for index=1:numel(h)
        this = h(index);
        this.dynamicprops_added.(prop)=[];
        h(index) = this;
        try; notify(this, 'PropertyAdded'); end
      end
    end % addprop
    
    function v = subsref(a,S)
      % SUBSREF Subscripted reference.
      %   B = SUBSREF(A,S) is called for the syntax A(I), A{I}, or A.I
      %    when A is an object.  S is a structure array with the fields:
      %        type -- string containing '()', '{}', or '.' specifying the
      %                subscript type.
      %        subs -- Cell array or string containing the actual subscripts.
      S = subs_added(a,S);
      v = builtin('subsref', a, S);
    end
    
    function a=subsasgn(a,S, v)
      % SUBSASGN Subscripted assignment.
      %   A = SUBSASGN(A,S,B) is called for the syntax A(I)=B, A{I}=B, or
      %     A.I=B when A is an object.  S is a structure array with the fields:
      %       type -- string containing '()', '{}', or '.' specifying the
      %               subscript type.
      %       subs -- Cell array or string containing the actual subscripts.
      S = subs_added(a,S);
      a = builtin('subsasgn', a, S, v);
    end
    
  end % methods
  
  methods (Access=protected)
  
    function S = subs_added(a,S)
      % SUBS_ADDED Take into account the dynamic properties
      if isempty(S), return; end
      if isempty(a.dynamicprops_added), return; end
      if ischar(S), S=struct('type','.','subs', S); end
      % we search for fields that match any of the dynamicprops_added elements
      % and add a new level above with it
      
      f     = fieldnames(a.dynamicprops_added);
      index = find(strcmp(S(1).subs, f));
      if strcmp(S(1).type, '.') && ~isempty(index)
        S0 = struct('type','.' ,'subs', 'dynamicprops_added');
        S = [ S0 S ];
      end
      
    end % subs_added
    
  end % methods protected
end % classdef dynamicprops

