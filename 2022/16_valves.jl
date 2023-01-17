module constants
export inputfilename, inputfilenametest
inputfilename = "2022/16valves.input.txt"
inputfilenametest = "2022/16valves_test.input.txt"
end

module v1
using ..constants

regex_inputline = r"Valve ([A-Z]{2}) has flow rate=(\d+); tunnels? leads? to valves? ([A-Z]{2}+(?:,\s*[A-Z]{2})*)"

function getvalvedetails(filename)
    lines = readlines(filename)
    flowrates = Dict{String, Int64}()
    paths = Dict{String, Array{String}}()
    for line in lines
        if line != ""
            rawdetails = match(regex_inputline, line).captures
            flowrates[rawdetails[1]] = parse(Int64, rawdetails[2])
            
            destinations = split(rawdetails[3], ",")
            destinations = filter(x -> x != nothing, destinations)

            paths[rawdetails[1]] = destinations
        end
    end
    (flowrates, paths)
end

# 30 mins

println("Part 1:")
# max pressure 1651
println(getvalvedetails(inputfilenametest))

end
