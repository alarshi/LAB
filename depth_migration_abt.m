clear
% names of the files correspond to the depth point values, checked and
% verified
% depth migration of the events based on the piercing points using iasp91
depth_points = load('depth_points_comp.txt');
fileID_r = fopen('./names_comp_r.txt');
fileID_z = fopen('./names_comp_z.txt');
f_names_r = textscan(fileID_r, '%s');
f_names_z = textscan(fileID_z, '%s');

dt = 0.01;
depths = 11:300;
depths_compare = round(depth_points, 2);
depths_compare(depths_compare == 1) = 0;
num = 1;

fileID_1 = fopen('./receiv_coordinates_comp.txt');
data = textscan(fileID_1, '%s %f %f');
fclose(fileID_1);

lat_arr = 32.5:1:40;
long_arr = -93.5:1:-85;

lat = data{2}(:);
lng = data{3}(:);

% reference stations for calculating time delays
% event 101, station USIN
rseis_ref = readsac(f_names_r{1}(643));
zseis_ref = readsac(f_names_z{1}(643));
depth_ref = nonzeros(depths_compare(643, :));

for i = 1:length(lat_arr) - 1 
    for j = 1:length(long_arr) - 1
%         eval(['bin_',num2str(num), ...
%              '=[lat(lat>=lat_arr(i) & lat<lat_arr(i+1) & lng>=long_arr(j) & lng<long_arr(j+1)), lng(lat>=lat_arr(i) & lat<lat_arr(i+1) & lng>=long_arr(j) & lng<long_arr(j+1))] ;'] ) ;
%         stat_names = data{1}(lat>=lat_arr(i) & lat<lat_arr(i+1) & lng>=long_arr(j) & lng<long_arr(j+1));
        idx = find(lat>=lat_arr(i) & lat<lat_arr(i+1) & lng>=long_arr(j) & lng<long_arr(j+1));
%         bin_num(num) =['bin_',num2str(num)];
        if (isempty( idx))
            continue;
        else
            % loop over all the receiver functions in a bin    
            rseis_shift = ones(length(idx), 24001);
            zseis_shift = ones(length(idx), 24001);
            for l = 1:length(depth_ref) 
                for k = 1:length(idx)
                % define the amplitude vector             
                    rseis = readsac(f_names_r{1}(idx(k)));
                    rseis_norm = rseis.data(1:24001)./(max(abs(rseis.data)));
                    zseis = readsac(f_names_z{1}(idx(k)));
                    zseis_norm = zseis.data(1:24001)./(max(abs(rseis.data)));
                    % check the sta lta before stacking
                    time = 0.01*(0:1:numel(zseis_norm)-1);
                    aseries = abs( hilbert(rseis_norm) ); % averaging based on hilbert abs
                    lta     = mean(aseries(time <= 40));
                    st_win = fix(8/dt);
                    s_wave1 = fix(105/dt); % S wave is assumed at 80
                    s_wave2 = fix(130/dt); 
   
                    for m = s_wave1 + 1:s_wave2
                       sta = mean(aseries(m - st_win : m));
                       sra(m) = sta / lta;
                    end
                    w = max(sra);
                    
                    dt = rseis.headerA(1);
                    nt = rseis.nsamps; % no of sample points
                    t0 = 0; % begin time
                    time = dt*(0:1:numel(rseis.data)-1);
                    time_obs = round(time, 2);
                    % remove points without the piercing points
                    depth_reason = depths_compare(idx(k), :); 
                    depth_reason(depth_reason==0) = depth_ref(depth_reason==0);
                    tau = depth_reason - depth_ref';                            
                    rseis_shift(k, :) = w.*circshift(rseis_norm, round(tau(l)/dt));
                    zseis_shift(k, :) = w.*circshift(zseis_norm, round(tau(l)/dt));
                end
                wlevel = 0.01; % water level, value of max amplitude
                dt = rseis.headerA(1); % sample rate
%                 nt = rseis.nsamps; % no of sample points
%                mkdir(sprintf('depth_%i',l))
                cd (sprintf('depth_%i',l))
                rseismean = mean(rseis_shift);
                zseismean = mean(zseis_shift);
                rf1 = water_level(zseismean', rseismean', wlevel, dt, 24001);
                
                writesac1(strcat('bin', int2str(num), '.RF'), ...
                    circshift(rf1, fix(80/dt)), 24001, dt, t0, zseis.evdistkm)
                cd ../
%                 
            end
            num = num + 1 ;
        end
%          T = cell2table(stat_names);
%          writetable(T,['./depth_binning_bin_1_comp/tabledat',num2str(num),'.txt'], 'WriteVariableNames',false);       
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

