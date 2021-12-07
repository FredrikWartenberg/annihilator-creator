library(data.table)
library(stringr)

tstr <- "aadaadaadd" 


# splits term in two parts around first "ad"
breakup <- function(x){
    unlist(str_split(x,"ad",n=2))
}


# Expand one instance of "ad" with da + 1
expand <- function(x) {
    bup <- breakup(x)
    if(length(bup) == 2)
        DT <-  data.table(expand.grid(bup[1], c("da", ""), bup[2]))
    else
        DT <- data.table(Var1=x,Var2="",Var3="")

    DT[,TERM:= paste0(Var1,Var2,Var3)]
    return(DT[,c("TERM")])
}

## Normalize into normal notatation
## Calls expamnd recursively until nothin more
## can be expanded
normalize <- function(x) {
    nIn <- nrow(x)
    DT <- data.table(TERM=unlist(lapply(X=x$TERM,FUN=expand)))
    if(nrow(DT ) > nIn) {
        DT <- normalize(DT)
    }    
    return(DT)
}

## compacts ddddaaa into d^4a^3 etc.
## Uses run length encoding (rel)
compact <- function(x) {
    rl <- rle(unlist(strsplit(x,"")))
    res <- ""
    for(i in seq(1:length(rl$values))) {
        res <- paste0(res,paste(rl$values[i],rl$lengths[i],sep=""))
    }
    res
}

normalForm <- function(x) {
    DT <- normalize(data.table(TERM=x))
    DT[,compact:=unlist(lapply(X=TERM,FUN=compact))]
    return(DT[,.N,by=compact][,c("N","compact")])
}
