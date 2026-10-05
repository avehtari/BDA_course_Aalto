#import "@preview/mosaic:0.0.1" as m
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

#show: m.setup.with(
  title: [BDA Course 2026],
  subtitle: [Lecture 5],
  //authors: [Aki Vehtari, Osvaldo Martin],
  paper: "4-3",
  // handout: true,
)
#set page(fill: rgb("#ffffff"))
#set text(size: 21pt)
#show heading: set text(fill: rgb("#550e8b"))
#show "•": set text(fill: rgb("#6c3b91"))
#let redtext(x) = text(fill: rgb("#f66d7f"), weight: "bold", math.bold(x))
#let bluetext(x) = text(fill: rgb("#36acc6"), weight: "bold", math.bold(x))
#let purpletext(x) = text(fill: rgb("#7c2695"), weight: "bold", math.bold(x))
#let yellowtext(x) = text(fill: rgb("#fac364"), weight: "bold", math.bold(x))
#let greentext(x) = text(fill: rgb("#006400"), weight: "bold", math.bold(x))
#let navytext(x) = text(fill: rgb("#000080"), x)

#let graytext(x) = text(fill: rgb("#777777"), x)

#m.slide(layout: "title")

== Chapter 11

- 11.1 Gibbs sampler
- 11.2 Metropolis and Metropolis--Hastings
- 11.3 Using Gibbs and Metropolis as building blocks
- 11.4 Inference and assessing convergence (important)
  - potential scale reduction $hat(R)$ (R-hat)
- 11.5 Effective number of simulation draws (important)
  - effective sample size (ESS / $S_"eff"$)
- #graytext[11.6 Example: hierarchical normal model (quick glance)]


== Objectives of this Lecture

- Discuss the core ideas behind MCMC methods, a family of very general sampling algorithms that are the backbone of modern Bayesian analysis
- Discuss practical diagnostics we use to check these MCMC methods


== Monte Carlo Methods (Reminder)

- Monte Carlo methods are used to approximate expectations by averaging over random samples
- If we can draw samples $theta^(1), dots, theta^(S)$ from a distribution $p(theta)$, then for any function $h(theta)$, define the Monte Carlo estimate
$
    "E"[h(theta)] approx hat(h)_S = 1/S sum_(s=1)^S h(theta^(s))
$
- By CLT
$
    hat(h)_S approx "N"("E"[h(theta)], ("Var"[h(theta)])/S)
$
- In practice, we do not know $"Var"[h(theta)]$ so we use the sample variance, $hat(sigma)^2$.
- $hat(sigma)/sqrt(S)$ is the Monte Carlo Standard Error (MCSE), which quantifies the uncertainty due to using a finite number of samples


==  Why ordinary Monte Carlo is not enough

- Monte Carlo provides a general _recipe_ to compute quantities of interest, but not a general _recipe_ for sampling from complex, high-dimensional distributions
- rejection sampling: inefficient for high-dimensional distributions
- importance sampling: can be unreliable when the proposal and target differ substantially

==  Markov chain Monte Carlo (MCMC)

#m.steps.reveal[
- A very important family of Monte Carlo methods
- Useful to generate samples from complex distributions (potentially) in higher dimensions
- The key idea:
  - generate parameter values from a proposal distribution
  - decide whether to keep it
  - repeat
- There are many MCMC methods:
  - Metropolis--Hastings
  - Gibbs sampling
  #v(0.2cm)
  - Hamiltonian Monte Carlo (HMC) (next lecture)
  - etc...
] 

== Metropolis method

#align(center)[#image("figs/metropolis_criteria.pdf", width: 28cm)]  


==  Metropolis--Hastings
1. Start from some parameter point $theta^(0)$
2. At iteration $t$, propose a new point
  $
    theta^* ~ g(theta^* | theta^(t-1))
  $

3. Evaluate the density of the proposed and current point and accept with probability:
  $
    alpha(theta^(t-1), theta^*)
    =
    min(1,
    (quad p(theta^* | y) thick quad g(theta^(t-1) | theta^(*)))
    /
    (p(theta^(t-1) | y) quad g(theta^* | theta^(t-1))))
  $
  Accept -> $theta^(t) = theta^*$; #h(.5cm) Reject -> $theta^(t) = theta^(t-1)$
4. Repeat from 2

#align(center)[#image("figs/symmetric_proposal.pdf", width: 16cm)]  

== We don't need the normalizing constant

