function abd = get_abd(ABD)
    % get_abd - Computes the inverse ABD matrix for a laminate
    %
    % Inputs:
    %   ABD - 6x6 stiffness matrix of the laminate
    %
    % Outputs:
    %   abd - 6x6 compliance matrix of the laminate
    %
    % Dependencies:
    %   None

    % Extract sub-matrices
    A = ABD(1:3,1:3);
    B = ABD(1:3,4:6);
    D = ABD(4:6,4:6);

    % compute star matrices
    Bst = -inv(A) * B;
    Cst = B * inv(A);
    Dst = D - B * inv(A) * B;

    % compute sub-matrix inverses
    a = inv(A) - Bst * inv(Dst) * Cst;
    b = Bst * inv(Dst);
    c = -inv(Dst) * Cst;
    d = inv(Dst);

    % assemble sub-matrices
    abd = [a b
           c d];

end
