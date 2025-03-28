
# Run `python read_casp.py --download` to download all fasta sequence CASP16

import os
import sys
import requests
import pandas as pd

def fetch_and_save_url(url, file_path):
    response = requests.get(url)
    response.raise_for_status()  # Check for HTTP errors

    # Save content to a file
    with open(file_path, 'w', encoding='utf-8') as file:
        file.write(response.text)
    #print(f"Saved to {file_path}")


if __name__ == "__main__":

  dl = False
  if len(sys.argv) > 1:
     dl = sys.argv[1]

  df_ = pd.read_csv("casp16.csv", delimiter=';', encoding="latin", usecols=['Target','Res'])
  df = df_.sort_values(by='Res').reset_index(drop=True)

  for tag, res in df.iloc[:].itertuples(index=False):
     print(tag, res)

     if dl == "--download":
       fasta_file = f"./fasta/{tag}_{res}.fasta"
       if os.path.exists(fasta_file): continue

       fasta_link = f"https://predictioncenter.org/casp16/target.cgi?target={tag}&view=sequence"
       fetch_and_save_url(fasta_link, fasta_file)
