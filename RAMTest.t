

% So, resizing an array does not leak. However, recreating 

class anASDF
    var blah : int := 10
end anASDF

var asdf : flexible array 1..0 of pointer to anASDF

new asdf, 100
for i : 1..upper(asdf)
    new anASDF, asdf(i)
end for
    
loop
    new asdf, 100               % Does not leak
    %for i : 1..upper(asdf)
    %    free asdf(i)           % Will make next line not leak
    %    new anASDF, asdf(i)    % Leaks
    %end for
    cls()
    put "TROLOL"
end loop