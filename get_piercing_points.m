clear
fileID = fopen('/Users/arushi/Documents/LAB/lat_long.txt');
data = textscan(fileID, '%s %f %f %f %f %f');
fclose(fileID);

for i = 1:length(data{2})
    [lat(i), lng(i)] = track1(data{3}(i), data{4}(i) , data{5}(i), data{2}(i), [], ...
    'degrees', 1);
end

file_name = string(data{1});

num = 1; k = 1;

lat_arr = 32.5:0.5:40;
long_arr = -93.5:0.5:-85;

for i = 1:length(lat_arr)-1
    for j = 1:length(long_arr) - 1       
        eval(['bin_',num2str(num), ...
             '=[lat(lat>=lat_arr(i) & lat<lat_arr(i+1) & lng>=long_arr(j) & lng<long_arr(j+1)); lng(lat>=lat_arr(i) & lat<lat_arr(i+1) & lng>=long_arr(j) & lng<long_arr(j+1))] ;'] ) ;
        stat_names = data{1}(lat>=lat_arr(i) & lat<lat_arr(i+1) & lng>=long_arr(j) & lng<long_arr(j+1));
        bin_num =['bin_',num2str(num)];
         if (~isempty( eval(bin_num)))
            bin_val = eval(['bin_',num2str(num)]);          
            data_lat_long = [( bin_val(1,:)- 29)'.*111 , (bin_val(1,:) + 98)'.*111, ...
                zeros(length(bin_val(1,:)), 1)];
            out = [stat_names, num2cell(data_lat_long)];
            T = cell2table(out);
              writetable(T,['tabledat',num2str(k),'.txt'], 'WriteVariableNames',false);
            x(:, k) = [long_arr(j), lat_arr(i)];
            k = k + 1;           
         end
        num = num + 1 ;
    end
end