- The acceptance ratio in Metropolis--Hastings only involves a *ratio* of posterior densities:
$
    alpha(theta^(t-1), theta^*)
    =
    min(1,
    (quad #redtext[$p(theta^* | y)$] thick quad g(theta^(t-1) | theta^*))
    /
    (#redtext[$p(theta^(t-1) | y)$] quad g(theta^* | theta^(t-1)))
    )
$

- By Bayes theorem
$
    #redtext[$(p(theta^* | y))/(p(theta^(t-1) | y))$]
    =
    ((p(y | theta^*) p(theta^*)) / p(y))/((p(y | theta^(t-1)) p(theta^(t-1))) / p(y))
    =
    (p(y | theta^*) p(theta^*))/(p(y | theta^(t-1)) p(theta^(t-1)))
$

- The normalizing constant $p(y)$ cancels, so we don't need to compute it!
  #v(0.5cm)
- More generally, if $p(theta | y) prop q(theta | y)$ for some unnormalized $q$, the ratio $q(theta^*|y) / q(theta^(t-1)|y)$ is all we need.


== OK but, why does this work? (Intuition)

- The acceptance ratio compares the density at the proposed point to the density at the current one
- Moving to a more likely point: always accept
- Moving to a less likely point: the ratio tells us how reluctant to be
  - a slightly less likely point $->$ accept almost always
  - a much less likely point $->$ accept rarely
- Rejecting is not discarding: we stay at $theta^(t-1)$. So at each iteration we always accumulate a draw.
 #v(0.5cm)
- As a result, the samples at each value of $theta$ are proportional to $p(theta | y)$
  - The simulation automatically spends more time in regions of higher posterior density
#v(1fr)
#link("https://chi-feng.github.io/mcmc-demo/app.html?algorithm=RandomWalkMH&target=banana")[Interactive Random Walk MH Demo]

==  Markov chain

- MH proceeds by generating a sequence of draws
  $
    theta^(0), theta^(1), theta^(2), dots
  $
- The present draw depends only on the previous one
- Such sequence can be described as a *Markov chain*
- A sequence of random variables is a Markov chain if
  $ p(theta^t | #graytext[$theta^0, theta^1, dots,$] theta^(t-1)) = p(theta^t | theta^(t-1)) $
  #v(0.5cm)
  In words: given the current state, the past does not provide additional information about the next state

==  Markov chain: a simple example

- Consider a chain with two states, #bluetext[a] and #redtext[b]
#align(center)[
#set text(14pt)
#diagram(
  node-stroke: 0.1em,
	edge-stroke: 0.1em,
	spacing: 4em,
	node((0,0), text(size: 20pt, fill: rgb("#36acc6"), weight:"bold")[a], radius: 2em),
	node((1,0), text(size: 20pt, fill: rgb("#f66d7f"), weight:"bold")[b], radius: 2em),
	edge((0,0), (0,0), `0.8`, "-|>", bend: 130deg),
	edge((0,0), (1,0), `0.2`, "-|>", bend: -40deg),
	edge((1,0), (1,0), `0.6`, "-|>", bend: 130deg),
	edge((1,0), (0,0), `0.4`, "-|>", bend: -40deg),
)
]

- We can simulate a particular sequence and count how often each state is visited
  #bluetext[a] #bluetext[a] #redtext[b] #redtext[b] #bluetext[a] #bluetext[a] #redtext[b]  #redtext[b] #redtext[b] #bluetext[a]  #bluetext[a] #bluetext[a] #bluetext[a] #bluetext[a] #redtext[b] #redtext[b] #bluetext[a] #bluetext[a] #bluetext[a] #bluetext[a] #bluetext[a] #bluetext[a] #redtext[b]...

$
  p("a") approx 1/S sum_(s=1)^S I("state" = "a") = 0.7
$


- This is the same idea as the Monte Carlo, simulate a long sequence of states and count how often we are in state #bluetext[a]

==  Markov chain: The transition matrix

- Consider a chain with two states, #bluetext[a] and #redtext[b]
#align(center)[
#set text(12pt)
#diagram(
  node-stroke: 0.1em,
	edge-stroke: 0.1em,
	spacing: 4em,
	node((0,0), text(size: 20pt, fill: rgb("#36acc6"), weight:"bold")[a], radius: 2em),
	node((1,0), text(size: 20pt, fill: rgb("#f66d7f"), weight:"bold")[b], radius: 2em),
	edge((0,0), (0,0), `0.8`, "-|>", bend: 130deg),
	edge((0,0), (1,0), `0.2`, "-|>", bend: -40deg),
	edge((1,0), (1,0), `0.6`, "-|>", bend: 130deg),
	edge((1,0), (0,0), `0.4`, "-|>", bend: -40deg),
)
]

- We can write the transition probabilities in matrix form:
$
 T = mat(
  , a, b;
  a, 0.8, 0.2;
  b, 0.4, 0.6
)
$

- Starting from either state, and repeatedly applying the transition we get

  $
    T^s =
    mat(#bluetext[$0.67$], 0.33;
        0.67, #redtext[$0.33$])
  $

- The long-run probabilities are therefore approximately

  $
    p(a) = 0.67,
    quad p(b) = 0.33
  $

== Markov chain: stationary distribution

- If $p^((t)) = (p^((t))("a"), p^((t))("b"))$, then
$ 
    p^((t)) = p^((t-1)) T
$
- Starting from #bluetext[a]:
$
    p^((1)) = (0.8, 0.2)
    quad
    p^((2)) = (0.72, 0.28)
    quad
    dots
    quad
    p^((t)) -> (0.67, 0.33)
$
- No matter where we start, $p^((t))$ converges to the same distribution $pi = (0.67, 0.33)$
- $pi$ is called the stationary distribution: once reached, the chain stays there
$
    pi T = pi
$

== Detailed balance

- Checking $pi T = pi$ directly is often hard for complex chains
  #v(0.3cm)
- A simpler and sufficient condition: detailed balance
  $
      pi(a) med T(a -> b) = pi(b) med T(b -> a)
  $
  the flow from $a$ to $b$ exactly balances the flow from $b$ to $a$
  #v(0.3cm)
- If detailed balance holds for all states then $pi$ is a stationary distribution
- We can check this directly: with $pi = (0.67, 0.33)$,
  $
    pi("a") med T("a"->"b") = 0.67 times 0.2 = 0.133\
    pi("b") med T("b"->"a") = 0.33 times 0.4 = 0.133
  $
  balanced!

== Back to Metropolis--Hastings

- MH constructs a Markov chain over $theta$:
  - The transition probabilities are given by the proposal $g$ and the acceptance rule $alpha$
  - We want $p(theta | y)$ to be the stationary distribution 

- To prove that's true we have to establish:
  1. The sequence $theta^((0)), theta^((1)), dots$ is a Markov chain with a *unique* stationary distribution
  2. That stationary distribution is $p(theta | y)$

- We'll take (1) as given (next slide) and then focus on proving (2) using *detailed balance*


== Uniqueness of the stationary distribution

#m.steps.reveal[
- For a Markov chain to have a *unique* stationary distribution, it must be:
  - irreducible: positive probability of eventually reaching any state from any other
  - aperiodic: doesn't cycle through states on a fixed schedule
  - recurrent: probability of returning to any given state is 1
  #v(0.5cm)
- These hold for MH under mild conditions on the proposal $g$ and the target $p(theta|y)$:
  - *Irreducible*: whenever $g(theta^* | theta) > 0$, we also have $alpha(theta, theta^*) > 0$, any point reachable by the proposal is reachable by the chain.
  - *Aperiodic*: As we can always stay at the current state a "return" after 1 step is always possible, and then returns can happen after any number of steps. 
  - *Recurrent*: If $p(theta|y)$ integrates to 1, the chain can't drift off to low-density regions forever, it's pulled back to any given state in finite expected time
]








// == Why Metropolis--Hastings works

