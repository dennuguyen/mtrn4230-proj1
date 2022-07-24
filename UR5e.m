classdef UR5e < handle
    properties
        UR5e_handle;
        home = [-588.53, -133.30, 371.91, 2.2214, -2.2214, 0.00]; % [x,y,z,r,p,y]
        tool_height = 80;
        tcp_rotation = [2.2214, -2.2214, 0.00];
        moves = [];
        pose_history = [];
        joint_position_history = [];
        joint_velocity_history = [];
        joint_acceleration_history = [];
        joint_torque_history = [];
    end

    methods
        %% Constructor.
        function obj = UR5e(host, port, home)
            obj.UR5e_handle = rtde(host, port);
            
            if exist('home', 'var')
                obj.home = home;
            end
        end
        
        %% Destructor.
        function delete(obj)
            obj.UR5e_handle.close(); % Close connection.
        end

        %% Move to home.
        function move_to_home(obj)
            obj.UR5e_handle.movej(obj.home);
        end
        
        %% Execute all moves.
        function execute(obj)
            fprintf("Program started.\n");
            obj.move_to_home();
            for i = 1:length(obj.moves)
                pose_as_cell = num2cell(obj.moves(i).pose);
                fprintf("Moving to [%d, %d, %d, %d, %d, %d]...\n", pose_as_cell{:});
                [pose, joint_position, joint_velocity, joint_acceleration, joint_torque] = obj.moves(i).execute();
                obj.pose_history = [obj.pose_history; pose];
                obj.joint_position_history = [obj.joint_position_history; joint_position];
                obj.joint_velocity_history = [obj.joint_velocity_history; joint_velocity];
                obj.joint_acceleration_history = [obj.joint_acceleration_history; joint_acceleration];
                obj.joint_torque_history = [obj.joint_torque_history; joint_torque];
            end
            obj.move_to_home();
            fprintf("Program completed.\n");
        end

        %% Draw the moves.
        function draw(obj, draw_path, draw_joint_position, draw_joint_velocity, draw_joint_acceleration, draw_joint_torque)
            if draw_path
                obj.UR5e_handle.drawPath(obj.pose_history);
            end

            if draw_joint_position
                obj.UR5e_handle.drawJointPositions(obj.joint_position_history);
            end

            if draw_joint_velocity
                obj.UR5e_handle.drawJointVelocities(obj.joint_velocity_history);
            end

            if draw_joint_acceleration
                obj.UR5e_handle.drawJointAccelerations(obj.joint_acceleration_history);
            end

            if draw_joint_torque
                obj.UR5e_handle.drawJointTorques(obj.joint_torque_history);
            end
        end

        %% Queue move.
        function add_move(obj, varargin)
            for i = 2:length(varargin)
                obj.moves = [obj.moves; varargin{i}];
                obj.moves(end).UR5e_handle = obj.UR5e_handle;
            end
        end

        %% Get the TCP position.
        function pose = actual_pose(obj)
            pose = obj.UR5e_handle.actualPosePositions();
        end
    end
end
