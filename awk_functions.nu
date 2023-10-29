export-env {
    $env.awk_functions.lib.utils = '
    
    function color_print(text, color,    prefix,    suffix) {
        if (color == "red") { 
            prefix = "\033[1;31m"
            suffix = "\033[0m"
        } else if (color == "green") {
            prefix = "\033[1;32m"
            suffix = "\033[0m"
        } else if (color == "yellow") {
            prefix = "\033[1;33m"
            suffix = "\033[0m"a
        } else if (color == "blue") {
            prefix = "\033[1;34m"
            suffix = "\033[0m"
        } else if (color == "purple") {
            prefix = "\033[1;35m"
            suffix = "\033[0m"
        } else if (color == "cyan") {
            prefix = "\033[1;36m"
            suffix = "\033[0m"
        } else if (color == "white") {
            prefix = "\033[1;37m"
            suffix = "\033[0m"
        } else {
            prefix = ""
            suffix = ""
        }

        printf("%s%s%s", prefix, text, suffix)
    }
    '

    $env.awk_functions.lib.number = '# include lib/utils.awk

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
    ' 

    $env.awk_functions.lib.string = '
    
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
    '

    $env.awk_functions.lib.boolean = '
    
    # include lib/utils.awk

    func summary_boolean(booleans,   b) {
        for (b in booleans) {
            if (booleans[b] == "true" || booleans[b] == 1) {
                values["true"]++
                result_boolean["counter"]++
            }
            else if (booleans[b] == "false" || booleans[b] == 0) {
                values["false"]++
                result_boolean["counter"]++
            }
            else {
                values[""]++
                result_boolean["counter"]++
            }
        }
    }

    func boolean_plot(   i, true_percent, false_percent, null_percent) {
        true_percent = values["true"] / result_boolean["counter"]
        false_percent = values["false"] / result_boolean["counter"]
        null_percent = values[""] / result_boolean["counter"]

        for (i = 1; i <= 50; i++) {
            if (i <= true_percent * 50) {
                color_print("═", "green")
            } else if (i <= (true_percent + false_percent) * 50) {
                color_print("═", "red")
            } else if (i <= (true_percent + false_percent + null_percent) * 50) {
                color_print("═", "purple")
            }
        }
    }
    '

    $env.awk_functions.review = '

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
                if ($i != 1 && $i != 0) {
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
                }
            }
        }
    }
    
    
    END {
        printf("Column\tPercent\tType\tExample\n")
        for (c in counter) {
            printf("%s\t%d\t%s\t%s\n", c, counter[c]/(NR - 1) * 100.0, types[c], examples[c])
        }
    }
    '

    $env.awk_functions.describe_string = $env.awk_functions.lib.utils + $env.awk_functions.lib.string + '# include lib/utils.awk
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
        printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\t%s\n", "Column", "Fill", "Count", "Type", "Mode", "MCount", "ModePercent", "NUnique")
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
    
                printf("%s\t%.2f\t%d\t%s\t%s\t%d\t%.2f\t%d\n", c, counter[c]/(NR + 1) * 100.0, counter[c], types[c], mode[c], mcount[c], mcount[c]/counter[c] * 100.0, nunique[c])
    
                num_uniques = 0
                max_occurences = 0
                mod = ""
                delete result_strings
                delete uniques
            }
        }
    }
    '

    $env.awk_functions.describe_number = $env.awk_functions.lib.utils + $env.awk_functions.lib.number + '
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
        
        printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\n", "Column", "Fill", "Q1", "Median", "Q3", "Mean", "Plot")
        
        for (c in counter) {
            if (counter[c]/(NR + 1) * 100.0 >= min_percentage) {
                if (types[c] != "number" && types[c] != "strnum" ) {
                    continue
                }

                summary_num(table[c])

                printf("%s\t%d\t%s\t%s\t%s\t%s\t", c, counter[c]/NR * 100.0, result["q1"] + 0.0, result["median"] + 0.0, result["q3"] + 0.0, result["mean"] + 0.0)
                box_plot()

                printf("\n")

                delete result
                delete occurences
            }
        }
    }
    '

    $env.awk_functions.describe_boolean = $env.awk_functions.lib.utils + $env.awk_functions.lib.boolean + '# include lib/utils.awk
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
                }
    
                table[r][counter[r]] = $i
            }
        }
    }
    
    END {
        printf("%s\t%s\t%s\t%s\t%s\t%s\t%s\n", "Column", "Fill", "Count", "TruePercent", "FalsePercent", "NullPercent", "Plot")
        
        for (c in counter) {
            if (counter[c]/(NR + 1) * 100.0 >= min_percentage) {
                if (is_boolean[c] == 1) { types[c] = "boolean"}
                if (!(types[c] == "boolean")) {
                    continue
                }
                summary_boolean(table[c])
                
                printf("%s\t%d\t%d\t%d\t%d\t%d\t", c, counter[c]/(NR + 1) * 100.0, counter[c], values["true"]/counter[c] * 100.0, values["false"]/counter[c] * 100.0, values[""]/counter[c] * 100.0)
                boolean_plot()
                printf("\n")
    
                delete result_boolean
                delete values
            }
        }
    }
    '

    $env.awk_functions.cate_plot = $env.awk_functions.lib.utils + '
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
    '

    $env.awk_functions.histogram = $env.awk_functions.lib.utils + '
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
    
        print("From\tTo\tCount\tPercent\tBar")
        for (i = 1; i <= num_bins; i++) {
            percent = bins[i] / (NR - 1) * 100
            
            u_index++
            color = colors[u_index % 7 + 1]
    
            printf("%s\t%s\t%d\t%f\t", min + bin_size * (i - 1), min + bin_size * i, bins[i], percent)
            for (j = 0; j <= 100; j++) {
                if (j <= percent) {
                    color_print("█", color)
                }
            }
            printf("\n")
        }
    
    }
    '

    $env.awk_functions.values_count = '
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
    '

    $env.awk_functions.filter = '
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
    
    '
}

