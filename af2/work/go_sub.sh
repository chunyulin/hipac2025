#!/bin/bash

QUEUE=large
DATA_PATH=/beegfs/data/alphafold2_reduced_dbs
RUN=$1

pdb70_path="${DATA_PATH}/pdb70/pdb70"
mgnify_path="${DATA_PATH}/mgnify/mgy_clusters_2022_05.fa"
uniprot_path="${DATA_PATH}/uniprot/uniprot.fasta"
uniref90_path="${DATA_PATH}/uniref90/uniref90.fasta"
small_bfd_path="${DATA_PATH}/small_bfd/bfd-first_non_consensus_sequences.fasta"
pdb_seqres_path="${DATA_PATH}/pdb_seqres/pdb_seqres.txt"
template_mmcif_dir="${DATA_PATH}/pdb_mmcif/mmcif_files"
obsolete_pdbs_path="${DATA_PATH}/pdb_mmcif/obsolete.dat"

MONOMER_DB="--data_dir=${DATA_PATH} \
            --uniref90_database_path=$uniref90_path \
            --mgnify_database_path=$mgnify_path  \
            --template_mmcif_dir=$template_mmcif_dir \
            --obsolete_pdbs_path=$obsolete_pdbs_path \
            --small_bfd_database_path=$small_bfd_path \
            --pdb70_database_path=$pdb70_path"

MULTIMER_DB="--data_dir=${DATA_PATH} \
             --uniref90_database_path=$uniref90_path \
             --mgnify_database_path=$mgnify_path  \
             --template_mmcif_dir=$template_mmcif_dir \
             --obsolete_pdbs_path=$obsolete_pdbs_path \
             --small_bfd_database_path=$small_bfd_path \
             --pdb_seqres_database_path=$pdb_seqres_path \
             --uniprot_database_path=$uniprot_path"


af2_mono() {
  local FASTA=$1
  local OUT=$2
  local NGPU=$3

  local target=$(basename $FASTA| awk -F. '{print $1}')

  cat << EOF > "${OUT}/${target}.sub"
#!/bin/bash
#SBATCH -J ${target} -p ${QUEUE}
#SBATCH --nodes=1 --ntasks-per-node=1 --cpus-per-task=$((NGPU*10))
#SBATCH --gres=gpu:${NGPU}

ml purge
ml nvhpc-hpcx-cuda12/24.5
hostname
nvidia-smi
source /beegfs/shared/lincy/ENV/af2/bin/activate

export TF_FORCE_UNIFIED_MEMORY=1
export XLA_PYTHON_CLIENT_MEM_FRACTION="4.0"     ## for sequence larger than ~1000

python ../../run_alphafold.py --fasta_paths=../${FASTA} --output_dir=./ --db_preset=reduced_dbs  \\
  --models_to_relax=none --use_gpu_relax=True --use_precomputed_msas --max_template_date=2023-01-01  \\
  --model_preset=monomer \\
  ${MONOMER_DB}

rm -f *.pkl *.cif

echo "Done in \${SECONDS} secs ..."
EOF

if [[ $RUN == "--submit" ]]; then
  (cd ${OUT}; sbatch ${target}.sub)
fi

}

af2_multi() {
  local FASTA=$1
  local OUT=$2
  local NGPU=$3

  local target=$(basename $FASTA| awk -F. '{print $1}')

  cat << EOF > "${OUT}/${target}.sub"
#!/bin/bash
#SBATCH -J ${target} -p ${QUEUE}
#SBATCH --nodes=1 --ntasks-per-node=1 --cpus-per-task=$((NGPU*10))
#SBATCH --gres=gpu:${NGPU}

sleep $WAIT

ml purge
ml nvhpc-hpcx-cuda12/24.5
hostname
nvidia-smi
source /beegfs/shared/lincy/ENV/af2/bin/activate

export TF_FORCE_UNIFIED_MEMORY=1
export XLA_PYTHON_CLIENT_MEM_FRACTION="4.0"     ## for sequence larger than ~1000

python ../../run_alphafold.py --fasta_paths=../${FASTA} --output_dir=./ --db_preset=reduced_dbs \\
  --models_to_relax=none --use_gpu_relax=True --use_precomputed_msas --max_template_date=2023-01-01   \\
  --model_preset=multimer --num_multimer_predictions_per_model=1 \\
  ${MULTIMER_DB}

rm -f *.pkl *.cif

echo "Done in \${SECONDS} secs ..."
EOF

if [[ $RUN == "--submit" ]]; then
  (cd ${OUT}; sbatch ${target}.sub)
fi

}


###=============================================

RUN_GROUP=./runs
mkdir -p ${RUN_GROUP}
##FILES=`ls -1 ./data/fasta/* | shuf`
FILES="\
./data/fasta/D1273_27.fasta    \
./data/fasta/T0245s2_134.fasta \
./data/fasta/H1202_190.fasta   \
./data/fasta/H0225_483.fasta   \
./data/fasta/T2247_697.fasta   \
./data/fasta/T1257_1263.fasta  \
./data/fasta/T2210_1770.fasta  \
"

for f in ${FILES}; do

    lc=$(wc -l < "$f")
    if [ "$lc" -gt 2 ]; then
        af2_multi $f ${RUN_GROUP} 1
    else
        af2_mono $f ${RUN_GROUP} 1
    fi
done



