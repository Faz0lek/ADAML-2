clc
    
data = rmmissing(data);
data_o =  data(:,1:6);
classes = data(:,7);
nseg = 50;
data2 = [];

for i = 1:6
    
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

data(:,1:6) = data2;
data(:,7) = classes;
