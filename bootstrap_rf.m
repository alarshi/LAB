% function [rdl, vrtcl, rdl_obs, vrtl_obs, rf, rf_n] = bootstrap_rf
close all;
clear;
% test the noise and coda in the synthetics
hvsd = @(x) (0.5*(x == 0) + (x > 0)); % heavy side function
dir_name = strcat('~/Documents/LAB/synthetic_diff_p_gf');
cd(dir_name)
lis_r = dir('~/Documents/LAB/synthetic_diff_p_gf/*svh'); % radial component
lis_z = dir('~/Documents/LAB/synthetic_diff_p_gf/*svv'); % vertical component
%figure
%% calculation of synthetic move-out correction
p = 0.072:0.002:0.111;
rseis = readsac(lis_r(1).name); 
dt = rseis.headerA(1);
ts_tsp(:) = (sqrt(1.59^-2 - p.^2) - sqrt(2.6^-2 - p.^2)).*1.8 + ...
(sqrt(3.53^-2 - p.^2) - sqrt(6.1^-2 - p.^2)).*11.9 + ...
(sqrt(3.71^-2 - p.^2) - sqrt(6.5^-2 - p.^2)).*14.08 + ...
(sqrt(3.93^-2 - p.^2) - sqrt(6.9^-2 - p.^2)).*22.78 + ...
(sqrt(4.53^-2 - p.^2) - sqrt(8.17^-2 - p.^2))*57.22 ;
lag_rf = round(ts_tsp/dt); 
%%
for j = 1:800
    for i = 1:5
        rseis = readsac(lis_r(i).name); 
        zseis = readsac(lis_z(i).name);
        nt = rseis.nsamps; % no of sample points
       % dt = rseis.headerA(1);
        time = dt*(0:1:numel(rseis.data)-1);
        t_s = time(abs(rseis.data) == max(abs(rseis.data)));
        t_p = ts_tsp(i);
        cv = 1.5 * max(abs(zseis.data)); 
        csc = 1.5 * max(abs(rseis.data));
        Noise = -1 + (1+1)*rand(1, nt);
        Noise_1 = -1 + (1+1)*rand(1, nt);
        gamma = 0.02;
        pscatter = cv.* conv(  Noise.*exp(-gamma.*time), gauss(time, 1, 2))./50 ;
        sscatter = csc.* conv( Noise_1.*exp(-gamma.*time), gauss(time, 1, 2))./50;
        % take the shift of two so that the gaussian pulse can be seen in time
        pcoda = circshift(pscatter(1:nt), lag_rf).* hvsd(time - t_p);
        scoda = circshift(sscatter(1:nt), round(t_s/dt)).* hvsd(time - t_s);
        % add the p and s wave coda and the background noise in the seismogram
        zseis_obs = zseis.data' + pcoda  + scoda + Noise.*1.e-2.* max(abs(zseis.data));

        Noise_2 = -1 + (1+1)*rand(1, nt);
        Noise_3 = -1 + (1+1)*rand(1, nt);
        pscatter_r = cv.* conv( Noise_2.*exp(-gamma.*time), gauss(time, 1, 2))./50;
        sscatter_r = csc.* conv( Noise_3.*exp(-gamma.*time), gauss(time, 1, 2))./50;

        pcoda_r = circshift( pscatter_r(1:nt), lag_rf).* hvsd(time - t_p);
        scoda_r = circshift( sscatter_r(1:nt), round(t_s/dt)).* hvsd(time - t_s);
        rseis_obs = rseis.data' + pcoda_r + scoda_r + (Noise.*1.e-2.* max(abs(rseis.data))); 
        rseis_sf = readsac(lis_r(1).name);
        [acor,lag] = xcorr(rseis_sf.data,rseis.data);
        [~,I] = max((acor));
        lagDiff = lag(I);
        rdl(i*j,:) = circshift(rseis.data, lagDiff);
        vrtcl(i*j,:) = circshift(zseis.data, lagDiff);
        rdl_obs(i*j,:) = circshift(rseis_obs, lagDiff);
        vrtl_obs(i*j,:) = circshift(zseis_obs, lagDiff);
    % if want to add random background noise + (Noise_r.*1.e-2.* max(abs(rseis.data))) ;
    
%     set(gca, 'Fontsize', 16)
        wlevel = 0.01; % water level, value of max amplitude 
        tdel = 4000;
        rf_n(i*j,:) = water_level(zseis_obs', rseis_obs', wlevel, dt, nt);
        rf(i*j,:) = water_level(zseis.data, rseis.data, wlevel, dt, nt); 
    end
