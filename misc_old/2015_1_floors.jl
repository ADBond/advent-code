instructiontranslation = Dict(
    '(' => +1,
    ')' => -1,
)
function floorfromfile(filename)
    file = open(filename, "r")
    floor = 0
    while !eof(file)
        instruction = read(file, Char)
        floor += instructiontranslation[instruction]
    end
    close(file)
    floor
end

inputfilename = "misc_old/2015_1.input.txt"

floor = floorfromfile(inputfilename)
println(floor)

# part 2
function firstbasement(filename)
    file = open(filename, "r")
    floor = 0
    position = 0
    while !eof(file)
        instruction = read(file, Char)
        floor += instructiontranslation[instruction]
        position += 1
        if floor < 0
            break
        end
    end
    close(file)
    position
end
position = firstbasement(inputfilename)
println(position)
