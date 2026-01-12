# Venus SAR Analysis Toolbox

I have written this MATLAB toolbox for analyzing system design for a SAR. All parameters are selected for mapping of Venus.

## Directory Structure
- **+sar/**: Core library package containing physics and logic, mostly functions and classes.
  - `Config.m`: Global constants.
  - `Timing.m`: PRF selection logic (Diamond plots).
  - `Orbit.m`, `Geometry.m`, `Antenna.m`, `Performance.m`: Helper classes.
- **data/**: Storage for input `.mat` files.
- **scripts/**: Executable analysis scripts for making plots and all.
- **main.m**: Interactive driver script for quick runs.

## Usage
Run `main.m` in MATLAB to start the interactive menu.
