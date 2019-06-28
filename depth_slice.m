% get_piercing_points; clear bin_*;
% convert times to depths and plot the receiver functions
% function depth_slice(lat, x)

% lat = 37.5;
% indx = find(bin_total(2,:) == lat);

longitude = -89;
indx = find(bin_total(1,:) == longitude);
lat0 = min(bin_total(2, indx));
dist_deg = bin_total(2, indx) - lat0;

% long0 = min(bin_total(1, indx));
% dist_deg = bin_total(1, indx) - long0;
% cd /Users/arushi/Documents/LAB/15_11_2018/sta_lta_threshold_2_bin_1/
cd /Users/arushi/Documents/LAB/15_11_2018/depth_binning_bin_1/
% cd /Users/arushi/Documents/LAB/15_11_2018/depth_binning_bin_1_comp/rf_comp_d/

    for i = 1:length(indx)
      stack_rfs = dir(strcat('bin', num2str(indx(i)), '_stack.rf')); % get the RFs
      z_data = readsac(stack_rfs.name); 
      rf_data(:, i) = z_data.data;
    end
    
    nt = z_data.nsamps; % no of sample points
    dt = z_data.headerA(1);
    time = dt*(0:1:numel(z_data.data)-1);
    
    scale=2;
    
    figure (1)
    section_display(rf_data,scale,dist_deg,time); hold on;
    set(gca, 'Fontsize', 18)
    xlabel('Distance (deg)', 'Fontsize', 18)
    ylabel('Time (s) ', 'Fontsize', 18)
    
