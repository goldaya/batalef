function alpha = ang(u,v)
%ANG compute the angle between two vectors, in radians

    alpha = acos(dot(u,v)/(norm(u)*norm(v)));

end