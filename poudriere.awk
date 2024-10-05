#!/usr/bin/awk -f

function dfs(node, depth, has_siblings,    num_children,children,ci,c) {
    for (i = 0; i < depth; ++i) {
        printf("│   ")
    }

    if (has_siblings) {
        prefix = "└"
    } else {
        prefix = "├"
    }

    printf("%s── %s\n", prefix, node)

    if (!discovered[node]) {
        discovered[node] = 1
        num_children = split(graph[node], children, "|")
        # Minus 1 due to extraneous "|" character
        delete children[num_children]

        for (ci in children) {
            c = children[ci]
            dfs(c, depth + 1, num_children <= 2)
        }
    }
}

/.* -> .*;/ {
    gsub("\"", "", $1)
    split($1, arr, ":")
    left = sprintf("%s (%s)", arr[2], arr[1])
    lefts[left] = 1

    gsub("[\";]", "", $3)
    split($3, arr, ":")
    right = sprintf("%s (%s)", arr[2], arr[1])
    ++numrights[left]
    graph[left] = graph[left] right "|"

#    printf("%s\t%s\n", $1, $3)
}


END {
    for (l in lefts) {
        for (d in discovered) {
            delete discovered[d]
        }
        #print l, " -> ", graph[l]
        dfs(l, 0, 1)
    }
}
