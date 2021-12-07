# annihilator-creator

Code for expanding sequences of annihilation and operators into normal order. Sequences are input as strings, where
'a' represents on annihilation operator and 'd' a creation operator (d for 'a dagger').

For the background and formalism see [Annihilation and Creation Operators](https://en.wikipedia.org/wiki/Creation_and_annihilation_operators)

## Function Interface
(from R session)
```
> source("dagger.R")
> compactNormalForm('addda')
> [1] "1*d^3a^2 + 3*d^2a^1"
```

## Rest API
Start server
(from R session)
```
> pl <-  pr("plumber.R")
> pr_run(pl,port=8000)
```
### Use via swagger:
[swagger page](http://127.0.0.1:8000/__docs__/)

### Use via curl
```
curl "http://127.0.0.1:8000/normalOrder?term=aaba"
  % Total    % Received % Xferd  Average Speed   Time    Time     Time  Current
                                 Dload  Upload   Total   Spent    Left  Speed
100    31  100    31    0     0   5153      0 --:--:-- --:--:-- --:--:--  6200{"normalOrder":["1*a^2b^1a^1"]}
```

### Caveats
The implementation is highly inefficient, so calculation for longer strings may take a long time.
