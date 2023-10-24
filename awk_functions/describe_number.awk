# include lib/utils.awk
# include lib/number.awk
# include lib/boolean.awk
# include lib/string.awk

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
            if ($i != 1 && $i != 0 && is_boolean[r] == 1) {
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
                if (length(examples[r]) > 30) {
                        examples[r] = substr(examples[r], 1, 25) "..."
                }
            }

            table[r][counter[r]] = $i
        }
    }
}

END {
    
    printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\n", "Column", "Fill", "Q1", "Median", "Q3", "Mean", "Plot")
    
    for (c in counter) {
        if (counter[c]/(NR + 1) * 100.0 >= min_percentage) {
            if (types[c] != "number" && types[c] != "strnum" ) {
                continue
            }

            summary_num(table[c])

            printf("%s\t%d\t%s\t%s\t%s\t%s\t", c, counter[c]/NR * 100.0, result["q1"] + 0.0, result["median"] + 0.0, result["q3"] + 0.0, result["mean"] + 0.0)
            box_plot()

            printf("\n")

            delete result
            delete occurences
        }
    }
}