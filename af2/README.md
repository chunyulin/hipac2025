# Application: AlphaFold2

## Leader board: See ...

## Quick start example:

#### 1. Download the reduced dbs (~600GB) first:
You can download from the AF2 repo or local host provided by the organizor as below
```
mkdir /data/alphafold2_reduced_dbs
cd /data/alphafold2_reduced_dbs
scp xxx.xxx.xxx:/beegfs/data/af2_reduced.tgz ./
tar zxvf af2_reduced.tgz
```

#### 2. PyPI-based virtual enviornment
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

#### 3. Checkout AlphaFold2 repo
```
git clone https://github.com/google-deepmind/alphafold.git
```

#### 4. Generate SLURM submit script and submit it
```
. ./go_sub
```

## Submit your result:
- Please commit to the repo and make a PR ....

## Some tips:
- AlphaFold spend most of the time to find the homology information and save it in `./msas` for each sequence. To save your testing time, use `--use_precomputed_msas` to reuse the file. But we require the submit runs include the searching time. 
