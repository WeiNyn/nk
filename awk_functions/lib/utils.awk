
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