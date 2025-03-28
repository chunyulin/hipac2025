# Application: AlphaFold2

## [Leaderboard](../leaderboard_af2.md)

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
pip install nvidia-cuda-cupti-cu12 nvidia-cudnn-cu12 nvidia-cufft-cu12 nvidia-cusolver-cu12 nvidia-cusparse-cu12
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

#### 4. Steps to run the competiton task
- Firstly, fork the [repository you are looking now](https://github.com/chunyulin/hipac2025.git) from the browser or use github CLI.
    - You can fork from the browser, which might be easier.
    - Or use github CLI with a classic personal token:
    ```
    gh auth login
    gh gh repo fork chunyulin/hipac2025 --clone
    ```
- Then, swicth to another branch for your team, to which your result will be submit.
    ```
    cd hipac2025
    git checkout -b <your_branch_name>
    ```
- Copy `./work` into your Alphafold2 folder, which contain all the script you need to run the competition.
- In `./work/data/`, run `python read_casp.py` to get data file for the competition task.
- In `./work`, run `./go_sub.sh --submit` to generate SLURM scripts and submit.

#### 5. Submit your result:
- Create a folder of your team in `./submit`. For example, execute `mkdir ./submit/<Your_Team_Name>` at the current folder.
- Copy all results in `./work/runs` to your team folder just created, which include the timing as the main metric for the competition. See the `./submit/Team_Baseline` for the example folder structure.
- Commit to the repo and make a PR (Pull request). For example:
    ```
    git add .
    git commit     ## check update file list, give a short description, and save.
    git push --set-upstream origin <your_branch_name>
    ```
- Now, go to your github on a browser. GitHub will suggest creating a PR. Just click "Compare & pull request", and wait for the organizer review.

## Some tips:
- AlphaFold spend most of the time to find the homology information and save in `./msas` for each sequence. To save the testing time, use `--use_precomputed_msas` to reuse it. But we require the final submission include the searching time.
