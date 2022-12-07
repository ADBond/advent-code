module constants
export inputfilename, inputfilenametest
inputfilename = "infull.txt"
inputfilenametest = "intest.txt"
end

module v1
using ..constants

dirreg = r"dir ([A-Za-z]*)"
fulldirreg = r"dir ([A-Za-z/]*)"
function fullpath(currentpath)
  join(currentpath, "/")
end

function replacedirwithfullpath(currentpath, dirline)
  currentdir = getdir(dirline)
  path = fullpath([currentpath..., currentdir])
  "dir $path"
end

function getdir(entry)
    match(fulldirreg, entry).captures[1]
end

function getdirs(filename)
    alllines = readlines(filename)
    indirectory = nothing
    cdreg = r"^\$\scd ([A-Za-z/\.]*)"
    lsreg = r"^\$\sls"
    sizereg = r"^(\d*) [a-zA-Z\.]*"
    files = String[]
    directorycontains = Dict()
    currentpath = String[]
  # hack for global
    dirpath = ""
    for line in alllines
        println(line)
        if occursin(cdreg, line)
            dirpath = fullpath(currentpath)
            if !(dirpath in [nothing, ""]) && length(files) > 0
                if haskey(directorycontains, dirpath)
                    println(directorycontains)
                    println(dirpath)
                    println(files)
                    error("too naive")
                end
                directorycontains[dirpath] = files
            end
            indirectory = match(cdreg, line).captures[1]
            if indirectory == ".."
                pop!(currentpath)
                # println(currentpath)
            else
                push!(currentpath, indirectory)
                # println(currentpath)
            end
            files = String[]
            # println("In $indirectory")
        elseif occursin(lsreg, line)
            # println("Now list in $indirectory")
            files = String[]
        else
            # println("\tpushing files to $indirectory")
            if occursin(sizereg, line)
                line = match(sizereg, line).captures[1]
            else
                line = replacedirwithfullpath(currentpath, line)
            end
            push!(files, line)
        end
    end
    directorycontains[dirpath] = files
    directorycontains
end

function getdirectorysize(directorycontains, dir)
    sizes = Dict()
    # println(dir)
    # println(directorycontains)
    entries = directorycontains[dir]
    currentsize = 0
    for entry in entries
        # println("checking")
        # println(entry)
        if occursin(dirreg, entry)
            # println("directory $entry")
            currentsize += getdirectorysize(directorycontains, getdir(entry))
        else
            currentsize += parse(Int64, entry)
        end
    end
    currentsize
end
# not the most efficient way - lots of recomputing, but hey-ho
function getalldirectorysizes(directorycontains)
    sizes = Dict()
    for (dir, entries) in directorycontains
        sizes[dir] = getdirectorysize(directorycontains, dir)
    end
    sizes
end
function getdirectoriesupto(filename, upto)
    directorycontains = getdirs(filename)
    sizes = getalldirectorysizes(directorycontains)
    # println(sizes)
    filteredsizes = filter(((k, v),) -> v < upto, sizes)
    # just the sizes
    [v for (k, v) in filteredsizes]
end

println("Part 1:")
# should be 95437
println(getdirs(inputfilenametest))
println(sum(getdirectoriesupto(inputfilenametest, 100000)))
println(sum(getdirectoriesupto(inputfilename, 100000)))

println("Part 2:")

end
