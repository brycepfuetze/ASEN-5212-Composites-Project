function [E_ratio] = get_E_ratio(Ex, Ey)
    
    if Ex > Ey
        E_ratio = Ex/Ey;
    else
        E_ratio = Ey/Ex;
    end

end