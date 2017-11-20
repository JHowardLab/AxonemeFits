# Sperm equation fits
Source code accompanying chapter 9 of book "Dyneins: Structure, Biology and Disease", edited by SM King.

Title: "Computational modeling of dynein activity and the generation of flagellar beating waveforms"

Authors: Veikko F. Geyer (1), Pablo Sartori (2), Frank Jülicher (3), Jonathon Howard (1)

Affiliations: (1) Yale University, New Haven, CT, United States; (2) Laboratory of Living Matter and Center for Studies in Physics and Biology, The Rockefeller University, New York, NY, United States; (3) Max Planck Institute for the Physics of Complex Systems, Dresden, Germany.

## Introduction
This repository contains programs that solve the equation of motion of a flagellum, see [Sartori et al, 2016] for details. Use Compute_example_beats.m to explore three different examples:

Example 1 Bull Sperm, sliding control, clamped base, [Riedel-Kruse et al, 2007]

Example 2 Chlamydomonas, dynamic curvature control, free ends, [Sartori et al, 2016]

Example 3 Chlamydomonas, curvature control, free ends, [Sartori et al, 2016]


## Description
The functions that are called by the Compute_example_beats.m are:

`parameters.m`:	writes input parameters to global variables.
	
	- parameter inputs can be changed in section (1) CHOOSE PARAMETERS, by editing the black numbers
	
	- possible parameter settings are summarized in Table 3 in the book chapter
	
	- note the units of the parameters!	


`bcmat.m`: solves the boundary value problem - calculates the matrix of coefficients for a pair of response coefficients

	- this function is used by solspace.m and beatmodes.m 


`solspace.m`: calculates the determinant of the matrix of coefficients pairs of response coefficients (for a set region of the phase space), finds the minima in the phase space

	- the range of the phase space that should be explored can be changed in section (2) EXPLORE PHASE-SPACE. 

	- note the units of the parameters!

	- The function takes as input vectors, giving the range of of the phase space to explore (xrange, yrange) and an option, that allows for plotting the phase space (for off plots=0, for on plots=1) 
	
	- The function outputs a structure called space, which contains the seeds, the local minima (red dots in figure 4, book chapter)
	
	- `solspace.m` uses the functions extrema.m and extrema2, which are included at the end for the function
			

	beatmodes.m	(calculates solutions)
			- for each identified solution an error is calculated. By changing the parameter err_tol, solutions are either included or 
			excluded from display
			- the function takes as input the seeds, outputted by solstice.m
			- the function outputs a structure called solutions which contains the fields (res, k, A, err, psi, seed)



	plot_phasespace.m (PLOTTING FUNCTION: plots the phase space, depicted in figure 4, book chapter)
			- the function takes as input space, solutions and err_tol 
		
	plot_solution.m	(PLOTTING FUNCTION: plots specific properties of individual solutions, depicted in figure 5, book chapter)
			- the function takes as input solutions, space.index and solution_number
			NOTE: solution_number has to be set manually. It refers to the white circled numbers in the phase space plot
			(figure 4), which are the solutions. The reader has to pick a specific solution number that appears on the phase space plot 


How to run the Compute_example_beats.m:

	i) 	open the function in Matlab 2016b works
	ii)	choose the example that you want to run (parameter Example, line 11, section (0) Choose a specific example)
	iii)	press the run button and accept ‘change folder’ in the pop menu that will open
	iv)	Wait until the figure appears (see wait-bar. The first figure is figure 4 of the book chapter depicting the phase-space
	v)	Choose a specific solution (white circled number) from this figure, change the variable solution_number(line 115) and run section (5) 
		Study a specific Solution, by evaluating section 5 (right-click on section 5, then and press command+enter). 
		Figure 5 will appear, showing the chosen solution

	Then, change the parameters describing the mechanical properties of the flagellum (in section (1) ‘Choose parameters and the region of the phase space’) 
	and the region in the phase space, that you want to explore (in section (2) EXPLORE PHASE-SPACE)
		
	NOTE: Only change the parameters of a specific example and one at a time. Changing the phase space range or the sampling of the space can case the computations
	to take very long. Monitor the wait-bar and consider interrupting the running script (using control+C) to make adjustments to the settings used.
