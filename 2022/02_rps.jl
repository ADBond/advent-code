module constants
export inputfilename, inputfilenametest
inputfilename = "2022/02rps.input.txt"
inputfilenametest = "2022/02rps_test.input.txt"
end

module v1
using ..constants

shape_score = Dict(
    "Rock" => 1,
    "Paper" => 2,
    "Scissors" => 3,
)
shape_reverse = Dict(val => shape for (shape, val) in shape_score)

shape_translate_elf = Dict(
    "A" => "Rock",
    "B" => "Paper",
    "C" => "Scissors",
)
resultmod = Dict(
    "lose" => 1,
    "draw" => 0,
    "win" => 2,  # = -1 mod 3
)
decrypt = Dict(
    "X" => resultmod["lose"],
    "Y" => resultmod["draw"],
    "Z" => resultmod["win"]
)

shape_translate_me = Dict(
    "X" => "Rock",
    "Y" => "Paper",
    "Z" => "Scissors",
)
function decryptshape(round)
    shape_translate_me[round[2]]
end
function decryptresult(round)
    desiredresult = decrypt[round[2]]
    elfshape = shape_translate_elf[round[1]]
    shapeindex = mod(shape_score[elfshape] - desiredresult, 3)
    shapeindex = shapeindex == 0 ? 3 : shapeindex
    shape_reverse[shapeindex]
end
function getshapes(round, shapestrategy)
    func = Dict("shape" => decryptshape, "result" => decryptresult)[shapestrategy]
    [shape_translate_elf[round[1]], func(round)]
end
function getwinscore(shapes)
    round_modulus = mod(shape_score[shapes[1]] - shape_score[shapes[2]], 3)
    if round_modulus == resultmod["lose"]
        return 0
    elseif round_modulus == resultmod["draw"]
        return 3
    elseif round_modulus == resultmod["win"]
        return 6
    else
        error("Something gone badly wrong here")
    end
end
function getshapescore(shape)
    shape_score[shape]
end
function scoresperround(shapes)
    [getwinscore(shapes), getshapescore(shapes[2])]
end
function getroundscore(round, shapestrategy="shape")
    round = split(round, " ")
    shapes = getshapes(round, shapestrategy)
    partscore = scoresperround(shapes)
    sum(partscore)
end
# unique values count in list
function nunique(list)
    uniquevals = unique(list)
    count = Dict(l => 0 for l in uniquevals)
    for l in list
        count[l] += 1
    end
    count
end
function gettotalscore(rounds, shapestrategy="shape")
    partscores = [count*getroundscore(round, shapestrategy) for (round, count) in nunique(rounds)]
    sum(partscores)
end

println("Part 1:")
testrounds = readlines(inputfilenametest)
# should be 15
println(gettotalscore(testrounds))

rounds = readlines(inputfilename)
println(gettotalscore(rounds))

println("Part 2:")
testrounds = readlines(inputfilenametest)
# should be 12
println(gettotalscore(testrounds, "result"))

rounds = readlines(inputfilename)
println(gettotalscore(rounds, "result"))

end
