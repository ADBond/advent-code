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
            
            destinations = split(rawdetails[3], ", ")
            destinations = filter(x -> x != nothing, destinations)

            paths[rawdetails[1]] = destinations
        end
    end
    (flowrates, paths)
end

struct Info
    flowrates::Dict{String, Integer}
    paths::Dict{String, Array{String}}
end
# won't bother with any serious validation
struct Cave
    minutespast::Int8
    openvalves::Array{String}
    pressurereleased::Int64
    currentposition::String
    info::Info
end

function openvalve(cave::Cave)
    valve = cave.currentposition
    if valve in cave.openvalves
        error("Valve $valve already open")
    end
    Cave(
        cave.minutespast + 1,
        sort([cave.openvalves..., valve]),
        incrementpressure(cave),
        cave.currentposition,
        cave.info
    )
end

function moveto(cave::Cave, valve)
    # check if move is allowed
    if !(valve in cave.info.paths[cave.currentposition])
        error("invalid movement")
    end
    # execute move, tick
    Cave(
        cave.minutespast + 1,
        copy(cave.openvalves),
        incrementpressure(cave),
        valve,
        cave.info
    )
end

function getmoveoptions(cave::Cave)
    cave.info.paths[cave.currentposition]
end

function incrementpressure(cave::Cave)::Integer
    pressure = cave.pressurereleased
    for valve in cave.openvalves
        pressure += cave.info.flowrates[valve]
    end
    pressure
end

function getnewoptions(cave::Cave)
    options = [moveto(cave, valve) for valve in getmoveoptions(cave)]
    if !(cave.currentposition in cave.openvalves)
        # skip obviously suboptimal openings
        if cave.info.flowrates[cave.currentposition] > 0
            push!(options, openvalve(cave))
        end
    end
    options
end

function getnewoptions(caves::Array)
    [opt for cave in caves for opt in getnewoptions(cave)]
end

function id(cave::Cave)
    "$(join(cave.openvalves, '.'))__$(cave.currentposition)__$(cave.minutespast)"
end

function trimoptions(caves::Array)
    besties = Dict{String, Cave}()
    for cave in caves
        current_id = id(cave)
        bestofcurrent = get(besties, current_id, nothing)
        if (bestofcurrent == nothing) || (cave.pressurereleased > bestofcurrent.pressurereleased)
            besties[current_id] = cave
        end
    end
    [v for v in values(besties)]
end

function calculatepressures(filename)
    maxmins = 30
    flowrates, paths = getvalvedetails(filename)
    initialcave = Cave(0, [], 0, "AA", Info(flowrates, paths))
    caveoptions = [initialcave]
    currenttick = 0
    while currenttick < maxmins
        caveoptions = getnewoptions(caveoptions)
        caveoptions = trimoptions(caveoptions)
        currenttick = caveoptions[1].minutespast
        # println("Had $currenttick minutes past and have $(length(caveoptions)) options")
    end
    maximum(cave.pressurereleased for cave in caveoptions)
end

# 30 mins

println("Part 1:")
# max pressure 1651
println(getvalvedetails(inputfilenametest))
println(calculatepressures(inputfilenametest))
println(calculatepressures(inputfilename))

end