// - Take two points #bluetext[$theta_a$] and #redtext[$theta_b$], with $p(#redtext[$theta_b$] | y) >= p(#bluetext[$theta_a$] | y)$
// - The probability of transitioning from #bluetext[$theta_a$] to #redtext[$theta_b$] is
//   $
//       p(theta^(t-1) = #bluetext[$theta_a$], theta^t = #redtext[$theta_b$])
//       = p(#bluetext[$theta_a$] | y) thick g(#redtext[$theta_b$] | #bluetext[$theta_a$]) thick alpha(#bluetext[$theta_a$], #redtext[$theta_b$])
//   $
// - Since $p(#redtext[$theta_b$] | y) >= p(#bluetext[$theta_a$] | y)$, we know $alpha(#bluetext[$theta_a$], #redtext[$theta_b$]) = 1$, so this simplifies to
//   $
//       p(#bluetext[$theta_a$] | y) thick g(#redtext[$theta_b$] | #bluetext[$theta_a$])
//   $

// - Now the transition from #redtext[$theta_b$] to #bluetext[$theta_a$]:
//   $
//       p(theta^(t-1) = #redtext[$theta_b$], theta^t = #bluetext[$theta_a$])
//       = p(#redtext[$theta_b$] | y) thick g(#bluetext[$theta_a$] | #redtext[$theta_b$]) thick alpha(#redtext[$theta_b$], #bluetext[$theta_a$])
//   $
// - Here #bluetext[$theta_a$] is less likely, so
//   $
//       alpha(#redtext[$theta_b$], #bluetext[$theta_a$]) = min(1, (p(#bluetext[$theta_a$]|y) g(#redtext[$theta_b$]|#bluetext[$theta_a$]))/(p(#redtext[$theta_b$]|y) g(#bluetext[$theta_a$]|#redtext[$theta_b$])))
//   $
// - And then the ratio inside the min is $<=1$ so we know that
//   $
//     p(#redtext[$theta_b$]|y) g(#bluetext[$theta_a$]|#redtext[$theta_b$]) >= p(#bluetext[$theta_a$]|y) g(#redtext[$theta_b$]|#bluetext[$theta_a$]) 
//   $

// == Why Metropolis--Hastings works

// - Write $A = p(#redtext[$theta_b$]|y) g(#bluetext[$theta_a$]|#redtext[$theta_b$])$, so we need $A dot alpha(#redtext[$theta_b$], #bluetext[$theta_a$])$
// - For any positive constant $A$:
//   $
//       A dot min(1, B) = min(A dot 1,thick A dot B) = min(A, thick A B)
//   $
// - Here $B = (p(#bluetext[$theta_a$]|y) g(#redtext[$theta_b$]|#bluetext[$theta_a$]))/(p(#redtext[$theta_b$]|y) g(#bluetext[$theta_a$]|#redtext[$theta_b$]))$, so
//   $
//       A dot B
//       = p(#redtext[$theta_b$]|y) g(#bluetext[$theta_a$]|#redtext[$theta_b$]) times (p(#bluetext[$theta_a$]|y) g(#redtext[$theta_b$]|#bluetext[$theta_a$]))/(p(#redtext[$theta_b$]|y) g(#bluetext[$theta_a$]|#redtext[$theta_b$]))
//       = p(#bluetext[$theta_a$]|y) g(#redtext[$theta_b$]|#bluetext[$theta_a$])
//   $
// - So:
//   $
//       p(#redtext[$theta_b$]|y) g(#bluetext[$theta_a$]|#redtext[$theta_b$]) thick alpha(#redtext[$theta_b$], #bluetext[$theta_a$])
//       = min(
//         thick p(#redtext[$theta_b$]|y) g(#bluetext[$theta_a$]|#redtext[$theta_b$]),
//         thick p(#bluetext[$theta_a$]|y) g(#redtext[$theta_b$]|#bluetext[$theta_a$])
//       )
//   $
//   #v(0.5cm)
// - And we already show that $p(#redtext[$theta_b$]|y) g(#bluetext[$theta_a$]|#redtext[$theta_b$]) >=
//       thick p(#bluetext[$theta_a$]|y) g(#redtext[$theta_b$]|#bluetext[$theta_a$])$, then min will select $p(#bluetext[$theta_a$] | y) thick g(#redtext[$theta_b$] | #bluetext[$theta_a$])$

// == Why Metropolis--Hastings works: resolving the min

// - The the backward transition probability is:
//   $
//       p(#redtext[$theta_b$] | y) thick g(#bluetext[$theta_a$] | #redtext[$theta_b$]) thick alpha(#redtext[$theta_b$], #bluetext[$theta_a$])
//       = p(#bluetext[$theta_a$] | y) thick g(#redtext[$theta_b$] | #bluetext[$theta_a$])
//   $
// - Compare with the forward transition:
//   $
//       p(#bluetext[$theta_a$] | y) thick g(#redtext[$theta_b$] | #bluetext[$theta_a$]) thick alpha(#bluetext[$theta_a$], #redtext[$theta_b$])
//       = p(#bluetext[$theta_a$] | y) thick g(#redtext[$theta_b$] | #bluetext[$theta_a$])
//   $
// - Both right sides are identical and then detailed balance holds:
//   $
//       p(#bluetext[$theta_a$]|y) thick P(#bluetext[$theta_a$] -> #redtext[$theta_b$])
//       =
//       p(#redtext[$theta_b$]|y) thick P(#redtext[$theta_b$] -> #bluetext[$theta_a$])
//   $


== Why Metropolis--Hastings works

- Take two points $theta_a$ and $theta_b$
- When moving from $theta_a$ to $theta_b$ we have
  $
      p(theta_a|y) dot g(theta_b|theta_a) dot
      overbrace(
        min(1, (p(theta_b|y) g(theta_a|theta_b)) / (p(theta_a|y) g(theta_b|theta_a))),
        alpha(theta_a,theta_b)
      )
  $
- Write $L = p(theta_a|y) g(theta_b|theta_a)$ and $R = p(theta_b|y) g(theta_a|theta_b)$ and substitute L and R into the expression
  $
      L  dot min(1, R / L)
  $
