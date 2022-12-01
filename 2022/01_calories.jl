module constants
export inputfilename
inputfilename = "2022/01calories.input.txt"
end

module v1
using ..constants
function getcaloriesperelf(filename)
    calories = readlines(filename)
    calorie_list = Int64[]
    current = 0
    for cal in calories
        if cal == ""
            push!(calorie_list, current)
            current = 0
        else
            current += parse(Int64, cal)
        end
    end
    calorie_list
    
end
function gettopelves(elfcalories, numelves=3)
    sort(caloriesperelf, rev=true)[1:numelves]
end

println("Approach 1")
println("Part 1:")

caloriesperelf = getcaloriesperelf(inputfilename)
maxcalories = maximum(caloriesperelf)

println(maxcalories)

# part 2
println("Part 2:")
topthree = gettopelves(caloriesperelf, 3)
topthreetotal = sum(topthree)

println(topthreetotal)

end

println()

# alternate approach, for practice
module v2
using ..constants
function getitemsperelf(filename)
    file = open(filename, "r")
    elfcalories = Array{Int64}[]
    currentelf = Int64[]
    while !eof(file)
        calories = readline(file)
        if calories == ""
            push!(elfcalories, currentelf)
            currentelf = Int64[]
        else
            currentcals = parse(Int64, calories)
            push!(currentelf, currentcals)
        end
    end
    close(file)
    elfcalories
end

println("Approach 2")

individualelfstashes = getitemsperelf(inputfilename)
totalsperelf = map(sum, individualelfstashes)

println("Part 1:")
println(maximum(totalsperelf))

println("Part 2:")
sort!(totalsperelf, rev=true)
println(sum(totalsperelf[1:3]))

end
