% Utilities

class ChangeAsNeeded
    var asdf : int :=100
end ChangeAsNeeded

class ArrayList
    import ChangeAsNeeded
    
    var contents : flexible array 0..1 of pointer to ChangeAsNeeded
    
    function Upper() : int
        result upper(contents)
    end Upper
    
    function Get(i : int) : pointer to ChangeAsNeeded
        result contents(i)
    end Get
    
    procedure Add(o : pointer to ChangeAsNeeded)
        new ChangeAsNeeded, 
    end Get
    
end ArrayList