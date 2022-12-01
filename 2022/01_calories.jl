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
function gettopelves(elfcalories, numelves=3)
    sort(caloriesperelf, rev=true)[1:numelves]
end

inputfilename = "2022/01calories.input.txt"

caloriesperelf = getcaloriesperelf(inputfilename)
maxcalories = maximum(caloriesperelf)

println(maxcalories)

# part 2
topthree = gettopelves(caloriesperelf, 3)
topthreetotal = sum(topthree)

println(topthreetotal)
