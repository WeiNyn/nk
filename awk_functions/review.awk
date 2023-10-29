

NR == 1 {
    for (i = 1; i <= NF; i++) {
            header[i] = $i
            is_boolean[$i] = 1
    }
}

NR > 1 {
    for (i = 1; i <= NF; i++) {
        if (length($i) > 0) {
            r = header[i] 
            counter[r] += 1
            if ($i != 1 && $i != 0) {
                is_boolean[r] = 0
            }
            if (!(r in types)) {
                types[r] = typeof($i)
                if (types[r] == "string") {
                        if (substr($i, 1, 1) == "[" && substr($i, length($i), length($i)) == "]") {
                                types[r] = "list"
                        } else if (substr($i, 1, 1) == "{" && substr($i, length($i), length($i)) == "}") {
                                types[r] = "dict"
                        } else if ($i == "true" || $i == "false") {
                                types[r] = "boolean"
                        }
                }
                examples[r] = $i
            }
        }
    }
}


END {
    printf("Column\tPercent\tType\tExample\n")
    for (c in counter) {
        printf("%s\t%d\t%s\t%s\n", c, counter[c]/(NR - 1) * 100.0, types[c], examples[c])
    }
}