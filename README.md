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
All functions for design calculation, data calculation, data loading, and plotting are located in the `SRC/` folder. What follows is a list of the functions included and a short description of their use. Note that the individual function files include documentation in the form of comments in the code. If anything is still unclear please do not hesitate to reach out.

| Function | Description |
| --- | --- |
| [`loadM()`](SRC/loadM.m) | Loads default M, the struct that holds all parameters relating to the geophysical model and the experimental design |
| [`getData()`](SRC/getData.m) | Calculates the travel times for the parameters in M. |
| [`genModel3D()`](SRC/gen_model3D.m) | Generate the slowness arrays for the travel time calculation |
| [`loadVelocityModel()`](SRC/loadVelocityModel.m) | Load one of the three velocity models: Uniform, two layer, or three layers |
| [`compute_traveltimes3D()`](SRC/compute_traveltimes3D.m) | Find the arrival times on the surface for a 3D subsurface velocity model. By taking advantage of symmetries a 2D solver can be used |
| [`solveForward()`](SRC/solveForward.m) | 2D eikonal travel time solver (uses time_2d package) |
| [`computeLinear()`](SRC/computeLinear.m) | Compute the optimal experimental design based on the linearised method |
| [`computeEntropy()`](SRC/computeEntropy.m) | Compute the optimal experimental design based on Maximum Entropy |
| [`computeDNO()`](SRC/computeDNO.m) | Compute the optimal experimental design based on D<sub>N</sub>-Optimisation |
| [`plotMetric()`](SRC/plotMetric.m) | Updates the receiver map plot during calculation |
| [`saveResults3D()`](SRC/save_results3D.m) | Save results to disk |
| [`computeSimilarEvents()`](SRC/computeSimilarEvents.m) | Post-processing method to compute the number of repeated receiver locations |
| [`splitMaster()`](SRC/splitMaster.m) | Post-processing method to split the results file into separate files based on the velocity model and experimental design algorithm used |

## References
D. Stowell and M. D. Plumbley
    Fast multidimensional entropy estimation by k-d partitioning.
    IEEE Signal Processing Letters 16 (6), 537--540, June 2009.
    http://dx.doi.org/10.1109/LSP.2009.2017346

Rob Campbell (2022). numSubplots - neatly arrange subplots (https://www.mathworks.com/matlabcentral/fileexchange/26310-numsubplots-neatly-arrange-subplots), MATLAB Central File Exchange. Retrieved July 28, 2022.

H Bloem, A Curtis, H Maurer
    Experimental design for fully nonlinear source location problems: which method should I choose?
    Geophysical Journal International, Volume 223, Issue 2, November 2020, Pages 944–958.
    https://doi.org/10.1093/gji/ggaa358
    
  
