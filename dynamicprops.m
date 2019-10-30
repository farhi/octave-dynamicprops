classdef dynamicprops < handle

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
      if ~ischar(prop) || isempty(prop) || isempty(h)
        error([ mfilename ': addprop: Parameter must be a string.' ]); 
      end
      for index=1:numel(h)
        this = h(index);
        this.dynamicprops_added.(prop(:)')=[];
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

