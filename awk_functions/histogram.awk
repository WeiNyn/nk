
#include "lib/number.awk"

NR == 1 {
    for (i = 1; i <= NF; i++) {
        if ($i == col_name) {
            target_col = i;
            break;
        }
    }
}

NR > 1 {
    if (typeof($target_col) == "number" || typeof($target_col) == "strnum") {
        
        nums[co++] = $target_col;
    }
}

END {
    summary_num(nums)
    histogram(num_bins)
}