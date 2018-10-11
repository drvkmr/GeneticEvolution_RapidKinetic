# GeneticEvolution_RapidKinetic

This project is an exploration into the viability of using genetic evolution to drive the designs of geometries using rapid-kinetic.com toolkit. All the codes are written on Processing.org platform. It is open source and can be downloaded free of cost.

Check the video below for better understanding - 
https://vimeo.com/292302545

There are standalone java files for each version you can run and try. You will also find 5 folders in this git, which are the sources of these files. Here is a brief description of each about each of them-
1. manualInterface is an interface designed to allow users to manually design geometries using a point and click interface. Conceptually, this works similar to the traditional CAD tools.
2. Genetic_Objective is a genetic evolution based on an objective fitness criteria. In this case, it's how far the geometries can walk in 10 seconds, but it can be changed to any other criteria easily.
3. Genetic_interactive is a genetic evolution based on user's choices. It allows users to pick the best designs and drive the evolution in the favoured direction. This enables designs process driven towards subjective criterias like aesthetics, elegance, etc. The criterias which cannot be logically defined.
4. Genetic_Qlearn is a work in progress, for using Q-learning, a reinforcement learning algorithm to optimise the designs based on an objective criteria.
5. Toxiclibs is a processing library which needs to be installed to support the codes.


Check the pdf below for the academic paper published for this project - 
https://www.dropbox.com/s/0w0blqt3a8qjaof/Evolving_Kinetic_Structures_via_Interactive_Selection.pdf?dl=0
