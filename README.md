# optimal-transport
This Julia toolbox solves the dynamical optimal transport problem and various extensions allowing mass to vary along transport. It handles:
- an interpolated distance between Fisher-Rao and W2;
- partial optimal transport (quadratic cost, absolute value cost);
- an interpolation between W1 and Fisher-Rao;
- and of course standard Wasserstein distances (1,2);

Check the associated article where the mathematical framework is described:
http://arxiv.org/abs/1506.06430

and see the associated notebooks for a simple overview.

Available soon:
- extension to Riemannian manifolds

## How to run
Update 2015-10-21: 2D examples in the paper has been added. 
```bash
$ julia install.jl
$ julia demo.jl p0 p1 12 0.4
$ julia demo.jl ot0 ot1 12 0.2
```
