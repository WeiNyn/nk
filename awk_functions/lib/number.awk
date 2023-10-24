# include lib/utils.awk

func summary_num(nums,    sorted_num,    counter,    total,    max_occurences) {
    counter = asort(nums, sorted_num)
    
    for (i = 1; i <= counter; i++) {
        total += sorted_num[i]
        occurences[sorted_num[i]]++
        if (occurences[sorted_num[i]] == 1) {
            result["num_unique"]++
        }
        if (occurences[sorted_num[i]] > max_occurences) {
            max_occurences = occurences[sorted_num[i]]
            result["mode"] = sorted_num[i]
        }
    }
    result["min"] = sorted_num[1]
    result["max"] = sorted_num[counter]
    result["mean"] = total / counter

    result["median"] = sorted_num[int(counter / 2)]
    if (n % 2 == 0) {
        result["median"] = (result["median"] + sorted_num[int(counter / 2) + 1]) / 2
    }
    result["counter"] = counter

    # get quantiles
    result["q1"] = sorted_num[int(counter / 4)]
    if (n % 4 == 0) {
        result["q1"] = (result["q1"] + sorted_num[int(counter / 4) + 1]) / 2
    }

    result["q2"] = result["median"]

    result["q3"] = sorted_num[int(counter * 3 / 4)]
    if (counter % 4 == 0) {
        result["q3"] = (result["q3"] + sorted_num[int(counter * 3 / 4) + 1]) / 2
    }

    # get interquartile range
    result["iqr"] = result["q3"] - result["q1"]

    # get lower and upper bounds
    result["lower_bound"] = result["q1"] - 1.5 * result["iqr"]
    result["upper_bound"] = result["q3"] + 1.5 * result["iqr"]
}

func box_plot(    num_cols,    range,    q1_index,    q2_index,    q3_index) {
    num_cols = 50

    range = result["max"] - result["min"]
    if (range <= 0) { range = 1 }

    q1_index = int((result["q1"] - result["min"]) / range * num_cols)
    q2_index = int((result["q2"] - result["min"]) / range * num_cols)
    q3_index = int((result["q3"] - result["min"]) / range * num_cols)

    for (i = 1; i <= num_cols; i++) {
        if (i == 1) {
            printf("|")
        }

        else if (i == num_cols) {
            printf("|")
        }
        
        else if (i > 1 && i < q1_index) {
            printf("═")
        }

        else if (i >= q1_index && i < q2_index) {
            color_print("█", "green")
        }

        else if (i == q2_index) {
            color_print("|", "red")
        }

        else if (i > q2_index && i <= q3_index) {
            color_print("█", "blue")
        }

        else if (i > q3_index && i < num_cols) {
            printf("═")
        }

    }
}

func histogram(num_bins) {
    if (num_bins == 0) {
        num_bins = 50
    }
    bin_size = (result["max"] - result["min"]) / num_bins

    for (o in occurences) {
        if (o == result["max"]) {
            bin_index = num_bins
        }
        else {
            bin_index = int((o - result["min"]) / bin_size)
        }

        bins[bin_index] += occurences[o]
    }

    split("red green yellow blue magenta cyan white", colors, " ")

    for (i = 1; i <= num_bins; i++) {
        percent = bins[i] / result["counter"] * 100
        u_index++
        color = colors[u_index % 7 + 1]
        printf("%s\t%s\t%d\t", result["min"] + bin_size * (i - 1), result["min"] + bin_size * i, bins[i])
        for (j = 0; j <= 100; j++) {
            if (j <= percent) {
                color_print("█", color)
            }
        }
        printf("\n")
    }
}