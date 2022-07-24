classdef UR5eMove
    properties
        UR5e_handle;
        move_type = 'l'; % l, j, c.
        pose = zeros(1, 6); % [x, y, z, roll, pitch, yaw].
        args = {};
        a; % Tool acceleration.
        v; % Tool velocity.
        t; % Time.
        r; % Blend radius.
        m; % Mode: 0 = unconstrained tool angle, 1 = fixed tool angle.
    end
    
    methods
        %% Constructor.
        function obj = UR5eMove(move_type, pose, jointOrPose, a, v, t, r, m)
            obj.move_type = move_type;
            obj.pose = pose;

            if exist('jointOrPose', 'var')
                obj.args{1} = jointOrPose;
            end
            
            if exist('a', 'var')
                obj.args{2} = a;
            end
            
            if exist('v', 'var')
                obj.args{3} = v;
            end
            
            if exist('t', 'var')
                obj.args{4} = t;
            end
            
            if exist('r', 'var')
                obj.args{5} = r;
            end
            
            if exist('m', 'var')
                obj.args{6} = m;
            end
        end
        
        %% Execute move.
        function [pose, joint_position, joint_velocity, joint_acceleration, joint_torque] = execute(obj)
            if obj.move_type == 'l'
                [pose, joint_position, joint_velocity, joint_acceleration, joint_torque] = obj.UR5e_handle.movel(obj.pose, obj.args{:});
            elseif obj.move_type == 'j'
                [pose, joint_position, joint_velocity, joint_acceleration, joint_torque] = obj.UR5e_handle.movej(obj.pose, obj.args{:});
            elseif obj.move_type == 'c'
                [pose, joint_position, joint_velocity, joint_acceleration, joint_torque] = obj.UR5e_handle.movec(obj.pose, obj.args{:});
            else
                error("Move type is undefined. Expected 'l', 'j', 'c' but got %c", obj.move_type);
            end
        end
    end
end