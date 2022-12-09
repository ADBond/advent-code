module constants
export inputfilename, inputfilenametest, inputfilenametest2
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
# round away from zero
function roundout(x)
    x > 0 ? ceil(x) : floor(x)
end

# TODO: need to correct logic in this
function newcoords!(coords, instructiondir, numknots=2)
    coords[1] = newhead(coords[1], instructiondir)
    for i in 1:(numknots-1)
        # if i am adjacent to next knot then there is no more effect
        if isadjacent(coords[i], coords[i+1])
            return coords[numknots]
        end
        coords[i+1] += (
            roundout((coords[i][1] - coords[i+1][1])//2),
            roundout((coords[i][2] - coords[i+1][2])//2)
        )
    end
    coords[numknots]
end

function executeinstruction!(coords, instruction, numknots=2)
    instructionreg = r"([LRUD]) ([0-9]*)"
    (instructiondir, instructionsteps) = match(instructionreg, instruction).captures
    tails = Set()
    for i in 1:parse(Int8, instructionsteps)
        newcoords!(coords, instructiondir, numknots)
        push!(tails, coords[numknots])
    end
    tails
end

function executeinstructiontracking(filename, numknots=2)
    instructions = readlines(filename)
    coords = Dict(
        i => (0, 0) for i in 1:numknots
    )
    tails = Set([(0, 0)])
    for instruction in instructions
        tails = union(tails, executeinstruction!(coords, instruction, numknots))
    end
    length(tails)
end


println("Part 1:")
# should be 13
println(executeinstructiontracking(inputfilenametest))
println(executeinstructiontracking(inputfilename))

println("Part 2:")
# 36
println(executeinstructiontracking(inputfilenametest2, 10))
println(executeinstructiontracking(inputfilename, 10))

end
