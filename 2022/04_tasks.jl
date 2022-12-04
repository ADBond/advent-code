module constants
export inputfilename, inputfilenametest
inputfilename = "2022/04tasks.input.txt"
inputfilenametest = "2022/04tasks_test.input.txt"
end

module v1
using ..constants

function gettaskpairs(filename)
    taskpairsstrings = readlines(filename)
    split.(taskpairsstrings, ",")
end
function parsetaskrange(taskrange)
    range = split(taskrange, "-")
    range = map(r -> parse(Int64, r), range)
    range[1]:range[2]
end
function gettasklists(taskpair)
    parsetaskrange.(taskpair)
end
function getalltasklist(filename)
    pairs = gettaskpairs(filename)
    gettasklists.(pairs)
end
function tasksoverlap(taskranges)
    if issubset(taskranges[1], taskranges[2])
        return true
    elseif issubset(taskranges[2], taskranges[1])
        return true
    end
    false
end
function numcover(filename)
    tasklists = getalltasklist(filename)
    covers = tasksoverlap.(tasklists)
    sum(covers)
end
# for part 2
function tasksintersect(taskranges)
    if length(intersect(taskranges[1], taskranges[2])) > 0
        return true
    end
    false
end
function numoverlaps(filename)
    tasklists = getalltasklist(filename)
    overlaps = tasksintersect.(tasklists)
    sum(overlaps)
end

println("Part 1:")
# should be 2
println(numcover(inputfilenametest))
println(numcover(inputfilename))

println("Part 2:")
# should be 4
println(numoverlaps(inputfilenametest))
println(numoverlaps(inputfilename))

end
