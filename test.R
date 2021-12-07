source("dagger.R")

## Test a number of TERMS and their correct expansion
testCOL <- function() {

    ## Elementary
    stopifnot(compactOneLine("1") == "1*1^1")
    stopifnot(compactOneLine("da") == "1*d^1a^1")
    stopifnot(compactOneLine("ad") == "1*d^1a^1 + 1*1^1")

    ## Complex
    stopifnot(compactOneLine("dada",4) ==  "4*d^2a^2 + 4*d^1a^1")
    stopifnot(compactOneLine("dadd",2) ==  "2*d^3a^1 + 4*d^2")
    stopifnot(compactOneLine("aada",2) ==  "2*d^1a^3 + 4*a^2")
    stopifnot(compactOneLine("aadd") ==  "1*d^2a^2 + 4*d^1a^1 + 2*1^1")
    
    
}
