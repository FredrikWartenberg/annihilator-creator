## Script for transforming expressions of creation ('d') and
## anihilation ('a') operators in normal form
## uses the facts that
## [a,d] = 1
## ad - da = 1
## ad = da + 1
## see e.g. https://en.wikipedia.org/wiki/Creation_and_annihilation_operators
## TERM := ['any combination of 'd's and 'a's ,1*]
## CTERMS := [d^Na^M, d^N, a^M, 1^K], K,N,M integer > 0
## EXPRESSION := sum of 1 or more TERMS
## CEXPRESSION := Sum of 1 or more  CTERMS 
## TERMS and CTERMS are represented as strings
## EXPRESSIONS and CEXPRESSIONS are represented as data.tables

library(data.table)
library(stringr)

##' Expand one instance of "ad" in a TERM with da + 1
##'
##' Will yield an EXPRESSION of one or two terms
##' @title Expand ad 
##' @param x ad-expression
##' @return EXPRESSION as data.table with a single TERM (no expansion possible) or
##' two TERMs (after expansion)
##' @author Fredrik Wartenberg
expand <- function(x) {
    bup <- unlist(str_split(x,"ad",n=2))
    if(length(bup) == 2)
        EXPRESSION <-  data.table(expand.grid(bup[1], c("da", ""), bup[2]))
    else
        EXPRESSION <- data.table(Var1=x,Var2="",Var3="")

    EXPRESSION[,TERM:= paste0(Var1,Var2,Var3)]
    EXPRESSION[TERM=="",TERM:="1"] # Special handling if scalar 1
    return(EXPRESSION[,c("TERM")])
}

##' Normalize a TERM into an EXPRESSION
##'
##' Calls expand recursively until no 'ad' TERMS 
##' occur any more and all TERMS are in normal form
##' [d*a*,1*]
##' @title Normalize Expression 
##' @param x ad-term
##' @return a data.table representing an EXPERSSION of normal form TERMS
##' @author Fredrik Wartenberg
normalize <- function(x) {
    nIn <- nrow(x)
    EXPRESSION <- data.table(TERM=unlist(lapply(X=x$TERM,FUN=expand)))
    if(nrow(EXPRESSION ) > nIn) {
        EXPRESSION <- normalize(EXPRESSION)
    }    
    return(EXPRESSION)
}

## Uses run length encoding (rel)
##' Compact TERMS to CTERMS
##'
##' Compact TERMS of fromat [d*a*,1*] fromat into
##' CTERMS of the format [d^Na^M, d^N, a^M, 1^K]
##' (N,M,K) > 1
##' e.g. ddddaaa into d^4a^3 etc.
##' @title Compact TERMS
##' @param x ad-term
##' @return a CTERM (string)
##' @author 
compact <- function(x) {
    rl <- rle(unlist(strsplit(x,"")))
    CTERM <- ""
    for(i in seq(1:length(rl$values))) {
        CTERM <- paste0(CTERM,paste(rl$values[i],rl$lengths[i],sep="^"))
    }
    CTERM
}

##' Normalize a TERM into a compact normal form CEXPRESSION
##'
##' Produces an Expression of CTERMs from a TERM equal CTERMS
##' are counted with the CEXPRESSION being represented as a
##' data.table with each row representing the sum of N CTERMS
##' and the entire table representing the fully expanded
##' CEXPRESSION as the sum of rows
##' @title Generate Compact Normal Form
##' @param x a string representing a TERM to expand
##' @param factor for the term in an expression
##' @return a CEXPRESSION represented as data.table
##' @author Fredrik Wartenberg
compactNormalForm <- function(x,factor=1) {
    DT <- normalize(data.table(TERM=x))
    DT[,compact:=unlist(lapply(X=TERM,FUN=compact))]
    CEXPRESSION <- DT[,.N,by=compact][,c("N","compact")]
    CEXPRESSION[,N := N* factor]
    return(CEXPRESSION[])
}