# Describe all string columns in a file
export def "nk ds_str" [
    file: string, # file path
    --sep: string = "\"\t\"", # separator
    --minp: int = 0, # minimum percentage of non-null values to be considered
] {
    let awk_code = "\'" + $env.awk_functions.describe_string + "\'"
    ^gawk -F $sep -v min_percentage=${minp} $awk_code $file | lines | split column "\t" | headers |
    upsert Fill {|row| $row.Fill | into float} |
    upsert Count {|row| $row.Count | into int} |
    upsert MCount {|row| $row.MCount | into int} |
    upsert NUnique {|row| $row.NUnique | into int} |
    upsert ModePercent {|row| $row.ModePercent | into float}
}

# Describe all number columns in a file
export def "nk ds_num" [
    file: string, # file path
    --sep: string = "\"\t\"", # separator
    --minp: int = 0, # minimum percentage of non-null values to be considered
] {
    let awk_code = "\'" + $env.awk_functions.describe_number + "\'"
    ^gawk -F $sep -v min_percentage=${minp} $awk_code $file | lines | split column "\t" | headers |
    upsert Fill {|row| $row.Fill | into float} |
    upsert Q1 {|row| $row.Q1 | into float} |
    upsert Median {|row| $row.Median | into float} |
    upsert Q3 {|row| $row.Q3 | into float} |
    upsert Mean {|row| $row.Mean | into float}
}

# Describe all boolean columns in a file
export def "nk ds_bool" [
    file: string, # file path
    --sep: string = "\"\t\"", # separator
    --minp: int = 0, # minimum percentage of non-null values to be considered
] {
    let awk_code = "\'" + $env.awk_functions.describe_boolean + "\'"
    ^gawk -F $sep -v min_percentage=${minp} $awk_code $file | lines | split column "\t" | headers |
    upsert Fill {|row| $row.Fill | into float} |
    upsert Count {|row| $row.Count | into int} |
    upsert TruePercent {|row| $row.TruePercent | into float} |
    upsert FalsePercent {|row| $row.FalsePercent | into float} |
    upsert NullPercent {|row| $row.NullPercent | into float}
}

# Review all columns in a file
export def "nk review" [
    file: string, # file path
    --sep: string = "\"\t\"", # separator
] {
    let awk_code = "\'" + $env.awk_functions.review + "\'"
    ^gawk -F $sep $awk_code $file | lines | split column "\t" | headers |
    upsert Percent {|row| $row.Percent | into float}
}

# Plot categorical columns
export def "nk cate_plot" [
    file: string, # file path
    col_name: string, # column name
    --sep: string = "\"\t\"", # separator
    --minp: int = 0, # minimum percentage to be plotted (categories with lower percentage will not be plotted)
] {
    let awk_code = "\'" + $env.awk_functions.cate_plot + "\'"
    let col_name_param = "col_name=" + $col_name
    let minp_param =  "min_percentage=" + ($minp | into string)
    ^gawk -v $col_name_param -v $minp_param -F $sep $awk_code $file | lines | split column "\t" | 
    str trim | headers |
    upsert Percent {|row| $row.Percent | into float} |
    sort-by Percent
}

# Plot histogram
export def "nk hist_plot" [
    file: string, # file path
    col_name: string, # column name
    --sep: string = "\"\t\"", # separator
    --bins: int = 50, # number of bins
] {
    let awk_code = "\'" + $env.awk_functions.histogram + "\'"
    let col_name_param = "col_name=" + $col_name
    let bins_param =  "num_bins=" + ($bins | into string)
    ^gawk -v $col_name_param -v $bins_param -F $sep $awk_code $file |
    lines | split column "\t" | headers |
    str trim |
    upsert Percent {|row| $row.Percent | into float} |
    upsert Count {|row| $row.Count | into int} |
    upsert From {|row| $row.From | into float} |
    upsert To {|row| $row.To | into float}
}

# Count values
export def "nk vc" [
    file: string, # file path
    col_name: string, # column name
    --sep: string = "\"\t\"", # separator
] {
    let awk_code = "\'" + $env.awk_functions.values_count + "\'"
    let col_name_param = "col_name=" + $col_name
    ^gawk -v $col_name_param -F $sep $awk_code $file | lines | split column "\t" | headers |
    upsert Count {|row| $row.Count | into int}
}

# Filter rows
export def "nk filter" [
    filter: string, # filter file path
    file: string, # file path
    col_name: string, # column name
    --sep: string = "\"\t\"", # separator
] {
    let awk_code = "\'" + $env.awk_functions.filter + "\'"
    let col_name_param = "col_name=" + $col_name
    let filter_file_name = "filter_file=" + $filter
    ^gawk -v $col_name_param -v $filter_file_name -F $sep $awk_code $filter $file
}