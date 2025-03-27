# Application: AlphaFold2

## Leader board: See ...

## Quick start:

### 1. Download the reduced dbs (~600GB) first from `/beegfs/data/alphafold2_data`.

### 1. PyPI-based virtual enviornment
```
ENV_PATH=/raid/lincy/ENV/hipac
python -m venv ${ENV_PATH}
source ${ENV_PATH}/bin/activate

pip install --upgrade pip setuptools
pip install hmmer biopython absl-py dm-haiku dm-tree ml-collections pandas tensorflow-cpu flax
pip install nvidia-cudnn-cu12 nvidia-cuda-cupti-cu12
pip install jax==0.4.29 jaxlib==0.4.29+cuda12.cudnn91 -f https://storage.googleapis.com/jax-releases/jax_cuda_releases.html

# Non-PyPI packages

## hh-suite
https://github.com/soedinglab/hh-suite.git
( cd hh-suite; cmake . -DCMAKE_INSTALL_PREFIX=${ENV_PATH}; make -j; make install

## kalign
https://github.com/TimoLassmann/kalign.git
( cd kalign; cmake . -DCMAKE_INSTALL_PREFIX=${ENV_PATH}; make -j; make install

## pdbfixer
https://github.com/openmm/pdbfixer.git
( cd pdbfixer; pip install . )
```

### 1. Clone AlphaFold2
```
git clone https://github.com/google-deepmind/alphafold.git
```

### 1. Run
```
. ./go_sub
```

## Submit your result:
- Commit to ....
