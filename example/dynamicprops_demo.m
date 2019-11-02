% demo for dynamicprops

% create object from a derived class
obj = dynamicprops_class;

% add a new property. It is empty.
addprop (obj, 'field1');
f1=obj.field1;
disp ("f1=")
disp (f1)

% store something in the new property and check
obj.field1 = 42;
disp ('f1=')
disp (obj.field1);

if (obj.field1 == 42)
  disp('Test: OK') 
else 
  disp('Test: FAILED'); 
endif
