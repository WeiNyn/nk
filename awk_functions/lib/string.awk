
# include lib/utils.awk

func summary_string(strings,    counter,    num_uniques,    max_occurences,    mod,    s) {
    for (s in strings) {
        uniques[strings[s]]++
        if (uniques[strings[s]] == 1) {
            num_uniques++
        }
        if (uniques[strings[s]] > max_occurences) {
            max_occurences = uniques[strings[s]]
            mod = strings[s]
        }
        counter++
    }

    result_strings["counter"] = counter
    result_strings["num_uniques"] = num_uniques
    result_strings["max_occurences"] = max_occurences
    result_strings["mod"] = mod
}

func histogram_string(limit,    colors,   u,    u_index,    percent,    color,    display,    i) {

    split("red green yellow blue magenta cyan white", colors, " ")

    for (u in uniques) {
        percent = uniques[u] / result_strings["counter"] * 100.0
        u_index++
        color = colors[u_index % 7 + 1]
        if (percent > limit) {
            display = substr(u, 1, 30)
            printf("%s\t", display, percent)
            for (i = 0; i <= 50; i++) {
                if (i <= percent) {
                    color_print("█", color)
                }
            }
            printf("\t%f\n", percent)
        }
    }
}