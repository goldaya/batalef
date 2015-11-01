classdef graphColors < handle
    %GRAPHCOLORS simple object to iterate through colors for graphs
    
    properties ( Access = private )
        V = [];
        i = 1;
    end
    
    
    methods
        function me = graphColors()
            me.V{1} = 'blue';
            me.V{2} = 'red';
            me.V{3} = 'green';
            me.V{4} = 'black';
            me.V{5} = 'yellow';
        end
        
        function col = getNext(me)
            col = me.V{me.i};
            if me.i == 5
                me.i = 1;
            else
                me.i = me.i + 1;
            end
        end
            
    end
    
end

