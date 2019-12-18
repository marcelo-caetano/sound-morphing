# Sound Morphing Toolbox (SMT) 0.1.1

The SMT is a set of Matlab functions that implement a sound morphing algorithm for isolated musical instrument sounds. The SMT was first presented at https://www.mcgill.ca/timbre2018/. Further information can be found in the article presented at https://cmmr2019.prism.cnrs.fr.

## Quick setup

1. Download and unzip the files to a folder (e.g., */userhome/myfolder*)
2. Start Matlab
3. Open the SMT folder (e.g., */userhome/myfolder*) in Matlab (Navigate to */userhome/myfolder* under the **Current Folder** menu)
4. Add the SMT folder (e.g., */userhome/myfolder*) to your Matlab path. Alternatively, run the script *add2path_smt.m* inside the SMT folder. (Type *add2path_smt.m* in the **Command Window** or double click on *add2path_smt.m* to open it in the **Editor** and click on **Run**)
5. Run the script *run_smt.m* to generate the example.
6. Add your own sounds to the *./audio* subfolder, open and edit *run_smt.m* appropriately to morph your own sounds

## Dependencies

The file *run_smt_dependencies.txt* lists all file dependencies. All required *.m* files can be found in this SMT repository. However, the SMT also requires the Matlab signal processing toolbox.

## Acknowledgements

This work is financed by National Funds through the Portuguese funding agency, FCT - Fundação para a Ciência e a Tecnologia within grant SFRH/BPD/115685/2016.