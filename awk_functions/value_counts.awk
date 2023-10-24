
NR == 1 {
    for (i = 1; i <= NF; i++) {
        if ($i == col_name) {
            target_col = i;
            break;
        }
    }
}

NR > 1 {
    vals[$target_col]++;
}

END {
    printf("Value\tCount\n")
    for (v in vals) {
        printf("%s\t%d\n", v, vals[v]);
    }
}