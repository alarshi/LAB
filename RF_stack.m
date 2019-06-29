%close all;
% Stack S wave function across array for better source function
function RF_stack(ev)

% calculate source function from the radial component
% and stack them across for noise-free SRF
   % ev = 'event_0082';
    lis_r = dir(strcat('~/Documents/LAB/15_11_2018/', ev, '/*HR'));
    lis_z = dir(strcat('~/Documents/LAB/15_11_2018/', ev, '/*HZ'));
    %lis_r = dir(strcat('~/Desktop/LAB/processed_taper/', ev, '/ReceiverTZero/*SV'));
    dir_name = strcat('~/Documents/LAB/15_11_2018/', ev);
    cd(dir_name)
    rseis_sf = readsac(lis_r(length(lis_r)).name); % file name with accurate S wave 
    t0_sf = 0; % initial time 
    time_sf = 0.01*(0:1:numel(rseis_sf.data)-1) + t0_sf;
  %  figure
    for i = 1:length(lis_r)
       cd(dir_name)  
       
       rseis = readsac(lis_r(i).name); % r component     
       zseis = readsac(lis_z(i).name); % z component
       dt = rseis.headerA(1); % sample rate
       t0 = 0; % initial time 
       nt = rseis.nsamps; % no of sample points
       time = 0.01*(0:1:numel(rseis.data)-1) + t0;
       %rseis.data(time_sf <= 112 + t0 | time_sf >= 120 + t0) = 0;
       
%        [acor,lag] = xcorr(rseis_sf.data,rseis.data);
%        [~,I] = max((acor));
%       % lagDiff = lag(I); timeDiff = lagDiff*dt;
%        lagDiff = 0;
%         figure
%        rdl(i,:) = rseis.data; % each radial component
%        vrtcl(i,:) = zseis.data; % each vertical component
       
%        subplot(2,1,1), plot(time, (circshift(rseis.data, lagDiff))./ ...
%            max(abs(rseis.data)) , 'linewidth', 1.5)
%        set(gca, 'Fontsize', 16)
%        title(sprintf('%s', rseis.filename), 'Fontsize', 16)
%        hold on
%        subplot(2,1,2), plot(time,(circshift(zseis.data, lagDiff))./ ...
%            max(abs(rseis.data)) , 'linewidth', 1.5)
%        hold on;
%        title(sprintf('%s', zseis.filename), 'Fontsize', 16)
%        set(gca, 'Fontsize', 16)
       
%        p = 0.11 ;
       
%        for j = 1:nt
%             P_SV(:,j) = (free_surface(1.07, 2.5, p))*[-vrtcl(i,j); rdl(i,j)];
%        end
%        P = P_SV(1,:); SV(i,:) = P_SV(2,:);

% !       mkdir ReceiverTZero
        cd ReceiverTZero   
%        
%        P_pad = padarray(P, [0, 6000]);
%        SV_pad = padarray(SV, [0, 6000]);
%        time_pad = dt*(0:1:numel(P_pad)-1) + t0;
%        subplot(2,1,1), plot(time_pad, P_pad, 'linewidth', 1.5)
%        set(gca, 'Fontsize', 16)
%        title('P component', 'Fontsize', 16)
%        hold on
%        subplot(2,1,2), plot(time_pad, SV_pad, 'linewidth', 1.5)
%        hold on
%        title('SV component', 'Fontsize', 16)
%        set(gca, 'Fontsize', 16)
%        writesac1(strrep(zseis.filename,'HHZ','P'), P_pad, nt+12000, dt, t0, ...
%             zseis.evdistkm)
%        writesac1(strrep(zseis.filename,'HHZ','SV'), SV_pad(i,:), nt+12000, dt, t0, ...
%             zseis.evdistkm)  
   
    wlevel = 0.005; % water level, value of max amplitude 
    tdel = 8000;
    rf1 = water_level(zseis.data, rseis.data, wlevel, dt, nt);
    rf1_norm = rf1./(max(rf1));
%     rf1_lim = rf1/max(abs(rf1));
    
%      plot(time,circshift(rf1(i,:), tdel),'k', 'linewidth', 2)
%      xlabel('Time (s)', 'Fontsize', 18)
%      set(gca, 'Fontsize', 18)

     writesac1(strrep(zseis.filename,'HZ','RF'), circshift(rf1_norm, fix(80/dt)), nt, ...
         dt, t0, zseis.evdistkm)  

    end
    cd ../../
    %figure
    
%     stacked_sf = mean(rdl);
%     stacked_z = mean(vrtcl);
%     plot(time, stacked_sf, 'linewidth', 2)
%     hold on 
%     plot(time, stacked_z, 'linewidth', 2)
%     
%     legend ('Stacked R' ,'Stacked Z')
%     set(gca, 'Fontsize', 18)
%     stacked_sv = mean(SV_pad);
% 
%     writesac1([ev , 'stacked'], stacked_sv, nt+12000, dt, t0, ...
%             rseis_sf.evdistkm)