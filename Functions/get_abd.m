function abd = get_abd(ABD)
    
    A = ABD(1:3,1:3);
    B = ABD(1:3,4:6);
    D = ABD(4:6,4:6);
    
    Bst = -inv(A) * B;
    Cst = B * inv(A);
    Dst = D - B * inv(A) * B;

    a = inv(A) - Bst * inv(Dst) * Cst;
    b = Bst * inv(Dst);
    c = -inv(Dst) * Cst;
    d = inv(Dst);
    
    abd = [a b
           c d];

end