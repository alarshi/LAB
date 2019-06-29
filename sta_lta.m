% calculate sta and lta and trigger for an exceedance over a threshold

function itm = sta_lta(ev)
% ev = 'event_0007'

cd (strcat('~/Desktop/LAB/15_11_2018/',ev, '/ReceiverTZero/'))
% ! mkdir sta_lta
lis = dir(strcat('~/Desktop/LAB/15_11_2018/', ev, '/ReceiverTZero/*RF'));


for i = 1:length(lis)
    rfseis = readsac(lis(i).name); % r component    
    dt = rfseis.headerA(1); % sample rate
    nt = rfseis.nsamps; % no of sample points
    time = 0.01*(0:1:numel(rfseis.data)-1);
    aseries = abs( hilbert(rfseis.data) ); % averaging based on hilbert abs
    lta     = mean(aseries(time <= 40));
    threshold = 3;
    st_win = fix(5/dt);
    s_wave1 = fix(75/dt); % S wave is assumed at 80
    s_wave2 = fix(90/dt); 
   
    for j = s_wave1 + 1:s_wave2
       sta = mean(aseries(j - st_win : j));
       sra(j) = sta / lta;
    end
%     for j = 1 + st_win:nt
%         sta = mean(aseries(j - st_win : j));
%         sra(j) = sta / lta;
%     end
%     
%     figure
%     plot(time, sra, 'k', 'linewidth', 1.5)
%     hold on
%     plot(time, rfseis.data, 'LineWidth', 1.5)
%     hold off
%     
    itm = (sra > threshold);
    if (sum(itm) >= 1)
        rfseis.filename
        cmd = sprintf('cp "%s" sta_lta/', rfseis.filename );
        system(cmd)
    end
%     itms = sum(itm==1); % get number of the triggers
%     trigger(i,itms)
    
end

cd ../../