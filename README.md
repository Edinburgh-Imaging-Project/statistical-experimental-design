# Statistical Experimental Design
> This repository contains the Matlab codes used for [*Experimental design for fully nonlinear source location problems: which method should I choose?*](https://doi.org/10.1093/gji/ggaa358)

The codes here are used for Statistical Experimental Design (SED) for geophysical travel time tomography problems. However, with minor/no changes they can be applied to other SED problems as well. Three different methods are available:

1. Bayesian D-Optimisation
2. Maximum Entropy Design
3. D<sub>N</sub>-Optimisation

The first method is a linearised method while the latter two are nonlinear optimisation method. The linearity here describes the relationship between the model parameters and the data. Note that these models are agnostic to the underlying design problem. Hence, they can be used as-is for other design problems (given that the data structure is the same).

## Experiment setup
We want to find the optimal placement of receivers such that we can minimise the uncertainty on the seismic source location. That is, for an area in the subsurface where seismicity is likely to occur the design algorithm has to find the receiver layout to maximise the information about the source locations. The different methods compute the gain in information that is achieved by placing a receiver (or array of receivers) at a certain position on the surface. Receiver locations with greater information gain are more favourable compared to locations with lower information gain. This study only considers receivers placed on a plane, the surface. What is more, to reduce the degrees of freedom in the array design we place the receivers consecutively. Thus, we find the location with the highest information gain for the first receiver and fix the receiver there. Then, we find the location of highest information gain for the second receiver given the first and fix the receiver there. For the third, we find the location of highest information gain given the first two receiver locations, and so on and so forth. 

The subsurface structure is a uniform or simple layer cake model. This is such that we can use a computationally cheaper 2D arrival time calculation. However, more complicated 3D arrival time forward models can be used as well. 

## Wrappers
Four wrapper scripts are available: [`wrapperLinearisedDesign`](wrapperLinearisedDesign.m), [`wrapperEntropyDesign`](wrapperEntropyDesign.m), [`wrapperDnOptimisation`](wrapperDnOptimisation.m), [`wrapperBatchMode`](wrapperBatchMode.m) corresponding to methods 1-3 and a script to run all the methods consecutively. These scripts run the required routines to calculate the data and the experimental design.

## Functions
All functions for design calculation, data calculation, data loading, and plotting are located in the `SRC/` folder. Documentation is to follow.