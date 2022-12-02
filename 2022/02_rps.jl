module constants
export inputfilename
inputfilename = "2022/02rps.input.txt"
inputfilenametest = "2022/02rps_test.input.txt"
end

module v1
using ..constants

shape_translate_me = Dict(
    "X" => "Rock",
    "Y" => "Paper",
    "Z" => "Scissors",
)
shape_translate_elf = Dict(
    "A" => "Rock",
    "B" => "Paper",
    "C" => "Scissors",
)
shape_score = Dict(
    "Rock" => 1,
    "Paper" => 2,
    "Scissors" => 3,
)
shape_reverse = Dict(val => shape for (shape, val) in shape_score)
decrypt = Dict(
    # lose
    "X" => 1,
    # draw
    "Y" => 0,
    # win
    "Z" => 2
)

function directguess(round)
    shape_translate_me[round[2]]
end
function resultguess(round)
    desiredresult = decrypt[round[2]]
    elfshape = shape_translate_elf[round[1]]
    shapeindex = mod(shape_score[elfshape] - desiredresult, 3)
    shapeindex = shapeindex == 0 ? 3 : shapeindex
    shape_reverse[shapeindex]
end
function getshapes(round, shapestrategy)
    func = Dict("shape" => directguess, "rev" => resultguess)[shapestrategy]
    [shape_translate_elf[round[1]], func(round)]
end
function getwinscore(shapes)
    round_modulus = mod(shape_score[shapes[1]] - shape_score[shapes[2]], 3)
    if round_modulus == 1
        return 0
    elseif round_modulus == 0
        return 3
    else
        return 6
    end
end
function getshapescore(shape)
    shape_score[shape]
end
function scoresperround(shapes)
    [getwinscore(shapes), getshapescore(shapes[2])]
end
function nunique(list)
    uniquevals = unique(list)
    count = Dict(l => 0 for l in uniquevals)
    for l in list
        count[l] += 1
    end
    count
end
function getroundscore(round, shapestrategy="shape")
    round = split(round, " ")
    shapes = getshapes(round, shapestrategy)
    partscore = scoresperround(shapes)
    sum(partscore)
end

println("Part 1:")
rounds = readlines(inputfilename)

partscores = [count*getroundscore(round) for (round, count) in nunique(rounds)]
println(sum(partscores))

println("Part 2:")
partscores = [count*getroundscore(round, "rev") for (round, count) in nunique(rounds)]
println(sum(partscores))

end
