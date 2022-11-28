clc; close all



%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%Data needs to be discretized before running this code
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Divide data into train and test
[n_samples, n_vars] = size(data);

train_data = [];
test_data = [];

for i = 1:10
    class_data = data(data(:, end) == i,:);
    idx = randi([1 length(class_data)],80 ,1);

    m = 1:length(class_data);
    m(idx) = [];

    train_data = [train_data; class_data(m,:)];
    test_data = [test_data; class_data(idx,:)];
end

%%
clc;close all
A = 1; B = 2; C = 3; D = 4; E = 5; %F = 6; %G = 7;
numb = size(data,2);


%nseg from discretize
node_sizes = [ones(1,numb-1) * nseg, 10];
cases = num2cell(train_data');

DAGhat = learn_struct_K2(cases, node_sizes, [A B C D E], ...
  'max_fan_in', 4);
% DAGhat = learn_struct_K2(cases, node_sizes, [A B C D E F G], ...
%   'max_fan_in', 2);

BNtemp = mk_bnet(DAGhat, node_sizes);
BNtemp.CPD{A} = tabular_CPD(BNtemp, A);
BNtemp.CPD{B} = tabular_CPD(BNtemp, B);
BNtemp.CPD{C} = tabular_CPD(BNtemp, C);
BNtemp.CPD{D} = tabular_CPD(BNtemp, D);
BNtemp.CPD{E} = tabular_CPD(BNtemp, E);
% BNtemp.CPD{F} = tabular_CPD(BNtemp, F);
% BNtemp.CPD{G} = tabular_CPD(BNtemp, G);


BNhat = learn_params(BNtemp, cases);
BNhat

% Visualise the BN
VariableNames = ["1","2","3","4","class"];
% VariableNames = ["1","2","3","4","5","6","7"];
figure;
draw_graph(BNhat.dag, VariableNames);
title('Estimated BN structure');

n_test_samples = size(test_data, 1);

engine = jtree_inf_engine(BNhat);

result = zeros(10, n_test_samples);

for i=1:n_test_samples
    evidence = cell(1, numb);
    evidence{A} = test_data(i, 1);
    evidence{B} = test_data(i, 2);
    evidence{C} = test_data(i, 3);
    evidence{D} = test_data(i, 4);
%     evidence{E} = test_data(i, 5);
%     evidence{F} = test_data(i, 6);

    [engine, loglik] = enter_evidence(engine, evidence);
    marg = marginal_nodes(engine,E);
    result(:, i) = marg.T;

end
[~, I] = max(result, [], 1);

figure
C = confusionmat(test_data(:, numb), I);
confusionchart(C)

accuracy = sum(diag(C))/sum(sum(C))
