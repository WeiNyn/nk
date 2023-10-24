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
    printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", "Feature", "Fill", "Count", "Type", "Mode", "MCount", "M%", "NUnique")
    for (c in counter) {
        if (is_boolean[c] == 1) { types[c] = "boolean"}
        if (counter[c]/(NR + 1) * 100.0 >= min_percentage) {
            if (types[c] != "string") { continue }

            summary_string(table[c])
            if (length(result_strings["mod"]) > 30) {
                mode[c] = substr(result_strings["mod"], 1, 25) "..."
            } else {
                mode[c] = result_strings["mod"]
            }

            mcount[c] = result_strings["max_occurences"]
            nunique[c] = result_strings["num_uniques"]

            printf("%s\t%.2f\t%d\t%s\t%s\t%d\t%.2f\t%d\n", c, counter[c]/(NR + 1) * 100.0, counter[c], types[c], result_strings["mod"], mcount[c], mcount[c]/counter[c] * 100.0, nunique[c])

            num_uniques = 0
            max_occurences = 0
            mod = ""
            delete result_strings
            delete uniques
        }
    }
}