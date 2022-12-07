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
        # println(line)
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
            # println("push $line to it")
            push!(files, line)
        end
    end
    # println(currentpath)
    dirpath = fullpath(currentpath)
    # println("and then to $dirpath")
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

const totaldiskspace = 70000000
const spaceneeded = 30000000

# function spaceavailable(directorysizes)
#     totaldiskspace - directorysizes["//"]
# end

function clearspacesize(filename)
    directorycontains = getdirs(filename)
    sizes = getalldirectorysizes(directorycontains)
    currentspaceused = sizes["/"]
    sizes = Dict((k, sum(v)) for (k, v) in sizes)
    sizes = sort(sizes, byvalue=true)
    println(sizes)
    # println([v for (k, v) in sizes])
    println("have left, vs needed::")
    println((totaldiskspace - currentspaceused, spaceneeded))
    for (dir, size) in sizes
        freedspace = sum(size)
        wouldhavepspace = totaldiskspace - (currentspaceused - freedspace)
        print("would have ")
        println(wouldhavepspace)
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
