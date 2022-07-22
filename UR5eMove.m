classdef UR5eMove
    properties
        UR5e_handle;
        move_type = 'l'; % l, j, c.
        pose = zeros(1, 6); % [x, y, z, roll, pitch, yaw].
        a; % Tool acceleration.
        v; % Tool velocity.
        t; % Time.
        r; % Blend radius.
        m; % Mode: 0 = unconstrained tool angle, 1 = fixed tool angle.
    end
    
    methods
        %% Constructor.
        function obj = UR5eMove(move_type, pose)
            obj.move_type = move_type;
            obj.pose = pose;

%             if length(varargin) > 2
%                 if ~isempty(varargin{'a'})
%                    obj.a = a
%                    disp("HERE");
%                 end
%             end
        end
        
        %% Execute move.
        function [pose, joint_position, joint_velocity, joint_acceleration, joint_torque] = execute(obj)
%             vargs = {obj.pose};
% 
%             if (obj.move_type == 'l' || obj.move_type == 'j') && ~isempty(obj.a) && ~isempty(obj.v) && ~isempty(obj.t) && ~isempty(obj.r)
%                 vargs{end + 1} = 'pose';
%                 vargs = cat(1, [vargs(:)', {obj.a}, {obj.v}, {obj.t}, {obj.r}]);
%             elseif obj.move_type == 'c' && ~isempty(obj.a) && ~isempty(obj.v) && ~isempty(obj.r) && ~isempty(obj.m)
%                 vargs{end + 1} = 'pose';
%                 vargs = cat(1, [vargs(:)', {obj.a}, {obj.v}, {obj.r}, {obj.m}]);
%             end

            if obj.move_type == 'l'
                [pose, joint_position, joint_velocity, joint_acceleration, joint_torque] = obj.UR5e_handle.movel(obj.pose);
            elseif obj.move_type == 'j'
                [pose, joint_position, joint_velocity, joint_acceleration, joint_torque] = obj.UR5e_handle.movej(obj.pose);
            elseif obj.move_type == 'c'
                [pose, joint_position, joint_velocity, joint_acceleration, joint_torque] = obj.UR5e_handle.movec(obj.pose);
            else
                error("Move type is undefined. Expected 'l', 'j', 'c' but got %c", obj.move_type);
            end
        end
    end
end