- Assume $L <= R$, then $R/L >= 1$ and $min(1, R/L) = 1$, giving
  $
    p(theta_a|y) dot g(theta_b|theta_a) dot alpha(theta_a,theta_b) = L
  $

== Why Metropolis--Hastings works

- Now when moving from $theta_b$ to $theta_a$ we have
  $
    p(theta_b|y) dot g(theta_a|theta_b) dot
    overbrace(
      min(1, (p(theta_a|y) g(theta_b|theta_a)) / (p(theta_b|y) g(theta_a|theta_b))),
      alpha(theta_b,theta_a)
    )
  $
- Substitute L and R into the expression
  $
    R  dot min(1, L / R)
  $
- Since $L <= R$, then $L/R<=1$ and $min(1, L/R) = L/R$
  $
    p(theta_b|y) thick g(theta_a|theta_b) thick alpha(theta_b,theta_a) = R dot (L/R) = L
  $

- Both terms are equal, hence detailed balance holds:
  $
    p(theta_a|y) thick g(theta_b|theta_a) thick alpha(theta_a,theta_b)
    = L =
    p(theta_b|y) thick g(theta_a|theta_b) thick alpha(theta_b,theta_a)
  $
#v(0.5cm)
- If instead $R <= L$, the same argument with $theta_a, theta_b$ swapped applies

// == Why Metropolis--Hastings works

// - Take two points $theta_a$ and $theta_b$, with $p(theta_b | y) >= p(theta_a | y)$
// - The probability of transitioning from $theta_a$ to $theta_b$ is
//   $
//         p(theta^(t-1) = theta_a, theta^t = theta_b)
//         = p(theta_a | y) thick g(theta_b | theta_a) thick alpha(theta_a, theta_b)
//   $
// - Since $p(theta_b | y) >= p(theta_a | y)$, we know $alpha(theta_a, theta_b) = 1$, so this simplifies to
//   $
//         p(theta_a | y) thick g(theta_b | theta_a)
//   $

//   #v(1cm)
// - Now the transition from $theta_b$ to $theta_a$:
//   $
//         p(theta^(t-1) = theta_b, theta^t = theta_a)
//         = p(theta_b | y) thick g(theta_a | theta_b) thick alpha(theta_b, theta_a)
//   $
// - Now $alpha(theta_b, theta_a)<=1$:
//   $
//         alpha(theta_b, theta_a) = min(1, (p(theta_a|y) g(theta_b|theta_a))/(p(theta_b|y) g(theta_a|theta_b)))
//   $
// - And then the ratio inside the min is $<=1$ so we know that
//   $
//       p(theta_b|y) g(theta_a|theta_b) >= p(theta_a|y) g(theta_b|theta_a)
//   $

// == Why Metropolis--Hastings works

// - Write $A = p(theta_b|y) g(theta_a|theta_b)$, so we need $A dot alpha(theta_b, theta_a)$
// - For any positive constant $A$:
// $
//       A dot min(1, B) = min(A dot 1,thick A dot B) = min(A, thick A B)
// $
// - Here $B = (p(theta_a|y) g(theta_b|theta_a))/(p(theta_b|y) g(theta_a|theta_b))$, so
// $
//       A dot B
//       = p(theta_b|y) g(theta_a|theta_b) times (p(theta_a|y) g(theta_b|theta_a))/(p(theta_b|y) g(theta_a|theta_b))
//       = p(theta_a|y) g(theta_b|theta_a)
// $
// - So:
// $
//       p(theta_b|y) g(theta_a|theta_b) thick alpha(theta_b, theta_a)
//       = min(
//         thick p(theta_b|y) g(theta_a|theta_b),
//         thick p(theta_a|y) g(theta_b|theta_a)
//       )
// $
//   #v(0.5cm)
// - And we already showed that $p(theta_b|y) g(theta_a|theta_b) >=
//       thick p(theta_a|y) g(theta_b|theta_a)$, so the min selects $p(theta_a | y) thick g(theta_b | theta_a)$

// == Why Metropolis--Hastings works: resolving the min

// - The backward transition probability is:
// $
//       p(theta_b | y) thick g(theta_a | theta_b) thick alpha(theta_b, theta_a)
//       = p(theta_a | y) thick g(theta_b | theta_a)
// $
// - Compare with the forward transition:
// $
//       p(theta_a | y) thick g(theta_b | theta_a) thick alpha(theta_a, theta_b)
//       = p(theta_a | y) thick g(theta_b | theta_a)
// $
// - Both right sides are identical and thus detailed balance holds:
// $
//       p(theta_a|y) thick P(theta_a -> theta_b)
//       =
//       p(theta_b|y) thick P(theta_b -> theta_a)
// $


== Markov chain Monte Carlo (recap)

- Produce draws $theta^(t)$, given $theta^(t-1)$, from a Markov chain, constructed so that the equilibrium distribution is $p(theta | y)$
  - [+] This is a very generic algorithm (inference engine)
  - [+] We just need an easy to sample distribution (proposal) and be able to evaluate the target distribution up to a normalizing constant
  - [+] asymptotically, the chain spends the $alpha$% of time where $alpha$% posterior mass is
  - [-] draws are dependent
  - [-] construction of efficient Markov chains is not always easy


== Markov chain and expectations

- Andrey Markov proved weak law of large numbers and central limit theorem for certain dependent-random sequences, which were later named Markov chains
  - CLT still holds for Markov chains if the variance is finite
- The probability of each event depends only on the state attained in the previous event (or finite number of previous events)
- Markov estimated the transition probabilities for the 20 000 first vowels and consonants in Pushkin's novel "Yevgeniy Onegin"
#v(1fr)
#link("https://www.youtube.com/watch?v=0zgyZ8B7EJk")[Veritasium: Markov Chains]


== MCMC draws are dependent

- Monte Carlo estimates still valid (CLT holds as proved by Markov)
  $
    E_(p(theta | y))[h(theta)] approx 1/S sum_(s=1)^S h(theta^(s))
  $
- Estimation of Monte Carlo error is more difficult
  - dependency reduces the efficiency
  - we need to compute the effective sample size (ESS)
  - given finite variance, the distribution of the expectation approaches normal distribution with variance $sigma_theta^2 / "ESS"$


