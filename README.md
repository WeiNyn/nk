# Introduction
This is nk (nu - awk), a wrapper in nu shell for awk. It is a work in progress, and is not yet ready for use freely.

# Features
- [x] Describe columns of files (csv, tsv, etc.) with headers
- [x] Review columns of files with headers
- [x] Plot columns of files with headers (histogram, categorical, etc.)
- [x] Filter columns of files with headers
- [x] Value count for specific columns of files with headers

# Requirements
- [nu shell](You need to install nu shell first. See https://www.nushell.sh/book/installation.html) 
- [gawk] (https://www.gnu.org/software/gawk/manual/gawk.html)

# Install
Add this line to you $nu.config-path
```nu
use path/to/nk/awk_functions.nu *
```

# Usage
```bash
nk ds_str <file> <column> # Describe a column of a file with headers
nk ds_bool <file> <column> # Describe a column of a file with headers
nk ds_num <file> <column> # Describe a column of a file with headers
nk cate_plot <file> <column> # Plot a column of a file with headers
nk hist_plot <file> <column> # Plot a column of a file with headers
nk vc <file> <column> # Value count for a column of a file with headers
nk filter <filter> <filter> <column> # Filter a column of a file with headers
```

