<!-- # SMT Major.Minor.Patch-alpha.Build
### What's new in version Major.Minor.Patch-alpha.Build
### New functions/features in version Major.Minor.Patch-alpha.Build
### Deprecated functions/features in version Major.Minor.Patch-alpha.Build
### Backwards compatibility in version Major.Minor.Patch-alpha.Build
### Bug fixes in version Major.Minor.Patch-alpha.Build
### Thanks -->

# Sound Morphing Toolbox (SMT) Release Notes

The SMT is a set of Matlab functions that implement a sound morphing algorithm for isolated musical instrument sounds. The SMT was first presented at the [Timbre 2018](https://www.mcgill.ca/timbre2018/) conference. Further information can be found in the article presented at the [CMMR 2019](https://cmmr2019.prism.cnrs.fr) conference.

## Quick setup

1. Download and unzip the files to a folder (e.g., `/userhome/myfolder`)
2. Start Matlab
3. Open the SMT folder (e.g., `/userhome/myfolder`) in Matlab (Navigate to `/userhome/myfolder/sound-morphing-master/` under the **Current Folder** menu)
4. Run the script `run_smt.m` to generate the example.
5. Add your own sounds to the `./audio` subfolder, open and edit `run_smt.m` appropriately to morph your own sounds

WARNING! Before running the code for the first time, you must add the folder `sound-morphing-master` and all its subfolders to the Matlab search path. The script `run_smt.m` automatically adds the folder (and all subfolders) of the currently running script (`run_smt.m`) to the path. So the folder structure and the location of the script `run_smt.m` in that folder structure are important. If you change the location of `run_smt.m` (or if anything goes wrong), add the SMT folder (e.g., `/userhome/myfolder/sound-morphing-master/`) to your Matlab path by hand (right click on the folder `/userhome/myfolder/sound-morphing-master/` in the Current Folder menu and choose Add to path > Selected Folders and Subfolders).

## Dependencies

The file `run_smt_dependencies.txt` lists all file dependencies. All required `.m` files can be found in this SMT repository. However, the SMT also requires the Matlab signal processing toolbox.

## Acknowledgements

This project has received funding from the European Union’s Horizon 2020 research and innovation programme under the Marie Sklodowska-Curie grant agreement No 831852 (MORPH)

---

## SMT 0.3.0-alpha.1

Sound Morphing Toolbox (SMT) version 0.3.0 alpha release build 1

### What's new in version 0.3.0-alpha.1

- Further improvements to harmonic selection
- Harmonic selection fully integrated into sinusoidal analysis
- Choice of harmonic selection of partials (_after_ partial tracking) or strict harmonic selection of spectral peaks (_without_ partial tracking)
- Added interpolation of the number of partials

## New functions/features in version 0.3.0-alpha.1

- Added low-level function `+tools/+harm/harm_part_sel.m`
- Added low-level function `+tools/+harm/harm_peak_sel.m`
- Updated high-level function `SM/harmonic_selection.m`
- Added logical flag `HARMSELFLAG` to function `SM/sinusoidal_analysis.m` to enable/disable harmonic selection
- Added logical flag `PTRACKFLAG` to function `SM/sinusoidal_analysis.m` to enable/disblable partial tracking
- Added text flag `PTRACKALGFLAG` to function `SM/sinusoidal_analysis.m` to select partial tracking algorithm
- Added high-level function `SMT/partial_interpolation.m`

### Backwards compatibility in version 0.3.0-alpha.1

- New harmonic selection feature resulted in API changes to high-level functions inside the folder `SM/`
  - Additional input arguments in a different order in function `SM/sinusodal_analysis.m`
  - Different order of input arguments in function `SM/sinusoidal_analysis.m`
  - Additional arguments in function `SM/sinusoidal_resynthesis.m`
  - Different order of input arguments in function `+tools/+harm/harm_peak_sel.m`

### Bug fixes in version 0.3.0-alpha.1

- Fixed bug in function `+tools/+harm/harm_peak_sel.m`

## SMT 0.2.0-alpha.1

Sound Morphing Toolbox (SMT) version 0.2.0 alpha release build 1

### What's new in version 0.2.0-alpha.1

- Fully vectorized sinusoidal analysis
- Vectorized sinusoidal resynthesis
- Namespace `+STFT` for the short-time Fourier transform
- Namespace `+tools` for the core functions
- Refactored codebase into low-level core functionality and high-level calls to core functions
- Added support for power scaling spectral estimation of sinusoidal parameters
- Standardization of nomenclature of entire codebase
- Refactored and restructured partial tracking
- Updated functions in folder `+tools/+spec/` to also handle odd FFT size

### New functions/features in version 0.2.0-alpha.1

- Function `SM/freq_matching.m` was completely refactored into several local functions called as subroutines
- Partial tracking step has a dedicated function `SM/partial_tracking.m`, which calls the functions `SM/peak2peak_freq_matching.m` and `SM/freq_matching.m`
- Introduced power scaling sinusoidal parameter estimation in functions `XQIFFT/xqifft.m` and `XQIFFT/interp_pow_scaling.m`
- Added functions `tools.sin.is2ptpeak.m`, `tools.sin.is3ptpeak.m`, `tools.sin.ispeak.m`
- Added function `tools.math.quadfit.m` with improved implementation of quadratic fit that also handles _symmetrical spectral peaks_
- Introduced subroutine `SM/parameter_estimation.m`
- Updated function `SM/peak_picking.m` inside _parameter estimation_ to handle _regular_ and _symmetrical_ spectral peaks
- Updated all functions in folder `+tools/+spec/` to be able to handle even or odd size of the DFT

### Deprecated functions/features in version 0.2.0-alpha.1

- Several functions became deprecated and were replaced

### Bug fixes in version 0.2.0-alpha.1

- Several bug fixes

---

## SMT 0.1.1

Sound Morphing Toolbox (SMT) version 0.1.1

### What's new in version 0.1.1

- Added CMMR2019 folder
- Added auxiliary plotting functions `CMMR2019/CMMR2019_makefigsinres.m` and `CMMR2019/CMMR2019_makefigpeaktrack.m`

---

## SMT 0.1.0

Sound Morphing Toolbox (SMT) version 0.1.0

### What's new in version 0.1.0

- Initial release

### Acknowledgements for SMT 0.1.0

This work was financed by National Funds through the Portuguese funding agency, FCT - _Fundação para a Ciência e a Tecnologia_ within grant SFRH/BPD/115685/2016.
