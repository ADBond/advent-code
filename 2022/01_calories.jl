function getcaloriesperelf(filename)
    calories = readlines(filename)
    cal_list = []
    current = 0
    for cal in calories
        if cal == ""
            push!(cal_list, current)
            current = 0
        else
            current += parse(Int64, cal)
        end
    end
    cal_list
    
end
inputfilename = "2022/01calories.input.txt"

caloriesperelf = getcaloriesperelf(inputfilename)
maxcalories = maximum(caloriesperelf)

print(maxcalories)
