clear;
clc;

mask = imread('italy\floor_plan_600x600.bmp');

%hard coded coordinate transfer
V_SCALE = 0.4;
V_WIDTH = 1000 * V_SCALE;
V_HEIGHT = 1000 * V_SCALE;

%reverse xy order
[v_y v_x] = find(mask==1);
v_x = v_x + 180;
v_y = v_y + 100;
v_x = v_x * V_SCALE - V_WIDTH / 2;
v_y = v_y * V_SCALE - V_HEIGHT / 2;

clear prob;

basis_centers = load('italy\b_70x70.txt');
NUM_BASIS = length(basis_centers);

NUM_ALL_POINTS = length(v_x(:));
all_points = zeros(NUM_ALL_POINTS, 2);

GAUSS_S = 2000.0;

result_terms = zeros(NUM_ALL_POINTS, NUM_BASIS);

for i=1:NUM_BASIS
    dis = (v_x(:)-basis_centers(i,1)).^2 + (v_y(:)-basis_centers(i,2)).^2;
    result_terms(:,i) = exp(-dis/GAUSS_S);
end

c_load = load('italy\c_70x70.txt');

NEW_POINT = zeros(NUM_ALL_POINTS,2);
NEW_POINT(:,1) = sum(repmat(c_load(1:2:end-6),1,NUM_ALL_POINTS)'.*result_terms,2) + c_load(end-5)*v_x(:) + c_load(end-4)*v_y(:) + c_load(end-1);
NEW_POINT(:,2) = sum(repmat(c_load(2:2:end-6),1,NUM_ALL_POINTS)'.*result_terms,2) + c_load(end-3)*v_x(:) + c_load(end-2)*v_y(:) + c_load(end);

color = zeros(NUM_ALL_POINTS,3);
for i = 1:NUM_ALL_POINTS
    color(i,1) = (v_x(i)+V_WIDTH/2)/V_WIDTH;
    color(i,2) = (v_y(i)+V_HEIGHT/2)/V_HEIGHT;
    color(i,3) = 0.5;
	depth_vis(i,1) = NEW_POINT(i,1);
	depth_vis(i,2) = NEW_POINT(i,2);
	depth_vis(i,3) = 0;
end

scatter(depth_vis(:,1),depth_vis(:,2),[],color,'*')
axis equal;