
#include "lib/number.awk"
# @include "awk_functions/lib/utils.awk"

NR == 1 {
    for (i = 1; i <= NF; i++) {
        gsub("/^[\t]+", "", $i)
        gsub("/[\t]+$/", "", $i)
        if ($i == col_name) {
            target_col = i;
            break;
        }
    }
    if (!target_col) {
        printf("0\t0\t0\t%s is not found\n", col_name);
        exit;
    }
}

NR > 1 {
    value = $target_col;

    if (length(value) == 0) {
        value = "null"
    }

    values[value]++;

    if (values[value] == 1) {
        uniq_values++;
    }

}

END {
    if (uniq_values == 0) {
        printf("0\t0\t0\t%s column as no value\n", col_name);
        exit;
    }

    split("red green yellow blue magenta cyan white", colors, " ")

    print("Value\tCount\tPercent\tBar")
    for (v in values) {
        percent = int(values[v] / (NR - 1) * 100)

        if (percent <= minp) {
            continue;
        }
        
        u_index++
        color = colors[u_index % 7 + 1]

        printf("%s\t%d\t%d\t", v, values[v], percent)
        for (j = 0; j <= 100; j++) {
            if (j <= percent) {
                color_print("█", color)
            }
        }
        printf("\n")
    }

}