==  Metropolis--Hastings: Toy example

- Posterior is a Bivariate Normal
  $
    mat(theta_1; theta_2) | y
    tilde N(
      mat(y_1; y_2),
      mat(1, rho; rho, 1)
    )
  $

#align(center)[#image("figs/Metrop1.pdf", width: 12cm)]

#link("https://avehtari.github.io/BDA_R_demos/demos_ch11/demo11_2.html")[Metropolis demo]

==  The proposal affects the performance

- In theory: we can use (almost) any proposal distribution and still obtain samples from the target distribution
- In practice: the choice of the proposal distribution greatly affects the efficiency of the sampling

#align(center)[
  #grid(
    columns: 2,
    [#image("figs/Metrop2.pdf")],
    [#image("figs/Metrop3.pdf")],
  )
]

== In practice the proposal matters

- Ideal proposal distribution is the distribution itself
  - acceptance probability is $1$
  - independent draws
  - not usually feasible
- Good proposal distribution resembles the target distribution
  - generic algorithms uses normal or $t$ distribution
- Selecting a good scale for the proposal distribution is crucial
  - small scale $arrow.r$ many steps accepted, but the chain moves slowly
  - large scale $arrow.r$ long steps proposed, but many rejected and again chain moves slowly
- Generic rule for acceptance rate is $approx 10-40%$, it varies with the dimensionality of the posterior and specificities of the MCMC algorithm


== From MH to Gibbs

- What if every proposed value were always accepted?
- Model with parameters $mu$ and $sigma^2$; alternate between
$
    p(mu | sigma^2, y)
    quad "and" quad
    p(sigma^2 | mu, y)
$
- If both conditionals are easy to sample from, we build the sequence with no rejection step at all

#align(center)[#image("figs/fake3_joint2.pdf", width: 10cm)]

== Gibbs sampling

- Recall the Metropolis--Hastings acceptance probability:
$
    alpha(theta^(t-1), theta^*)
    =
    min(1,
    (p(theta^* | y) thick #redtext[$g(theta^(t-1) | theta^*)$])
    /
    (p(theta^(t-1) | y) thick #bluetext[$g(theta^* | theta^(t-1))$])
    )
$

- In Gibbs sampling, the component $theta_j$ is updated conditional on the rest, $theta_(-j)$ (that remain fixed), then
$
    #bluetext[$g(theta^* | theta^(t-1)) = p(theta_j^* | theta_(-j), y)$]
    quad quad
    #redtext[$g(theta^(t-1) | theta^*) = p(theta_j^(t-1) | theta_(-j), y)$]
$

- Substituting into $alpha$, numerator and denominator both split into the same two factors:
$
    alpha(theta^(t-1), theta^*)
    =
    min(1,
    (p(theta_j^* | theta_(-j), y) thick #redtext[$p(theta_j^(t-1) | theta_(-j), y)$])
    /
    (p(theta_j^(t-1) | theta_(-j), y) thick #bluetext[$p(theta_j^* | theta_(-j), y)$])
    )
    = min(1, 1) = 1
$

== Gibbs sampling: example

#align(center)[#image("figs/Gibbs1.pdf", width: 14cm)]

#link("https://avehtari.github.io/BDA_R_demos/demos_ch11/demo11_1.html")[Gibbs demo]


== Gibbs sampling

- With _conditionally_ conjugate priors, the sampling from the conditional distributions is easy for wide range of models
  - BUGS/WinBUGS/OpenBUGS/JAGS
- No algorithm parameters to tune
  (cf. proposal distribution in Metropolis algorithm)
- For not so easy conditionals, use e.g. inverse-CDF
- Several parameters can be updated in blocks (_blocking_)
- Slow if parameters are highly dependent in the posterior

== MH and Gibbs: pros and cons

- Gibbs sampling is useful when the full conditional distributions are easy to sample from
- But often we do not have full conditionals in closed form
- MH is more general and can be applied (virtually) to any model
- MH needs careful design of the proposal distribution
- In practice the proposal is adaptively tuned for each particular problem


== We don't live in asymptopia

- MCMC has theoretical guarantees only in the limit of infinite draws
- In practice we run finite chains
- We need to check if we can trust our finite chains before computing any posterior summaries from them.

== What can go wrong in finite time?

- Non-convergence: the chain hasn't yet found the main mass of the target distribution
- Poor mixing: the chain explores the target slowly (it gets "stuck")


== Warm-up and convergence diagnostics

- Asymptotically chain spends the $alpha$% of time where $alpha$% posterior mass is
  - but in finite time the initial part of the chain may be non-representative and lower error of the estimate can be obtained by throwing it away
#align(center)[#image("figs/Metrop1.pdf", width: 8cm)]
- Warm-up = remove draws from the beginning of the chain
  - warm-up may include also phase for adapting algorithm parameters (like the scale of the proposal)

== Several chains

- Start chains from different starting points, preferably overdispersed
#align(center)[#image("figs/10chains1.pdf", width: 12cm)]
- Remove the initial portion of each chain
- Check if the chains are distinguishable from each other

== Trace plot: Old school visual check

  - Plot the values of the chains over iterations to visually inspect convergence
  - It should look "noisy", "fuzzy", "caterpillar-like"
  - Overlaying multiple chains helps to visually compare chains
  - But overlaying also may hide individual chain behavior
#align(center)[
  #image("figs/trace_single_good_bad.pdf")
  #v(0.5cm)
]

== Trace plot: Old school visual check

  - Plot the values of the chains over iterations to visually inspect convergence
  - It should look "noisy", "fuzzy", "caterpillar-like"
  - Overlaying multiple chains helps to visually compare chains
  - But overlaying also may hide individual chain behavior
#align(center)[
  #image("figs/trace_multiple_good.pdf", width: 18cm)
  #v(0.5cm)
]

== Rank plots: Modern visual check

- If chains have converged to the same distribution, fractionalranks should be uniformly distributed within each chain

#align(center)[
  #image("figs/rank_plot_good.pdf", width: 19cm)


]

== Rank plots: Modern visual check

#align(center)[
  #image("figs/rank_plot_steps.pdf")
]


== Rank plots: Modern visual check

- Plot the rank distribution within each chain using a histogram

