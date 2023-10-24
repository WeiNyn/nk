
{
    if (FILENAME == filter_file) {
        filter_values[$0] = 1
    }
}

FNR == 1 {
    if (FILENAME != filter_file) {
        print $0
        for (i = 1; i <= NF; i++) {
            if ($i == col_name) {
                target_col = i
            }
        }
    }
}

FNR > 1 {
    if (FILENAME == filter_file) {
        next
    }
    if ($target_col in filter_values) {
        print $0
    }
}
