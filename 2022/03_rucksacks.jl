module constants
export inputfilename, inputfilenametest
inputfilename = "2022/03rucksacks.input.txt"
inputfilenametest = "2022/03rucksacks_test.input.txt"
end

module v1
using ..constants

function getrucksackcompartments(filename)
    rucksacks = readlines(filename)
    allcompartments = Array{String}[]
    for rucksack in rucksacks
        totalitems = length(rucksack)
        if mod(totalitems, 2) != 0
            error("Unexpected odd-length input rucksack")
        end
        compartmentlength = totalitems ÷ 2
        compartments = [
            rucksack[1:compartmentlength],
            rucksack[(compartmentlength + 1):totalitems]
        ]
        push!(allcompartments, compartments)
    end
    allcompartments
end
function getuniquecompartmentitems(compartments)
    items = map(Array, compartments)
    unique.(compartments)
end
function getcompartmentintersection(compartmentitems)
    intersect(compartmentitems...)[1]
end
function letterpriority(letter)
    # not pretty, but will do
    asciival = Int8(letter)
    A_val = 65
    a_val = 97
    if (asciival < A_val) ||
        ((asciival > A_val + 25) && (asciival < a_val)) ||
        (asciival > a_val + 25)
        error("Non-letter found!")
    end
    if (asciival >= a_val)
        # lowercase from 1-26
        return asciival - a_val + 1
    end
    # uppercase 27-52
    asciival - A_val + 27
end
function gettotalpriority(filename, by="compartment")
    func = Dict(
        "compartment" => getrucksackcompartments,
        "group" => getgrouprucksacks,
    )[by]
    rucksackcompartments = func(filename)
    compartmentitems = map(r -> collect.(r), rucksackcompartments)
    shareditems = getcompartmentintersection.(compartmentitems)
    priorities = letterpriority.(shareditems)
    sum(priorities)
end
# swapped-out grouping function for part 2 - rest should work as-is
function getgrouprucksacks(filename)
    rucksacks = readlines(filename)
    grouprucksacks = String[]
    allrucksackgroups = Array{String}[]
    for rucksackindex in 1:length(rucksacks)
        indexmod = mod(rucksackindex, 3)
        if indexmod == 1
            grouprucksacks = String[]
        end
        push!(grouprucksacks, rucksacks[rucksackindex])
        if indexmod == 0
            push!(allrucksackgroups, grouprucksacks)
        end
    end
    allrucksackgroups
end
function gettotalgrouppriority(filename)
    gettotalpriority(filename, "group")
end

println("Part 1:")
# should be 157
println(gettotalpriority(inputfilenametest))
println(gettotalpriority(inputfilename))

println("Part 2:")
# expect 70
println(gettotalgrouppriority(inputfilenametest))
println(gettotalgrouppriority(inputfilename))

end
