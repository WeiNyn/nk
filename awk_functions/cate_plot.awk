# include lib/string.awk

NR == 1 {
    for (i = 1; i <= NF; i++) {
        if ($i == col_name) {
            target_col = i;
            break;
        }
    }
}

NR > 1 {
    nums[co++] = $target_col;
}

END {
    summary_string(nums)
    histogram_string(limit)
}