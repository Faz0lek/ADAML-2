clc

%% Choose used variables
load("all_data.mat")
data = all_data(:,[3,4,6,8,9]);

%%
data = rmmissing(data);
data_o =  data(:,1:end-1);
classes = data(:,end);
nseg = 10;
data2 = [];

for i = 1:size(data,2)-1
    
    var     = data_o(:,i);

    minVal  = min(var);
    maxVar  = max(var);

    segLength = maxVar - minVal;
    subSegLength = segLength/nseg;
    
    seg(1).LB = minVal;

    for ii = 1:nseg
        if ii ~= 1 
            seg(ii).LB = seg(ii-1).LB + subSegLength + 0.0001;
        end
    end
    
    for ii = 1:nseg-1
         idxCurrent = intersect(find(data_o(:,i)>=seg(ii).LB), find(data_o(:,i)<seg(ii+1).LB));
         data2(idxCurrent,i) = ii;
    end

    idxCurrent = find(data_o(:,i)>seg(ii+1).LB);
    data2(idxCurrent,i) = ii+1;
    
end

data(:,1:end-1) = data2;
data(:,end) = classes;
