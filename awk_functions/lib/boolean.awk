
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