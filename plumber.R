# plumber.R

#* @apiTitle expander API
#* @apiDescription Expand sequences of creation/annihilation  operators into normal from. Made possible by Zenseact Innovation week.
#* @apiContact list(name = "Fredrik Wartenberg", email = "fredrik.wartenberg@zenseact.com")

#* Transform a annihilation/creation operator strings like aaadda into normalized form.
#* Strings need to be concatenations of charcters 'a' for annihlation operators
#* @param term the term to transform
#* @get /normalOrder
function(term="") {
  list(normalOrder = compactOneLine(term))
}

