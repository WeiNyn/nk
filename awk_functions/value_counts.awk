
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
        value = "null";
    }

    vals[value]++;
}

END {
    if (length(vals) == 0) {
        exit;
    }

    printf("Value\tCount\tPercent\n")
    for (v in vals) {
        printf("%s\t%d\t%f\n", v, vals[v], vals[v] / (NR - 1) * 100);
    }
}