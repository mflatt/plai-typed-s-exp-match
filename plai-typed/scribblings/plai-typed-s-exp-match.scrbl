#lang scribble/manual
@(require (for-label (only-meta-in 0 plai-typed)
                     (only-in plai-typed/s-exp-match s-exp-match?))
          scribble/racket)

@title{PLAI Typed S-Sxpression Matching}

@defmodule[plai-typed/s-exp-match]{The
@racketmodname[plai-typed/s-exp-match] library provides a single
function, @racket[s-exp-match?], for checking that an S-expression has
a particular shape, where the shape is described by a pattern that is
also represented as an S-expression.}

@defthing[s-exp-match? (s-expression s-expression -> boolean)]{

Compares the first S-expression, a @deftech{pattern}, to the second
S-expression, a @deftech{target}.

To a first approximation, @racket[s-exp-match?] is just
@racket[equal?] on the two S-expressions. Unlike @racket[equal?],
however, certain symbols in the @tech{pattern} and can match various
S-expressions within the @tech{target}.

For example, @racket[`NUMBER] within a @tech{pattern} matches
any number in corresponding position within the @tech{target}:

@racketblock[
(test (s-exp-match? '(+ NUMBER NUMBER) '(+ 1 10))
      true)
(test (s-exp-match? '(+ NUMBER NUMBER) '(+ 1 x))
      false)
(test (s-exp-match? '(+ NUMBER NUMBER) '(- 1 10))
      false)
]

The following symbol S-expressions are treated specially within
the @tech{pattern}:

@itemlist[

 @item{@racket[`NUMBER] --- matches any number S-expression}

 @item{@racket[`STRING] --- matches any string S-expression}

 @item{@racket[`SYMBOL] --- matches any symbol S-expression}

 @item{@racket[`ANY] --- matches any S-expression}

 @item{@racket[`...] --- within a list S-expression, matches any
       number of repetitions f the preceding S-expression within the
       list; only one @racket[`...] can appear as an immediate element
       of a pattern list, and @racket[`...] is not allowed within a
       pattern outside of a list or as the first element of a list}

]

Any other symbol in a @tech{pattern} matches only itself in the
@tech{target}. For example, @racket[`+] matches only @racket[`+].

@racketblock[
  (test (s-exp-match? `NUMBER '10)
        true)
  (test (s-exp-match? `NUMBER `a)
        false)
  (test (s-exp-match? `SYMBOL `a)
        true)
  (test (s-exp-match? `SYMBOL '"a")
        false)
  (test (s-exp-match? `STRING '"a")
        true)
  (test (s-exp-match? `STRING '("a"))
        false)
  (test (s-exp-match? `ANY '("a"))
        true)
  (test (s-exp-match? `ANY '10)
        true)
  (test (s-exp-match? `any '10)
        false)
  (test (s-exp-match? `any `any)
        true)

  (test (s-exp-match? '(SYMBOL) '(a))
        true)
  (test (s-exp-match? '(SYMBOL) '(a b))
        false)
  (test (s-exp-match? '(SYMBOL SYMBOL) '(a b))
        true)
  (test (s-exp-match? '((SYMBOL) SYMBOL) '((a) b))
        true)
  (test (s-exp-match? '((SYMBOL) NUMBER) '((a) b))
        false)
  (test (s-exp-match? '((SYMBOL) NUMBER ((STRING))) '((a) 5 (("c"))))
        true)
  (test (s-exp-match? '(lambda (SYMBOL) ANY) '(lambda (x) x))
        true)
  (test (s-exp-match? '(lambda (SYMBOL) ANY) '(function (x) x))
        false)

  (test (s-exp-match? '(SYMBOL ...) '(a b))
        true)
  (test (s-exp-match? '(a ...) '(a b))
        false)
  (test (s-exp-match? '(a ...) '(a a))
        true)
  (test (s-exp-match? '(a ...) '())
        true)
  (test (s-exp-match? '(a ... b) '())
        false)
  (test (s-exp-match? '(a ... b) '(b))
        true)
  (test (s-exp-match? '(a ... b) '(a a a b))
        true)
  (test (s-exp-match? '((a ...) b ...) '((a a a) b b b b))
        true)
  (test (s-exp-match? '((a ...) b ...) '((a a a) b c b b))
        false)
]
}
