
% required routing matrix R\A

[n1, m] = size(A1);
[n2, m] = size(A2);

% Hyperparameters of AT
congestedlevel = 0.1;
lambda = 100; tot = 30;
bad_link_value = 10; mu =2;      % Keep consistent with `gendata_fxb`.
bad_link_th = (bad_link_value+mu)/2;                   % Threshold

total_iters = 100;
[err_l1,err_SAT,err_SAT_SBT,DR_l1,FR_l1,DR_SAT,FR_SAT,DR_SAT_SBT,FR_SAT_SBT] = deal(zeros(total_iters, tot)); 
% Hyperparameters of BT
lambda_SBT = 100; 
th = bad_link_value-1;  
[DR_TOMO,FR_TOMO,DR_SBT,FR_SBT,DR_Face, FR_Face] = deal(zeros(total_iters, tot)); 
for ct = 1: total_iters  
% gen data
gendata_fxb;
x_l1 = zeros(m, tot); x_SAT_SBT = zeros(m, tot);
x_bad_TOMO = false(m, tot); x_bad_SBT = false(m, tot); x_bad_Face = zeros(m, tot);

for t = 1:tot
    if t==1     %  precise estimation at the initial moment.
         x_bad = (x(:,t)>th);
         y_bad = (A1*x_bad)>0;
        x_bad_TOMO(:,t) = (logical(TOMO(A1, y_bad)))';
        x_bad_SBT(:,t) = x_bad_TOMO(:,t);
        [x_l1(:,t), ~] = WCS_LP(y(:,t),A1,ones(m, 1)); x_SAT_SBT(:,t) = x_l1(:,t);
    else
        x_bad = (x(:,t)>th);
        y_bad = (A2*x_bad)>0;
        x_bad_TOMO(:,t) = (logical(TOMO(A2, y_bad)))';           % TOMO
        x_bad_SBT(:,t) = (logical(SBT(A2, y_bad, x_bad_SBT(:,t-1), lambda_SBT)))';  % SBT
        x_bad_Face(:,t) = FaCe(A2, double(y_bad),0.1,0.01);
        [x_l1(:,t), ~] = WCS_LP(y(1:n2,t),A2,ones(m, 1));
        % Leverage SBT to implement SAT, that is, use the support set obtained from SBT to solve.
        R_T = A2(:,x_bad_SBT(:,t));
        tmp = zeros(m,1); tmp(x_bad_SBT(:,t)) = R_T \ y(1:n2,t);
        support_t = 1:m; x_SAT_SBT(:,t) = SAT_cvx(y(1:n2,t), A2, 0.001, 10, support_t(x_bad_SBT(:,t)),tmp);
    end
    % results of boolean
    DR_TOMO(ct, t) = sum((x_bad_TOMO(:,t) & x_bad))/sum(x_bad);
    FR_TOMO(ct, t) = sum(x_bad_TOMO(:,t)-x_bad==1)/sum(x_bad_TOMO(:,t));
    DR_SBT(ct, t) = sum((x_bad_SBT(:,t) & x_bad))/sum(x_bad);
    FR_SBT(ct, t) = sum(x_bad_SBT(:,t)-x_bad==1)/sum(x_bad_SBT(:,t));
    DR_Face(ct, t) = sum(((x_bad_Face(:,t)>0) & x_bad))/sum(x_bad);
    FR_Face(ct, t) = sum((x_bad_Face(:,t)>0)-x_bad==1)/sum((x_bad_Face(:,t)>0));
        
    % results of analog
    err_l1(ct,t) = norm( x(:,t)-x_l1(:,t) ,1)/norm( x(:,t) ,1);
    DR_l1(ct,t) = sum(((x_l1(:,t)>bad_link_th)&(x(:,t)==bad_link_value)))/sum(x(:,t)==bad_link_value);
    FR_l1(ct,t) =  sum((x_l1(:,t)>bad_link_th)-(x(:,t)==bad_link_value)==1)/sum(x_l1(:,t)>bad_link_th);

    err_SAT_SBT(ct,t) = norm( x(:,t)-x_SAT_SBT(:,t) ,1)/norm( x(:,t) ,1);
    DR_SAT_SBT(ct,t) = sum(((x_SAT_SBT(:,t)>bad_link_th)&(x(:,t)==bad_link_value)))/sum(x(:,t)==bad_link_value);
    FR_SAT_SBT(ct,t) =  sum((x_SAT_SBT(:,t)>bad_link_th)-(x(:,t)==bad_link_value)==1)/sum(x_SAT_SBT(:,t)>bad_link_th);
end
end

% DR_TOMO_mean = mean(DR_TOMO); FR_TOMO_mean = mean(FR_TOMO);
% DR_SBT_mean = mean(DR_SBT); FR_SBT_mean= mean(FR_SBT);
% DR_Face_mean = mean(DR_Face); FR_Face_mean= mean(FR_Face);
% 
% err_l1_mean = mean(err_l1);err_SAT_SBT_mean = mean(err_SAT_SBT);
% DR_l1_mean = mean(DR_l1);DR_SAT_SBT_mean = mean(DR_SAT_SBT);
% FR_l1_mean = mean(FR_l1);FR_SAT_SBT_mean = mean(FR_SAT_SBT);
% save('result/LDT_d_1.mat',  'err_l1_mean', 'err_SAT_SBT_mean', 'DR_l1_mean'...
%      ,'DR_SAT_SBT_mean', 'FR_l1_mean', 'FR_SAT_SBT_mean');
% 
% figure;plot(DR_SBT_mean,'r');hold on;plot(DR_TOMO_mean);hold on;plot(DR_Face_mean,'y');
% figure;plot(FR_SBT_mean,'r');hold on;plot(FR_TOMO_mean);hold on;plot(FR_Face_mean,'y');
% figure;plot(err_l1_mean);hold on;plot(err_SAT_SBT_mean,'g');
% figure;plot(DR_l1_mean);hold on;plot(DR_SAT_SBT_mean,'g');
% figure;plot(FR_l1_mean);hold on;plot(FR_SAT_SBT_mean,'g');

