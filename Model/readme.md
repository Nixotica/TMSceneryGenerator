# TM Scenery Generator ML

## Background and setup

Make sure that git lfs is installed. 

On WSL: 

- Run `curl -s https://packagecloud.io/install/repositories/github/git-lfs/script.deb.sh | sudo bash`
- Run `sudo apt-get install git-lfs`
- Run `git lfs install`

Then make sure huggingface is installed and you are logged in (make an account if you haven't already at huggingface.co). 

On WSL:

- Run `pip install huggingface_hub`
- Run `huggingface-cli login`

There are models and datasets hosted there, all of which are outlined here:

- Models
    - https://huggingface.co/Nixotica/ScenGenTestModel
- Datasets
    - https://huggingface.co/datasets/Nixotica/ScenGenTestDataset

If you want to clone the model or dataset locally, you can simply run `git clone <url-to-repo>` as usual. To create a new model, dataset, or space, run `huggingface-cli repo create repo_name --type {model, dataset, space}`. 

## Models

## Datasets