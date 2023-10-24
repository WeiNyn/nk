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
            }

            table[r][counter[r]] = $i
        }
    }
}

END {
    printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\n", "Column", "Fill", "Count", "TruePercent", "FalsePercent", "NullPercent", "Plot")
    
    for (c in counter) {
        if (counter[c]/(NR + 1) * 100.0 >= min_percentage) {
            if (is_boolean[c] == 1) { types[c] = "boolean"}
            if (!(types[c] == "boolean")) {
                continue
            }
            summary_boolean(table[c])
            
            printf("%s\t%d\t%d\t%d\t%d\t%d\t", c, counter[c]/(NR + 1) * 100.0, counter[c], values["true"]/counter[c] * 100.0, values["false"]/counter[c] * 100.0, values[""]/counter[c] * 100.0)
            boolean_plot()
            printf("\n")

            delete result_boolean
            delete values
        }
    }
}