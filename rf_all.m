function rf_all
% plot RF for all events so that the time is from 0 to 120 s
    for j = 100:999
        ev = strcat('event_0', num2str(j));
%         RF_stack(ev);
        sta_lta_comp(ev);
    end
end