
<!-- README.md is generated from README.Rmd. Please edit that file -->

# pastaDaGg

### Authentic italian `ggplot2` recepies

<!-- badges: start -->

<!-- badges: end -->

A delicious toy wrapper around `ggplot2` for visualizing longitudinal
datasets.

## Installation

You can install the development version of pastaDaGg from
[GitHub](https://github.com/) with:

``` r
# install.packages("pak")
pak::pak("SereDef/pastaDaGg")
#> ℹ Loading metadata database
#> ✔ Loading metadata database ... done
#> 
#> 
#> → Will install 16 packages.
#> → Will update 1 package.
#> → All 17 packages (18.66 MB) are cached.
#> + cli                       3.6.5      🔧
#> + farver                    2.1.2      🔧
#> + ggplot2                   4.0.0      
#> + glue                      1.8.0      🔧
#> + gtable                    0.3.6      
#> + isoband                   0.2.7      🔧
#> + labeling                  0.4.3      
#> + lifecycle                 1.0.4      
#> + pastaDaGg    0.0.0.9000 → 0.0.0.9000 👷🏼🔧 (GitHub: d17073f)
#> + R6                        2.6.1      
#> + RColorBrewer              1.1-3      
#> + rlang                     1.1.6      🔧
#> + S7                        0.2.0      🔧
#> + scales                    1.4.0      
#> + vctrs                     0.6.5      🔧
#> + viridisLite               0.4.2      
#> + withr                     3.0.2
#> ℹ No downloads are needed, 17 pkgs (18.66 MB) are cached
#> ✔ Got cli 3.6.5 (x86_64-apple-darwin20) (1.48 MB)
#> ✔ Got farver 2.1.2 (x86_64-apple-darwin20) (2.02 MB)
#> ✔ Got vctrs 0.6.5 (x86_64-apple-darwin20) (1.98 MB)
#> ✔ Got rlang 1.1.6 (x86_64-apple-darwin20) (1.92 MB)
#> ✔ Got ggplot2 4.0.0 (x86_64-apple-darwin20) (5.92 MB)
#> ✔ Installed pastaDaGg 0.0.0.9000 (github::SereDef/pastaDaGg@d17073f) (517ms)
#> ✔ Installed R6 2.6.1  (515ms)
#> ✔ Installed RColorBrewer 1.1-3  (517ms)
#> ✔ Installed S7 0.2.0  (512ms)
#> ✔ Installed cli 3.6.5  (503ms)
#> ✔ Installed farver 2.1.2  (538ms)
#> ✔ Installed ggplot2 4.0.0  (551ms)
#> ✔ Installed glue 1.8.0  (551ms)
#> ✔ Installed gtable 0.3.6  (550ms)
#> ✔ Installed isoband 0.2.7  (547ms)
#> ✔ Installed labeling 0.4.3  (537ms)
#> ✔ Installed lifecycle 1.0.4  (530ms)
#> ✔ Installed rlang 1.1.6  (520ms)
#> ✔ Installed scales 1.4.0  (511ms)
#> ✔ Installed vctrs 0.6.5  (538ms)
#> ✔ Installed viridisLite 0.4.2  (537ms)
#> ✔ Installed withr 3.0.2  (83ms)
#> ✔ 1 pkg + 16 deps: upd 1, added 16, dld 5 (13.32 MB) [19.1s]
# or 
# devtools::install_github("SereDef/pastaDaGg")
```

## Examples

### Spaghetti

``` r
library(pastaDaGg)

pastaDaGg::spaghetti(anthropometry, y = "head_circumference", id = "id", color_by = "sex", split_by = "nationality")
```

<img src="man/figures/README-spaghetti-1.png" width="100%" />

``` r
#' 
```
