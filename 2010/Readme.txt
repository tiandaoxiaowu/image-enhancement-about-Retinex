This is the README file of the matlab code released for an IEEE Transactions on Visualization and Computer Graphics paper "Globally Optimized Linear Windowed Tone-Mapping" (Code organized by Qi Shan, Cewu Lu, and Jiaya Jia  (shanqi@cs.washington.edu, {cwlu, leojia}@cse.cuhk.edu.hk). It is for educational use ONLY. 

=======================
Requirements
=======================

Matlab platform

=======================
THE USAGE
=======================

1. Main Matlab file "mainEntry1".
2. Important parameters:
    "epsilon" -- the weight to balance the two terms in Eq. (3) (page 4 of the paper), the default value is 0.1;
    "win_size" -- the window width and height, the default value is 3;
    "{beta1, beta2, beta3}" -- the 3 beta values in Eq. (6) (page 5 of the paper), the default values are {1.2, 0 ,0};
    "s_sat" -- the saturation factor in Eq. (5) (page 4 of the paper), the default value is 0.6.
3. A few examples are in the example directory.

=======================
SKELETON OF THE CODE
=======================
The overview is in table 1 in the paper.

1. Main entry
- Function "mainEntry1". The input is a pfm image; the result is the tone-mapped image which stored in the matrix called "nidata"
- Function "getpfmraw" reads gray scale PFM (raw) images.
- Returned gray scale image in an array (http://www.cs.unc.edu/~adyilie/comp256/PA2/Source/MatLab/getpfmraw.m)

2. Generate the guidance map c 
- Function generateGuidanceMap1( lumo , win_size , kappa , beta1 , beta2 , beta3 )
 Input parameters: lumo - image radiance
               win_size - window size
               kappa, beta1 , beta2 , beta3  are shown in Eq. (6)
 Output: guidance map matrix           

3. Construct matrices S and B according to Eq. (18) in the Appendix.
- Function "SolveLumi" - a multigrid architecture that solves the large linear system. The initial level is 3. When it reduces to 1, program enters function "solveLumiFire". 
- Function "SolveLumiFire" - it has two important parts: (1) creating the matrices S and B in "getLaplacian4" and (2) solving the linear system

- Function "getLaplacian4" - it creates the matrices S and B
Input parameter: lumin - image radiance
              win_size - window size
              ci - guidance map computed by "generateGuidanceMap1" 
              Cie - multiGridFilt
              allowedMemorySize - the allowed Memory size  
Output: the matrices S and B

4. Compute I by solving the linear system defined in Eq. (17) in the Appendix of the paper.
- getLinearCoeffs
- upSmpLumiByLinearCoeffs

These 2 files together implement a multi-scale method (when level num is greater than 1) to solve the linear system [S,B] in SolveLumi.m.

5. Restore the RGB channels in the tone mapped result by Eq. (5).
- part of mainEntry1.
- "cutPeakValley": this function cuts off unreasonable peaks and Valleys. 
