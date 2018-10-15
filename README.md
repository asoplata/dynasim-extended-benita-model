# DynaSim mechanism files for simulating (Benita et al., 2012)

DynaSim-compatible mechanism files for simulation of the cortex of (Benita et
al., 2012).

Adding these mechanism files and associated functions into where you keep your
mechanism files for [DynaSim](https://github.com/DynaSim/DynaSim), e.g.
`/your/path/to/dynasim/models`, should enable you to simulate the computational
cortex from:

    Benita, J. M., Guillamon, A., Deco, G., & Sanchez-Vives, M. V. (2012).
    Synaptic depression and slow oscillatory activity in a biophysical
    network model of the cerebral cortex. Frontiers in Computational
    Neuroscience, 6. https://doi.org/10.3389/fncom.2012.00064

This is NOT intended as a bit-perfect reproduction of the original model, but
rather just an open-source, adequate reproduction of the overall qualitative
results.

## Install and Usage

The easiest way to get started with this is:
1. Install DynaSim (https://github.com/DynaSim/DynaSim/wiki/Installation),
   including adding it to your MATLAB path.
2. Run `git clone https://github.com/asoplata/dynasim-benita-2012-model` or
   download this code's repo
   (https://github.com/asoplata/dynasim-benita-2012-model) into
   `'/your/path/to/dynasim/models'`, i.e. the `'models'` subdirectory of your
   copy of the DynaSim repo.
3. Start MATLAB, and run the main runscript `runBenitaModel.m`.

## References

1. Benita, J. M., Guillamon, A., Deco, G., & Sanchez-Vives, M. V. (2012).
   Synaptic depression and slow oscillatory activity in a biophysical
   network model of the cerebral cortex. Frontiers in Computational
   Neuroscience, 6. https://doi.org/10.3389/fncom.2012.00064
