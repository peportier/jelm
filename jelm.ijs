require'trig'
require'plot'
require'numeric'

pushup=:   ] + 0.1 * |
pushdown=: ] - 0.1 * |

NB. identify the elements with values between {.x and {:x
sel=: (] >: {.@[) *. (] <: {:@[)

mp=: +/ . * NB. matrix product

diag=: (<0 1)&|: : (([:(>:*i.)[:#])})
addDiag=: ([+diag@]) diag ] NB. add x to the diagonal of y

mean=: +/ % #
rmse=: [: %: [: mean ([: *: -)

f=: 3 : '(^y) * cos 2*pi * sin pi * y'
noise=: 4 : 'y + -&x *&(+:x) ? (#y) # 0'

gendat=: 4 : 0
  X=: ? y $ 0
  Y=: x noise f X
  minmaxX=: (<./ , >./) X
  minmaxf=: (([: pushdown <./) , ([: pushup >./)) f steps 0 1 100
  XT=: ? (>. 0.1 * y) $ 0
  YT=: f XT

)


plotdatnoshow=: 3 : 0
  pd 'reset'
  pd 'color green'
  pd 'type marker'
  pd 'markersize 1'
  pd 'markers circle'

  pd X;Y
  pd 'color red'
  pd 'type line'
  pd 'pensize 1'
  pd (;f) steps 0 1 100

)
plotdat=: 3 : 0
  plotdatnoshow 0
  pd 'show'
)

plotpoly=: 3 : 0
  plotdatnoshow 0
  pd 'color blue'
  xs=: (] #~ minmaxX"_ sel ]) /:~ X,steps 0 1 100
  pval=: c&p. xs
  crop=: minmaxf sel pval
  pd (crop # xs);(crop # pval)
  pd 'show'
)

polyreg=: 3 : 0
  c=: Y ([ %. ] ^/ i.@#@]) X
  plotpoly 0
)

gram=: 3 : 0
  A=: X ^/ i.y
  S=: (mp~ |:) A
) 

leastsq=: 3 : 0
  gram y
  c=: ((|:A) mp Y) %. S
  plotpoly 0
)

ridge=: 4 : 0
  gram y
  c=: ((|:A) mp Y) %.  x addDiag S
  plotpoly 0
)

plotelm=: 3 : 0
  plotdatnoshow 0
  pd 'type line'
  pd 'color blue'
  xs=: (] #~ minmaxX"_ sel ]) steps (<.<./X),(>.>./X),100
  pd xs;(mkH ,. xs) mp c
  pd 'show'
)

initelm=: 3 : 0
  W=: _1 + 2 * ? (y,1) $ 0 NB. input weights
  B=: ? y $ 0 NB. bias
  H=: mkH ,. X
  0 [ S=: (mp~ |:) H
)
mkH=: 3 : '0&>. B +"1 y mp"1/ W'

elm=: 3 : 0
  c=: ((|:H) mp Y) %.  y addDiag S
  plotelm 0
)

plottest=: 3 : 0
  pd 'reset'
  pd 'color green'
  pd 'type marker'
  pd 'markersize 1'
  pd 'markers circle'

  pd XT;YT
  pd 'color magenta'
  pd XT;YThat
  pd 'color red'
  pd 'type line'
  pd 'pensize 1'
  pd (;f) steps 0 1 100

  pd 'show'
)

test=: 3 : 0
  YThat=: (mkH ,. XT) mp c
  plottest 0
  YT rmse YThat
)


