module constants
export inputfilename, inputfilenametest
inputfilename = "2022/08trees.input.txt"
inputfilenametest = "2022/08trees_test.input.txt"
end

module v1
using ..constants

function getgrid(filename)
    treesin = readlines(filename)
    rows = length(treesin[1])
    cols = length(treesin)
    trees = zeros(Int8, rows, cols)
    for row in 1:rows
        for col in 1:cols
            trees[row, col] = parse(Int8, treesin[row][col])
        end
    end
    trees
end

function clearindirection(trees, row, col, dir)
    (rows, cols) = size(trees)
    currenttree = trees[row, col]
    range = Dict(
        "left" => (row - 1):-1:1,
        "right" => (row + 1):1:rows,
        "up" => (col - 1):-1:1,
        "down" => (col + 1):1:cols,
    )
    if dir in ("left", "right")
        for r in range[dir]
            treeinway = trees[r, col]
            if treeinway >= currenttree
                return false
            end
        end
    else
        for c in range[dir]
            treeinway = trees[row, c]
            if treeinway >= currenttree
                return false
            end
        end
    end
    true
end
# sorry :(
function treesindirection(trees, row, col, dir)
    (rows, cols) = size(trees)
    currenttree = trees[row, col]
    range = Dict(
        "left" => (row - 1):-1:1,
        "right" => (row + 1):1:rows,
        "up" => (col - 1):-1:1,
        "down" => (col + 1):1:cols,
    )
    treecount = 0
    if dir in ("left", "right")
        for r in range[dir]
            treeinway = trees[r, col]
            treecount += 1
            if treeinway >= currenttree
                return treecount
            end
        end
    else
        for c in range[dir]
            treeinway = trees[row, c]
            treecount += 1
            if treeinway >= currenttree
                return treecount
            end
        end
    end
    treecount
end

function isvisible(trees, row, col)
    (rows, cols) = size(trees)
    isedge = (row == 1 || row == rows || col == 1 || col == cols)
    if isedge
        return true
    end
    # let's just try all directions in unclever order
    if clearindirection(trees, row, col, "left") ||
        clearindirection(trees, row, col, "right") ||
        clearindirection(trees, row, col, "up") ||
        clearindirection(trees, row, col, "down")
        return true
    end
    false
end

function checktrees(trees)
    (rows, cols) = size(trees)
    treesvis = 0
    for row in 1:rows
        for col in 1:cols
            if isvisible(trees, row, col)
                treesvis += 1

            end
        end
    end
    treesvis
end
function treecount(filename)
    trees = getgrid(filename)
    checktrees(trees)
end

function gettreescore(trees, row, col)
    treesindirection(trees, row, col, "left") *
    treesindirection(trees, row, col, "right") *
    treesindirection(trees, row, col, "up") *
    treesindirection(trees, row, col, "down")
end
function maxscore(trees)
    (rows, cols) = size(trees)
    maxseen = 0
    for row in 1:rows
        for col in 1:cols
            score = gettreescore(trees, row, col)
            maxseen = max(maxseen, score)
        end
    end
    maxseen
end
function maxtreescore(filename)
    trees = getgrid(filename)
    maxscore(trees)
end


println("Part 1:")
# should be 21
println(treecount(inputfilenametest))
println(treecount(inputfilename))

println("Part 2:")
# should be 8
println(maxtreescore(inputfilenametest))
println(maxtreescore(inputfilename))

end
