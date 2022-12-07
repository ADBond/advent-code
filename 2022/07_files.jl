module constants
export inputfilename, inputfilenametest
inputfilename = "2022/07files.input.txt"
inputfilenametest = "2022/07files_test.input.txt"
end

module v1
using ..constants

function getdirs(filename)
    alllines = readlines(filename)
    indirectory = nothing
    cdreg = r"^\$\scd ([A-Za-z/]*)"
    lsreg = r"^\$\sls"
    sizereg = r"^(\d*) [a-zA-Z\.]*"
    files = String[]
    directorycontains = Dict()
    for line in alllines
        println(line)
        if occursin(cdreg, line)
            if indirectory != nothing
                directorycontains[indirectory] = files
            end
            indirectory = match(cdreg, line).captures[1]
            println("In $indirectory")
        elseif occursin(lsreg, line)
            println("Now list in $indirectory")
            files = String[]
        else
            println("\tpushing files to $indirectory")
            # TODO get file size
            if occursin(sizereg, line)
                line = match(sizereg, line).captures[1]
            end
            push!(files, line)
        end
    end
    # directorycontains[indirectory] = files
    directorycontains
end

function getdirectorysizes(directorycontains)
    dirreg = r"dir ([A-Za-z]*)"
    sizes = Dict()
    # for dir, entries in directorycontains
    #     currentsize = 
    #     for entry in entries
    #         if occursin(dirreg, )
end

println("Part 1:")
# should be 95437
println(getdirs(inputfilenametest))
println(sum(getdirectoriesupto(inputfilenametest, 100000)))
println(sum(getdirectoriesupto(inputfilename, 100000)))

println("Part 2:")

end
