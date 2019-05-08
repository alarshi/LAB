lat_arr = 34:0.5:40;
long_arr = -94:0.5:-84;

dat = load('all_receivers_stalta.txt');
lat = dat(:,1); lng = dat(:,2);
k = (length(lat_arr) - 1) * (length(long_arr) - 1);
num = ones(k,1);

n = 1;
for i = 1:length(lat_arr)-1
    for j = 1:length(long_arr)-1
        bin = (lat>=lat_arr(i) & lat<lat_arr(i+1)) & (lng>=long_arr(j) & lng<long_arr(j+1));
        num(n) = sum(bin);
        n = n+1;
    end
end

x_mid = (lat_arr(1:end-1) + lat_arr(2:end))./2.;
y_mid = (long_arr(1:end-1) + long_arr(2:end))./2.;
[X,Y] = meshgrid(x_mid, y_mid);

dat_s = [reshape(X, [k,1]), reshape(Y, [k,1]), num];
save('rf_per_bin.txt','dat_s', '-ascii')