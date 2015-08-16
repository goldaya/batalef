classdef bChannel < handle

    properties (Access = private)
        File
        j
    end

    properties (Dependent = true, Hidden = true)
        CallsData
        PoiData
    end

    properties (Dependent = true)
        CallsCount
    end

    methods
        % CONSTRUCTOR
        function me = bChannel(fileobj,channelIdx)
            me.File = fileobj;
            me.j    = channelIdx;
        end

        % GET CALLS COUNT
        function val = get.CallsCount(me)
            val = size(me.File.ChannelCalls{me.j}.detection,1);
        end

        % GET HIDDEN DATA
        function val = get.CallsData(me)
            val = me.File.ChannelCalls{me.j};
        end
        function val = get.PoiData(me)
            val = me.File.ChannelPoI{me.j};
        end
    end
end
