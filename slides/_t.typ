#set page(width: 500pt, height: 600pt, margin: 10pt)
#let graycode(body) = text(fill: rgb("#777777"), body)
#let stacked(active: 0, blocks, gap: 5pt) = {
  blocks.enumerate().map(((i, b)) => {
    if i == active { b } else { graycode(b) }
  }).join(v(gap))
}
#let hl(lines, body) = {
  show raw.line: it => if lines.contains(it.number) {
    box(fill: rgb("#ffee88"), inset: (x: 2pt, y: 0pt), it.body)
  } else { it.body }
  body
}
#let b1 = ```stan
data {
  int N;
}
```
#let b2 = ```stan
parameters {
  real theta;
}
```
#stacked(active: 1, (b1, b2))
#v(10pt)
#hl((2, 3), ```stan
model {
  y ~ normal(mu, sigma);
}
```)