#align(center)[
  #grid(
    columns: 1,
    [#image("figs/rank_plot_bad.pdf", width: 16cm)],
    [#image("figs/trace_plot_bad.pdf", width: 17cm)],
  )
]


== Rank plots: from histograms to ECDFs

- Histograms of ranks can be sensitive to bin choice
- Instead plot the empirical CDF of the ranks
- Use fractional ranks (rescaled to $[0,1]$) instead of raw ranks ($1$ to $S$)
- The CDF of the Uniform(0, 1) goes from $(0,0)$ to $(1,1)$ (diagonal line)
- Deviations from the diagonal indicates potential convergence issues

#align(center)[#image("figs/rank_ecdf_plot_bad.pdf", width: 20cm)]

== Rank plots: the ECDF difference plot

- Problem: near the diagonal, most of the plot is empty space, deviations may be hard to see
- Fix: plot the difference from the expected line instead
- Now a perfect match is a flat line at $0$
- Also add a numerical uniformity check

#align(center)[#image("figs/rank_decdf_plot_bad.pdf", width: 20cm)]


== Numerical convergence diagnostic: $hat(R)$

- Run $M$ chains: if they've converged to the same distribution, they should be indistinguishable 
 - Variance *between* chains should match variance *within* each chain
 - If chains haven't converged (e.g. stuck in different regions), between-chain variance will be inflated relative to within-chain variance

#align(center + horizon)[
  #m.steps.replace(
    image("figs/rhat_plot_0.pdf", width: 25cm),
    image("figs/rhat_plot_1.pdf", width: 25cm),
    image("figs/rhat_plot_2.pdf", width: 25cm),
    image("figs/rhat_plot_3.pdf", width: 25cm),
  )
]


// == Setup

// - $M$ chains, $N$ draws each: $theta_(n m)$
// - Within-chain variance $W$ (Average spread *within* each chain)

// $
//   s_m^2 = 1/(N-1) sum_(n=1)^N (theta_(n m) - bar(theta)_(.m))^2, quad
//   W = 1/M sum_(m=1)^M s_m^2
// $

// - Between-chain variance $B$ (how much the chains disagree about *where* they are.)

// $
//   B = N/(M-1) sum_(m=1)^M (bar(theta)_(.m) - bar(theta)_(..))^2
// $

// $N times$ the variance of the $M$ chain means — 

// - Total variance estimate

// $
//   hat("var")^+ = (N-1)/N W + 1/N B
// $

// Weighted average of $W$ and $B$: mostly $W$, plus a correction if chains disagree.


== $hat(R)$
We define $hat(R)$ as the square root of the ratio of the total variance estimate $hat("var")^+$ to the within-chain variance $W$:
$
  hat(R) = sqrt(hat("var")^+ / W)
$

- $W$ underestimates the true variance: a chain that hasn't explored everywhere yet looks too narrow.
- $hat("var")^+$ overestimates the true variance if chains started in different places and haven't mixed yet.

- $hat(R) > 1$ $arrow.r$ not converged
- $hat(R) approx 1$ likely converged
#v(0.5cm)
- This description is very schematic, there are more details in the computation of $hat(R)$ (and more than one version).



== Split-$hat(R)$

- BDA3: split-$hat(R)$
- Chains are split in half
  - after splitting, we have $M$ chains, each having $N$ draws
  - this helps to detect non-stationarity within chains


#align(center)[#image("figs/trace_plot_split.pdf", width: 20cm)]


== Rank normalized $hat(R)$

#m.steps.reveal[
- BDA3 $hat(R)$ requieres finite mean and variance
  - unreliable for heavy tails or finite but very high variance
  - The between-chain variance only compares chain means, so chains with the same location but different scale can look ok
  #v(0.5cm)
- What is new
  - pool all draws, replace by ranks, and transform with the inverse normal-cdf
  - repeat for the ranks of the absolute difference from the median (folding)
  - report the maximum of the two
- Why this helps
  - ranks are always finite and approximately normal if chains have mixed, so the assumptions of $hat(R)$ hold
  - folding turns differences in scale into differences in location
]
#v(0.5cm)
#text(size: 12pt, fill: rgb("#777777"))[
 #link("https://projecteuclid.org/euclid.ba/1593828229")[Vehtari, Gelman, Simpson, Carpenter, Bürkner (2020). Rank-normalization, folding, and localization: An improved $hat(R)$ for assessing convergence of MCMC].
]


== $hat(R)$ in practice

- $hat(R) approx 1$
- in practice we often look for $hat(R) < 1.01$
  - If larger more draws could help
  - If too large more severe problems may exist
  #v(0.5cm)
- Posterior package in R provides functions `rhat_basic()` and `rhat()` to compute $hat(R)$ and rank normalized $hat(R)$, respectively.
- ArviZ in Python provides similar functionality `az.rhat(., method="rank")` (default). The function `az.summary()`, also computes $hat(R)$.


== $hat(R)$ and rank normalized $hat(R)$ in `posterior` package

`rhat_basic()` without rank normalization `rhat()` with rank normalization

#text(size: 16pt, fill: rgb("#777777"))[
```
x <- array(data=c(rnorm(1000,mean=-3),
                  rnorm(1000,mean=3)),
           dim=c(1000, 2, 1))
x <- as_draws_matrix(x)
variables(x) <- "N_2"
```
]

#text(size: 16pt)[
```
x |>
  summarise_draws(mean, sd, mcse_mean, rhat_basic, rhat)
 variable   mean    sd mcse_mean rhat_basic  rhat
 N_2      0.0122  3.18      2.15       3.61  1.83
```
]


== $hat(R)$ and rank normalized $hat(R)$ in `posterior` package

`rhat_basic()` without rank normalization `rhat()` with rank normalization

#text(size: 16pt, fill: rgb("#777777"))[
```
x <- array(data=c(rt(1000,df=1)-6,
                  rt(1000,df=1)+6),
           dim=c(1000, 2, 1))
x <- as_draws_matrix(x)
variables(x) <- "t1_2"
```
]

#text(size: 16pt)[
```
x |>
  summarise_draws(mean, sd, mcse_mean, pareto_khat,
                  rhat_basic, rhat)
```
]

