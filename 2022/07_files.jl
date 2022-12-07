module constants
export inputfilename, inputfilenametest
inputfilename = "2022/07files.input.txt"
inputfilenametest = "2022/07files_test.input.txt"
end

module v1
using Pkg
Pkg.activate(".")
using ..constants
# for sorting dicts
using OrderedCollections

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
            else
                push!(currentpath, indirectory)
            end
            files = String[]
        elseif occursin(lsreg, line)
            files = String[]
        else
            if occursin(sizereg, line)
                line = match(sizereg, line).captures[1]
            else
                line = replacedirwithfullpath(currentpath, line)
            end
            push!(files, line)
        end
    end
    dirpath = fullpath(currentpath)
    directorycontains[dirpath] = files
    directorycontains
end

function getdirectorysize(directorycontains, dir)
    sizes = Dict()
    entries = directorycontains[dir]
    currentsize = 0
    for entry in entries
        if occursin(dirreg, entry)
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
    filteredsizes = filter(((k, v),) -> v < upto, sizes)
    # just the sizes
    [v for (k, v) in filteredsizes]
end

function deletedir!(directorycontains, dir)
    dirls = directorycontains[dir]
    for subdir in dirls
        if match(fulldirreg, subdir)
            deletedir!(directorycontains, subdir)
        end
    end
    # delete!(directorycontains, dir)
    # don't actually delete - need ref! just takes no space
    directorycontains[dir] = 0
    directorycontains
end

const totaldiskspace = 70000000const spaceneeded = 30000000


function clearspacesize(filename)
    directorycontains = getdirs(filename)
    sizes = getalldirectorysizes(directorycontains)
    currentspaceused = sizes["/"]
    sizes = Dict((k, sum(v)) for (k, v) in sizes)
    sizes = sort(sizes, byvalue=true)
    for (dir, size) in sizes
        freedspace = sum(size)
        wouldhavepspace = totaldiskspace - (currentspaceused - freedspace)
        if wouldhavepspace >= spaceneeded
            # delete this folder!
            return freedspace
        end
    end
    nothing
end

println("Part 1:")
# should be 95437
println(getdirs(inputfilenametest))
println(sum(getdirectoriesupto(inputfilenametest, 100000)))
println(sum(getdirectoriesupto(inputfilename, 100000)))

println("Part 2:")
# 24933642
println(clearspacesize(inputfilenametest))
println(clearspacesize(inputfilename))

end
