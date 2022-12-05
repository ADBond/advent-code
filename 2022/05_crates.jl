module constants
export inputfilename, inputfilenametest
inputfilename = "2022/05crates.input.txt"
inputfilenametest = "2022/05crates_test.input.txt"
end

module v1
using ..constants

const instructionregex = r"move ([0-9]*) from ([0-9]*) to ([0-9]*)"
const crateregex = r"\[([A-Z])\]"

function splitinput(filename)
    inputlines = readlines(filename)
    inputlines = reverse(inputlines)
    cratelines = String[]
    instructionlines = String[]
    instructions = true
    for line in inputlines
        if line == ""
            instructions = false
        end
        if instructions
            push!(instructionlines, line)
        elseif line != ""
            push!(cratelines, line)
        end
    end
    Dict(
        "instructions" => reverse(instructionlines),
        "crates" => cratelines
    )
end

function getlevelcrates(level, numcrates)
    crates = String[]
    for i in 1:numcrates
        start = (i - 1)*4 + 1
        crate = level[start:(start+2)]
        if occursin(crateregex, crate)
            regex = match(crateregex, crate)
            push!(crates, regex.captures[1])
        else
            push!(crates, "")
        end
    end
    crates
end

function getcratecolumns(cratelines)
    colnumbers = parse.(Int64,
        filter(x -> x != "", split(cratelines[1], r"\W"))
    )
    maxcolumn = maximum(colnumbers)
    if Set(colnumbers) != Set(1:maxcolumn)
        println(colnumbers)
        println(maxcolumn)
        error("Unexpected column numbers - parsing error")
    end

    columnsfrombottom = map(x -> [], colnumbers)
    for line in cratelines[2:end]
        levelcrates = getlevelcrates(line, maxcolumn)
        for col in colnumbers
            currentcrate = levelcrates[col]
            if currentcrate != ""
                push!(columnsfrombottom[col], currentcrate)
            end
        end
    end
    columnsfrombottom
end
function executeinstruction!(crates, instruction, model="9000")
    (numtomove, fromcol, tocol) = 
        parse.(Int64, match(instructionregex, instruction).captures
    )
 
    cratestomove = String[]
    for i in 1:numtomove
        crate = pop!(crates[fromcol])
        push!(cratestomove, crate)
    end
    if model == "9001"
        cratestomove = reverse(cratestomove)
    end
    crates[tocol] = vcat(crates[tocol], cratestomove)
    crates
end
function executeallinstructions!(crates, instructions, model="9000")
    for instruction in instructions
        executeinstruction!(crates, instruction, model)
    end
    crates
end
function gettopcrates(crates)
    top = ""
    for col in crates
        top *= col[end]
    end
    top
end
function topcratesfrominput(filename, model="9000")
    input = splitinput(filename)
    crates = getcratecolumns(input["crates"])
    executeallinstructions!(crates, input["instructions"], model)
    gettopcrates(crates)
end


println("Part 1:")
# should be CMZ
println(topcratesfrominput(inputfilenametest))
println(topcratesfrominput(inputfilename))

println("Part 2:")
# MCD
println(topcratesfrominput(inputfilenametest, "9001"))
println(topcratesfrominput(inputfilename, "9001"))

end
