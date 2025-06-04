function [F1, prec, rec] = calculateF1(pred, true)
    TP = sum(pred & true);
    FP = sum(pred & ~true);
    FN = sum(~pred & true);
    prec = TP / (TP + FP + eps); 
    rec = TP / (TP + FN + eps);
    F1 = 2 * (prec * rec) / (prec + rec + eps);
end
