module constants
export inputfilename, inputfilenametest
inputfilename = "2022/06packets.input.txt"
inputfilenametest = "2022/06packets_test.input.txt"
end

module v1
using ..constants

function alluniquechars(substr)
    length(substr) == length(Set(substr))
end

function firstmarker(filename, buflength=4)
    buffer = readlines(filename)[1]
    for i in buflength:length(buffer)
        substring = buffer[(i - buflength + 1):i]
        if alluniquechars(substring)
            return i
        end
    end
    nothing
end



println("Part 1:")
# should be 7
println(firstmarker(inputfilenametest))
println(firstmarker(inputfilename))

println("Part 2:")
# now 19
println(firstmarker(inputfilenametest, 14))
println(firstmarker(inputfilename, 14))

end
