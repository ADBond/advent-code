module constants
export inputfilename, inputfilenametest
inputfilename = "2022/10cpu.input.txt"
inputfilenametest = "2022/10cpu_test.input.txt"
end

module v1
using ..constants

function executeinstructions(filename)
    inputs = readlines(filename)
    xvalues = Int8[1]
    i = 1
    currentx = 1
    for input in inputs
        if input == "noop"
            push!(xvalues, currentx)
        else
            # println(input)
            valuetoadd = match(r"addx (\-?[0-9]*)", input).captures[1]
            push!(xvalues, currentx)
            currentx += parse(Int8, valuetoadd)
            push!(xvalues, currentx)
        end
    end
    xvalues
end

const keyindices = [20, 60, 100, 140, 180, 220]

function keyvalues(xvalues)
    xvalues[keyindices]
end

function sumsignalstrengths(filename)
    xvalues = executeinstructions(filename)
    kv = keyvalues(xvalues)
    sum([k*i for (k, i) in zip(kv, keyindices)])
end

println("Part 1:")
# should be 13140
println(sumsignalstrengths(inputfilenametest))
println(sumsignalstrengths(inputfilename))


println("Part 2:")

end
