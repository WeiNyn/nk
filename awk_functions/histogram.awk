
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
    set_min = 0
    set_max = 0
}

NR > 1 {
    if (typeof($target_col) == "number" || typeof($target_col) == "strnum") {
        nums[$target_col]++;
        if (!set_max || $target_col > max) {
            max = $target_col;
            set_max = 1;
        }

        if (!set_min || $target_col < min) {
            min = $target_col;
            set_min = 1;
        }

        if (nums[$target_col] == 1) {
            uniq_nums++;
        }
    }
}

END {
    if (uniq_nums == 0) {
        printf("0\t0\t0\t%s is not number type\n", col_name);
        exit;
    }
    if (!num_bins) {
        num_bins = 50;
    }

    if (uniq_nums < num_bins) {
        num_bins = uniq_nums;
    }

    range = max - min
    if (range == 0) {
        range = 1;
    }

    bin_size = range / num_bins;

    for (n in nums) {
        bin = int((n - min) / bin_size);
        bins[bin] += nums[n];
    }
    split("red green yellow blue magenta cyan white", colors, " ")

    for (i = 1; i <= num_bins; i++) {
        percent = bins[i] / (NR - 1) * 100
        
        u_index++
        color = colors[u_index % 7 + 1]

        printf("%s\t%s\t%d\t", min + bin_size * (i - 1), min + bin_size * i, percent)
        for (j = 0; j <= 100; j++) {
            if (j <= percent) {
                color_print("█", color)
            }
        }
        printf("\n")
    }

}