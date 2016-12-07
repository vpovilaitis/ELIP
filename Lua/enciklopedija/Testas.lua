my_object = {};     --All lua modules on Wikipedia must begin by defining a variable 
                    --that will hold their externally accessible functions.
                    --Such variables can have whatever name you want and may 
                    --also contain various data as well as functions.

my_object.hello = function( frame )     --Add a function to "my_object".  
                                        --Such functions are callable in Wikipedia
                                        --via the #invoke command.
                                        --"frame" will contain the data that Wikipedia
                                        --sends this function when it runs. 
    
    local str = "Hello, World!"  --Declare a local variable and set it equal to
                                --"Hello World!".  
    
    return str    --This tells us to quit this function and send the information in
                  --"str" back to Wikipedia.
    
end  -- end of the function "hello"

return my_object    --All modules end by returning the variable containing its
                    --functions to Wikipedia.

-- Now we can use this module by calling {{#invoke: Testas | hello }}.
-- Note that the first part of the invoke is the name of the Module's wikipage,
-- and the second part is the name of one of the functions attached to the 
-- variable that you returned.

-- The "print" function is not allowed in Wikipedia.  All output is accomplished
-- via strings "returned" to Wikipedia.
