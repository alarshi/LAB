%clear
% names of the files correspond to the depth point values, checked and
% verified
% depth migration of the events based on the piercing points using iasp91
depth_points = load('depth_all_receivers.txt');
fileID = fopen('./rf_names.txt');
f_names = textscan(fileID, '%s');
dt = 0.01;
depths = 11:300;
depths_compare = round(depth_points, 2);
depths_compare(depths_compare == 1) = 0;
num = 1;

fileID_1 = fopen('./receiv_coordinates.txt');
data = textscan(fileID_1, '%s %f %f');
fclose(fileID_1);

lat_arr = 32.5:1:40;
long_arr = -93.5:1:-85;

lat = data{2}(:);
lng = data{3}(:);

k = 1;
for i = 1:length(lat_arr)-1
    for j = 1:1:length(long_arr) - 1
        eval(['bin_',num2str(num), ...
             '=[lat(lat>=lat_arr(i) & lat<lat_arr(i+1) & lng>=long_arr(j) & lng<long_arr(j+1)), lng(lat>=lat_arr(i) & lat<lat_arr(i+1) & lng>=long_arr(j) & lng<long_arr(j+1))] ;'] ) ;
        stat_names = data{1}(lat>=lat_arr(i) & lat<lat_arr(i+1) & lng>=long_arr(j) & lng<long_arr(j+1));
        idx = find(lat>=lat_arr(i) & lat<lat_arr(i+1) & lng>=long_arr(j) & lng<long_arr(j+1));
%         bin_num(num) =['bin_',num2str(num)];
        if (isempty( idx))
            continue;
        else
            bins_mid(:, k) = [long_arr(j), lat_arr(i)];
            k = k +1;
            d_ref = linspace(0, 300, 100*30);
            amp_d = zeros(size(d_ref));
            % loop over all the receiver functions in a bin       
            for k = 1:length(idx)
                % define the amplitude vector
                f = readsac(f_names{1}(idx(k)));
                time = 0.01*(0:1:numel(f.data)-1);
                time_obs = round(time, 2);
                data_time = circshift(f.data, -fix(80/dt));
                ts_tsp = flipud(data_time); % data flipped
                % remove points without the piercing points
                depth_reason = nonzeros(depths_compare(idx(k), :)); 
                [piercing_t, piercing_d] = unique(depth_reason);
               
                % time vector projected on the depth vector
                t_proj = interp1([0, depths(piercing_d)], [0; piercing_t], d_ref, 'linear', 'extrap');
%                 index = find(~isnan(t_proj));
                t_new = round(t_proj, 2);
                for l = 1:length(t_new)
                    amp_d(l) = ts_tsp(time_obs == t_new(l));
                end
                
                writesac1(strrep(f.filename,'RF','RF_d'), amp_d, 3000, 0.1, 0, ...
                 f.evdistkm)
            end
        end
        T = cell2table(stat_names);
        writetable(T,['./depth_binning_bin_1/tabledat',num2str(num),'.txt'], 'WriteVariableNames',false);
        num = num + 1 ;
    end
end
%%
% for i = 1:length(depths_compare)
%     f = readsac(f_names{1}(i));
%     data_time = circshift(f.data, -fix(80/dt));
%     time = 0.01*(0:1:numel(f.data)-1);
%     time_compare = round(time, 2);
%     ts_tsp = fliplr(data_time);
%     data_time(1) = 0;
%     
%     % finds the discontinuity structure and the amplitudes corresponding
% %     for j = 1:length(depths)
% %         idx(i,j) = find(time_compare == depths_compare(i,j));        
% %         data_depth(i, j) = data_time(idx(i,j));
% %     end        
%     
%     
%     
% end
