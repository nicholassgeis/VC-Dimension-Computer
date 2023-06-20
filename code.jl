#Utility Functions

function power_set(set)
    len = length(set)
    subsets = [[]]
    for i in 1:len
        for j in 1:length(subsets)
            push!(subsets, vcat(subsets[j], set[i]))
        end
    end
    return subsets
end

function condenser(list_of_list, largest)
    return [subset for subset in list_of_list if largest > length(subset) >= 2]
end

function rounder(a, b)
    if b/a < 0
        return Int64(ceil(b/a))
    else
        return Int64(floor(b/a))
    end
end

function minmax(diction)
    max_dict = Dict()
    for key in keys(diction)
        if diction[key][1] == 0
           max_dict[key] = 2^31
        else
           max_dict[key] = maximum([abs(diction[keyk][1]*rounder(diction[key][1], -diction[key][2])+diction[keyk][2]) for keyk in keys(diction)])
        end
    end
    
    if length(keys(max_dict)) == 0
       return 0 
    end
    
    j = -1
    small_value = 2^31
    for key in keys(max_dict)
        if max_dict[key] <= small_value
            j = key
        end
    end
    return j
end

function N_I_computer(subset, points)
    data_dict = Dict(i => (points[i][2] - points[subset[1]][2], points[i][3] - points[subset[1]][1]*(points[i][2] - points[subset[1]][2]) - points[subset[1]][3]) for i in subset[2:end])
    j = minmax(data_dict)
    
    if j == 0
        return [0,0,0,0]
    else
        #finds all the A values
        a_0 = rounder(data_dict[j][1], -data_dict[j][2])
        b_0 = Int64(floor(-(minimum([points[subset[1]][2] - points[i_k][2] for i_k in subset[2:end]]) - maximum([points[subset[1]][2] - points[i_k][2] for i_k in subset[2:end]]))/2))
        
        A_dict = Dict(subset[1] => a_0)
        B_dict = Dict(subset[1] => b_0)
        
        c_0 = Int64(floor(-(minimum([data_dict[i_k][1]*a_0 + data_dict[i_k][2] for i_k in subset[2:end]]) - maximum([data_dict[i_k][1]*a_0 + data_dict[i_k][2] for i_k in subset[2:end]]))/2))
        
        C_dict = Dict(subset[1] => c_0)
        
        for i_k in subset[2:end]
           A_dict[i_k] = a_0 + points[i_k][1] - points[subset[1]][1]
           B_dict[i_k] = b_0 + points[i_k][2] - points[subset[1]][2]
           C_dict[i_k] = c_0 + data_dict[i_k][1]*a_0 + data_dict[i_k][2] 
        end
            
        N_I = [points[subset[1]][1] - a_0, points[subset[1]][2] - b_0, points[subset[1]][3] - c_0 - (points[subset[1]][1] - a_0)*b_0]
            
        r_1 = maximum([abs(A_dict[key]) for key in keys(A_dict)])
        r_2 = maximum([abs(B_dict[key]) for key in keys(B_dict)])
        r_3 = maximum([abs(C_dict[key]) for key in keys(C_dict)])
            
        return [N_I, r_1, r_2, r_3, A_dict, B_dict, C_dict]
    end
end
