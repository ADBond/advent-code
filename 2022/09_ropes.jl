module constants
export inputfilename, inputfilenametest
inputfilename = "2022/09ropes.input.txt"
inputfilenametest = "2022/09ropes_test.input.txt"
inputfilenametest2 = "2022/09ropes2_test.input.txt"
end

module v1
using ..constants
import Base.:+

function isadjacent(headcoords, tailcoords)
    if abs(headcoords[1] - tailcoords[1]) <= 1 &&
        abs(headcoords[2] - tailcoords[2]) <= 1
        return true
    end
    false
end

instructionlookup = Dict(
    "R" => (1, 0),
    "L" => (-1, 0),
    "U" => (0, -1),
    "D" => (0, 1)
)
function +(x::Tuple, y::Tuple)
    (x[1] + y[1], x[2] + y[2])
end
function newhead(headcoords, instructiondir)
    headcoords + instructionlookup[instructiondir]
end

function newcoords!(coords, instructiondir)
    oldhead = coords[1]
    coords[1] = newhead(coords[1], instructiondir)
    if isadjacent(coords[1], coords[2])
        return coords
    end
    coords[2] = oldhead
    coords[2]
end

function executeinstruction!(coords, instruction)
    instructionreg = r"([LRUD]) ([0-9]*)"
    (instructiondir, instructionsteps) = match(instructionreg, instruction).captures
    tails = Set()
    for i in 1:parse(Int8, instructionsteps)
        newcoords!(coords, instructiondir)
        push!(tails, coords[2])
    end
    tails
end

function executeinstructiontracking(filename)
    instructions = readlines(filename)
    coords = Dict(
        i => (0, 0) for i in (1, 2)
    )
    tails = Set([(0, 0)])
    for instruction in instructions
        tails = union(tails, executeinstruction!(coords, instruction))
    end
    length(tails)
end


println("Part 1:")
# should be 13
println(executeinstructiontracking(inputfilenametest))
println(executeinstructiontracking(inputfilename))

println("Part 2:")

end