end
%% bootstrapping for differenet kinds
bs_samples = 20:10:100;
m = 500;
for l = 1:length(bs_samples)
    for k = 1:m
        r = randi([1 4000],1,bs_samples(l));
        wlevel = 0.01;
        nt = rseis.nsamps; % no of sample points
        time = dt*(0:1:numel(rseis.data)-1);

        % load the bootstrap data
        rdl_bs = rdl(r,:);
        vrtl_bs = vrtcl(r, :);
        rdl_obs_bs = rdl_obs(r, :);
        vrtl_obs_bs = vrtl_obs(r, :);
        rf_bs = rf(r, :); 
        rf_n_bs = rf_n(r, :);

        % stacking components first

        stack_comp.radial = mean(rdl_bs); stack_comp.vrtcl = mean(vrtl_bs);
        stack_comp.radial_obs = mean(rdl_obs_bs) ; stack_comp.vrtcl_obs = mean(vrtl_obs_bs);
        stack_comp.rf_n(k,:) = water_level(stack_comp.vrtcl_obs', stack_comp.radial_obs', ...
            wlevel, dt, nt);
        stack_comp.rf(k,:) = water_level(stack_comp.vrtcl', stack_comp.radial', wlevel, dt, nt);

        stack_comp.rf_n(k,:) = stack_comp.rf_n(k,:)./(max(abs(stack_comp.rf_n(k,:) ) ) );
        stack_comp.rf(k,:) = stack_comp.rf(k,:)./(max(abs(stack_comp.rf(k,:) ) ) );
        
        stack_cdp.rf_n(k, :) = mean(rf_n_bs);  stack_cdp.rf(k, :) = mean(rf_bs); 
        stack_cdp.rf_n(k,:) = stack_cdp.rf_n(k,:)./(max(abs(stack_cdp.rf_n(k,:) ) ) );
        stack_cdp.rf(k,:) = stack_cdp.rf(k,:)./(max(abs(stack_cdp.rf(k,:) ) ) );
    %     % stacking of the SV component and calculate recevier functions from stack
    % 
    %     for i = 1:n
    %         rf_ss(i,:) = water_level(vrtl_bs(i,:)', stack_comp.radial', wlevel, dt, nt);
    %         rf_ss_obs(i,:) = water_level(vrtl_obs_bs(i,:)', stack_comp.radial_obs'...
    %             , wlevel, dt, nt);
    %     end
    %     stack_sv.rf = mean(rf_ss); stack_sv.rf_n = mean(rf_ss_obs);

        % calculate misfit of the sp phase
        stack_comp.misfit(k) = sum ( ( (stack_comp.rf (time >= 146 & time <= 153) - ...
            stack_comp.rf_n (time >= 146 & time <= 153)).^2 ) ) ;
        
        stack_cdp.misfit(k) = sum ( ( (stack_cdp.rf (time >= 146 & time <= 153) - ...
            stack_cdp.rf_n (time >= 146 & time <= 153)).^2 ) );

    %     stack_sv.misfit(k) = sum ( (stack_sv.rf (time >= 146 & time <= 153) - ...
    %     stack_sv.rf_n (time >= 146 & time <= 153)).^2 );
    end

    comp_misfit(l, :) = stack_comp.misfit;
    cdp_misfit(l,:) = stack_cdp.misfit;
end
%%
figure
rf_n_norm = rf_n./max(abs(rf_n), [], 2);
rf_norm = rf./max(abs(rf), [], 2);
% plot(time, circshift(rf_n_norm(6,:), 4000), 'k:', 'linewidth', 1.5)
% hold on
% plot(time, circshift(rf_norm(6,:), 4000), 'k', 'linewidth', 2.5)
plot(time, circshift(stack_comp.rf_n(6,:), 4000), 'r', 'linewidth', 1.5)
hold on
plot(time, circshift(stack_cdp.rf_n(6,:), 4000), 'b', 'linewidth', 1.5)
title('RF', 'Fontsize', 18)
fig = gcf;
fig.PaperUnits = 'inches';
fig.PaperPosition = [0 0 15 6];
xlim([0 160])
set(gca, 'Fontsize', 36)
xlabel('Time(s)', 'Fontsize', 36)
ylabel('Normalized amplitude of RFs', 'Fontsize', 36)