#table(
  columns: 7,
  align: (left, right, right, right, right, right, right),
  table.header(
    [variable], [mean], [sd], [mcse_mean], [pareto_khat], [rhat_basic], [rhat],
  ),
  [t1_2], [-1.11], [42.1], [1.23], [#redtext[1.07]], [1.01], [1.47],
)

== Effective sample size

- We can not use the sample size directly and _plug it_ into the formula for MCSE
- Draws from MCMC chains are typically correlated, so the effective sample size should be smaller than the total number of draws
- We need to compute the Effective sample size (ESS)
- Once we have the effective sample size, we can use it to compute the Monte Carlo standard error (MCSE) for our estimates.
- It can be estimated using the autocorrelation of the chains.

== Time series analysis

- Autocorrelation function
  - describes the correlation given a certain lag
  - can be used to compare efficiency of MCMC algorithms and parameterizations
  - For real valued, the correlation at lag $n$
    $
      ("E"[(X_(t+n) - "E"[X])(X_t - "E"[X])]) / ("Var"[X])
    $

== Autocorrelation

#grid(
  columns: 2,
  [#image("figs/Metrop1.pdf", width: 9cm)],
  [#image("figs/Metrop1trace.pdf", width: 12cm)],
)
#image("figs/Metrop1acf.pdf", width: 12cm)

== Autocorrelation #text(size: 18pt)[(slow mixing due to small step size)]

#grid(
  columns: 2,
  [#image("figs/Metrop2.pdf", width: 9cm)],
  [#image("figs/Metrop2trace.pdf", width: 12cm)],
)
#image("figs/Metrop2acf.pdf", width: 12cm)

== Autocorrelation #text(size: 18pt)[(slow mixing due to many rejections)]

#grid(
  columns: 2,
  [#image("figs/Metrop3.pdf", width: 9cm)],
  [#image("figs/Metrop3trace.pdf", width: 12cm)],
)
#image("figs/Metrop3acf.pdf", width: 12cm)

== Time series analysis

- Time series analysis can be used to estimate Monte Carlo error in case of MCMC
- For expectation $bar(theta)$
  $
    "Var"[bar(theta)] = (sigma_theta^2) / (#bluetext[$S_"eff"$])
  $
  where $#bluetext[$S_"eff" = S\/tau$]$ (=ESS)
- $tau$ is the sum of autocorrelations and describes the relative inefficiency due to the dependency
#align(center)[#image("figs/Metrop1acf.pdf", width: 10cm)]

== Time series analysis

- Estimation of the autocorrelation using several chains
  $
    hat(rho)_n = 1 - (#bluetext[W] - 1/M sum_(m=1)^M #greentext[$hat(rho)_(n,m)$]) / (2 #redtext[$hat("var")^+$])
  $
  where $#greentext[$hat(rho)_(n,m)$]$ is autocorrelation at lag $n$ for chain $m$,
  and $#bluetext[W]$ and $#redtext[$hat("var")^+$] $ are the same as in $hat(R)$ (without rank normalization)
- This combines $hat(R)$ and autocorrelation estimates
  - takes into account if the chains are not mixing (the chains have not converged)
- BDA3 has slightly different and less accurate equation.
- Compared to a method which computes the autocorrelation from a single chain, the multi-chain estimate has smaller variance

== Time series analysis

- Estimation of $tau$
  $
    tau = 1 + 2 sum_(t=1)^infinity hat(rho)_t
  $
  where $hat(rho)_t$ is empirical autocorrelation
#align(center)[#image("figs/Metrop1acf_500.pdf", width: 14cm)]
- $hat(rho)_t$ can be very  noisy 
  - noise is larger for longer lags (less observations)
  - less noisy estimate is obtained by truncating $ hat(tau) = 1 + 2 sum_(t=1)^T hat(rho)_t$

== Geyer's adaptive window estimator

- Truncation can be decided adaptively
- Group the autocorrelations in pairs: $Gamma_m = rho_(2m) + rho_(2m+1)$
- Theory guarantees that for MCMC chains these pair sums are never negative
  - if we estimate a negative $hat(Gamma)_m$, it can only be noise
- *Geyer's rule*: add up the pairs until the first negative one, then stop
  $
    hat(tau) = -1 + 2 sum_(m=0)^M hat(Gamma)_m, quad "ESS" approx S \/ hat(tau)
  $

#align(center)[#image("figs/Metrop1acf.pdf", width: 13cm)]


== Effective sample size

Effective sample size $"ESS" = S_"eff" approx S \/ #bluetext[$hat(tau)$]$

#grid(
  columns: 2,
  row-gutter: 4pt,
  [#image("figs/Metrop1trace.pdf", width: 11cm)],
  [#image("figs/Metrop1acf.pdf", width: 11cm)],
  [#image("figs/Metrop1mcerr.pdf", width: 11cm)],
  [
    #align(left + top)[
      $
        #bluetext[$hat(tau)$] &= 1 + 2 sum_(t=1)^T hat(rho)_t \
        &approx 24
      $
    ]
  ],
)

== Effective sample size

Effective sample size $"ESS" = S_"eff" approx S \/ #bluetext[$hat(tau)$]$

#grid(
  columns: 2,
  row-gutter: 4pt,
  [#image("figs/Metrop2trace.pdf", width: 11cm)],
  [#image("figs/Metrop2acf.pdf", width: 11cm)],
  [#image("figs/Metrop2mcerr.pdf", width: 11cm)],
  [
    #align(left + top)[
      $
        #bluetext[$hat(tau)$] &= 1 + 2 sum_(t=1)^T hat(rho)_t \
        &approx 104
      $
    ]
  ],
)

== Effective sample size

Effective sample size $"ESS" = S_"eff" approx S \/ #bluetext[$hat(tau)$]$

#grid(
  columns: 2,
  row-gutter: 4pt,
  [#image("figs/Metrop3trace.pdf", width: 11cm)],
  [#image("figs/Metrop3acf.pdf", width: 11cm)],
  [#image("figs/Metrop3mcerr.pdf", width: 11cm)],
  [
    #align(left + top)[
      $
        #bluetext[$hat(tau)$] &= 1 + 2 sum_(t=1)^T hat(rho)_t \
        &approx 63
      $
    ]
  ],
)


// == ESS and MCSE in `posterior` package

// Simulated 4 chains with AR(0.3) process

// #text(size: 16pt)[
// ```
// drt |> summarise_draws(mean, sd, pareto_khat,
//                        ess_mean, mcse_mean)
// ```
// ]

// #table(
//   columns: 6,
//   align: (left, right, right, right, right, right),
//   table.header(
//     [variable], [mean], [sd], [pareto_khat], [ess_mean], [mcse_mean],
//   ),
//   [xn], [0.01], [0.99], [-0.07], [2280.], [0.02],
//   [xt3], [0.02], [1.6], [0.33], [2452.], [0.03],
//   [xt2], [0.05], [#strike([2.9])], [#redtext[0.52]], [#strike([2903.])], [#strike([0.05])],
//   [xt1], [#strike([0.33])], [#strike([93.])], [#redtext[1.0]], [#strike([3976.])], [#strike([1.5])],
// )

// == ESS and MCSE in `posterior` package

// Simulated 4 chains with AR(0.3) process

// #text(size: 16pt)[
// ```
// drt |> summarise_draws(mean, pareto_khat,
//                        ess_mean, mcse_mean)
//                        ess_quantile, mcse_quantile)
// ```
// ]

// #table(
//   columns: 7,
//   align: (left, right, right, right, right, right, right),
//   table.header(
//     [variable], [mean], [pareto_khat], [ess_mean], [mcse_mean], [ess_q95], [mcse_q95],
//   ),
//   [xn], [0.01], [-0.07], [2280.], [0.02], [3251.], [0.04],
//   [xt3], [0.02], [0.33], [2452.], [0.03], [3251.], [0.09],
//   [xt2], [0.05], [#redtext[0.52]], [#strike([2903.])], [#strike([0.05])], [3251.], [0.13],
//   [xt1], [#strike([0.33])], [#redtext[1.0]], [#strike([3976.])], [#strike([1.5])], [3251.], [0.49],
// )

// == Bulk-ESS and Tail-ESS in `posterior` package

// - ESS depends on the quantity
// - For quick diagnostic purposes the default summary shows
//   - median and median absolute deviation (`mad`), which are valid in case of infinite mean and variance, too
//   - if `mad` is much smaller than `sd`, suspect infinite variance
//   - Rank-normalized $hat(R)$ `rhat`
//   - Bulk-ESS (`ess_bulk`) is generic ESS for sampling efficiency in bulk using rank normalized values (works for infinite variance)
//   - Tail-ESS (`ess_tail`) is the minimum ESS for 5%- and 95%-quantiles

// #text(size: 13pt)[
// ```
// drt |> summarise_draws()
// ```
// ```
//  variable   mean median    sd   mad    q5   q95  rhat ess_bulk ess_tail
//  xn       0.01     0.00  0.99  0.99  -1.6   1.6  1.00    2284.    3189.
//  xt3      0.02     0.00  1.6   1.1   -2.3   2.3  1.00    2284.    3189.
//  xt2      0.05     0.00  2.9   1.2   -2.8   2.9  1.00    2284.    3189.
//  xt1      0.33     0.00 93.    1.5   -5.8   6.1  1.00    2284.    3189.
// ```
// ]

== ESS and MCSE

- ESS and MCSE depend on the quantity
  - Bulk-ESS and Tail-ESS are useful diagnostic summaries, but eventually need to look at the ESS / MCSE for the quantity of interest

== Diagnostic tools

For this week's assignment:
- $hat(R)$, ESS, MCSE
  - `library(posterior)`
  - `th |> summarise_draws(Rhat=basic_rhat, ESS=mean_ess)`
  - `th |> summarise_draws(mean, mean_mcse)`
  - `th |> summarize_draws(~quantile(.x, probs = c(0.05, 0.95)))`
  - see demo11_5 and Digits case study for the examples how to use these
- trace, autocorrelation, density, scatter plots in R
  - `library(bayesplot)`
  - `mcmc_trace(th)`, `mcmc_acf(th)`, `mcmc_areas(th)`, ...
  - see demo11_5 for the examples for more bayesplot examples
- Python
  - see ArviZ package

// == Problematic distributions

// - Nonlinear dependencies
//   - optimal proposal depends on location
// - Funnels
//   - optimal proposal depends on location
// - Multimodal
//   - difficult to move from one mode to another
// - Long-tailed with non-finite variance and mean
//   - central limit theorem for expectations does not hold

// == Next week: HMC, NUTS, and dynamic HMC

// Effective sample size $"ESS" = S_"eff" approx S \/ #bluetext[$hat(tau)$]$

// #grid(
//   columns: 2,
//   row-gutter: 4pt,
//   [#image("figs/hmc1trace.pdf", width: 11cm)],
//   [#image("figs/hmc1acf.pdf", width: 11cm)],
//   [#image("figs/hmc1mcerr.pdf", width: 11cm)],
//   [
//     #align(left + top)[
//       $
//         #bluetext[$hat(tau)$] &= 1 + 2 sum_(t=1)^T hat(rho)_t \
//         &approx 1.6
//       $
//     ]
//   ],
// )

// == Further diagnostics

// - Pareto-$hat(k)$ diagnostic for checking whether variance is finite
// - Dynamic HMC/NUTS has additional diagnostics
//   - divergences
//   - tree depth exceedences

// == MCMC summary

// #m.steps.reveal[
// - Construct a Markov chain which has desired stationary distribution
//   - most of the density evaluations will be made where most of posterior mass is, which helps to scale in higher dimensions
//   - better Markov chains are more efficient per density evaluation
// - MCMC estimate is biased towards the initial value
//   - this bias can be non-negligible especially for short chains
//   - the bias can be reduced by discarding the initial part of the chain
//   - convergence diagnostics help to decide when the bias can be expected to be negligible
// - MCMC draws are correlated in time, but CLT holds (given finite variance)
//   - effective sample size estimates help to decide how many correlated draws are needed
// - Probabilistic programming frameworks
//   - provide efficient MCMC algorithms that work well without manual tuning for many posterior distributions (more next week)
// ]
