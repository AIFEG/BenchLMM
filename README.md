



<p align="center">
    <img src="imgs/tittle_fig.png" width="150" style="margin-bottom: 0.2;"/>
<p>
<h2 align="center"> <a href="https://arxiv.org/abs/2312.02896"> [ECCV 2024] BenchLMM: Benchmarking Cross-style Visual Capability of Large Multimodal Models</a></h2>
<h4 align="center">
  <a href="https://github.com/RizhaoCai">Rizhao Cai*</a><sup>1</sup>, 
  <a href="https://github.com/ZiruiSongBest">Zirui Song*</a><sup>2,3</sup>, 
  <a href="https://dayan-guan.github.io/">Dayan Guan†</a><sup>1</sup>, 
  <a href="https://zhenhaochenofficial.github.io/">Zhenhao Chen</a><sup>4</sup>, 
  <a href="https://github.com/dylanli-hang">Yaohang Li</a><sup>2,3</sup>, 
  <a>Xing Luo</a><sup>5</sup>, 
  <a href="https://github.com/Newbeeyoung">Chenyu Yi</a><sup>1</sup>, 
  <a href="https://personal.ntu.edu.sg/eackot/">Alex Kot</a><sup>1</sup>
</h4>
<ul align="center">
  <sup>1</sup>Nanyang Technological University</li>
  <sup>2</sup>University of Technology Sydney</li>
  <sup>3</sup>Northeastern University</li>
  <sup>4</sup>Mohamed bin Zayed University of Artificial Intelligence</li>
  <sup>5</sup>Zhejiang University</li>
</ul>

<h5 align="center"> *Equal contribution, †Corresponding Author </h5>
<h5 align="center"> If you like our project, please give us a star ⭐ on GitHub for latest update.  </h2>

<h5 align="center">

[![Website](https://img.shields.io/badge/Project-Website-87CEEB)](https://aifeg.github.io/BenchLMM/)
[![hf_space](https://img.shields.io/badge/🤗-Dataset%20Spaces-blue.svg)](https://huggingface.co/datasets/AIFEG/BenchLMM/blob/main/BenchGPT.zip) 
[![arXiv](https://img.shields.io/badge/Arxiv-2312.02896-b31b1b.svg?logo=arXiv)](https://arxiv.org/abs/2312.02896)
[![Endpoint Badge](https://img.shields.io/badge/BenchLMM-Leaderboard-blue)](https://paperswithcode.com/sota/visual-question-answering-on-benchlmm)

[![zhihu](https://img.shields.io/badge/-知乎-000000?logo=zhihu&logoColor=0084FF)](https://zhuanlan.zhihu.com/p/671911974?utm_psn=1721273086845059072)
[![Wechat](https://img.shields.io/badge/-WeChat@CVer-000000?logo=wechat&logoColor=07C160)](https://mp.weixin.qq.com/s/f6P7WXz-Z1ZR1Qqa2czRdg)
[![Twitter](https://img.shields.io/badge/-Twitter@Zhenhao%20Chen%20-black?logo=twitter&logoColor=1D9BF0)](https://x.com/DavisChan1998/status/1737798877254685058?s=20)
[![Twitter](https://img.shields.io/badge/-Twitter@AK%20-black?logo=twitter&logoColor=1D9BF0)](https://x.com/DavisChan1998/status/1737798877254685058?s=20)
[![Twitter](https://img.shields.io/badge/-Twitter@Niels%20Rogge%20-black?logo=twitter&logoColor=1D9BF0)](https://twitter.com/NielsRogge/status/1737854354378707322)
 <br>

</h5>


## Benchmark Examples
![Demo](imgs/demo.png)

Note: For a simple presentation, the questions in Domestic Robot and Open Game have been simplified from multiple-choice format. Please see our [Benchmark](https://huggingface.co/datasets/AIFEG/BenchLMM) for more examples and detailed questions.
## Directory Structure

- **baseline/**: 

  - Contains LLaVA and InstructBLIP baseline code.

- **evaluate/**: 

  - All the Python code used for evaluating the model's output. This evaluation is done by using ChatGPT to compare the model output answers with ground truth answers.

- **evaluate_results/**:
  
    - This directory contains the evaluation results of the baseline models.

- **jsonl/**:

  - This directory contains all JSONL files with the question, image relative location, and the ground truth answer.

  - Sample JSONL format:

    ```json
    {
      "question_id": "bottle_test_broken_large_000_001", 
      "image": "bottle_test_broken_large_000.png", 
      "text": "Is there any defect in the object in this image? Answer the question using a single word or phrase.", 
      "answer": "Yes"
    }
    ```

    The image is the relative image location of corresponding style image folder, the text is the question, answer is ground truth answer.

- **imgs/**: 

  - This directory contains the images used on this page. However, they are not our benchmark images.


- **results/**: 

  - This directory contains the inference results of the baseline models.

- **scripts/**: 

  - Contains the scripts to run the baseline and evaluate the results.


## Evaluate on our Benchmark

- **Install**  
Download our benchmark image from our [Releases](https://github.com/AIFEG/BenchLMM/releases/tag/images) or [Hugging face](https://huggingface.co/datasets/AIFEG/BenchLMM/blob/main/BenchLMM.zip)


```Shell
git clone git@github.com:AIFEG/BenchLMM.git
cd BenchLMM
mkdir evaluate_results
```

- **Prepare your model output**  
Prepare your results in the following format, Key "prompt" is the input of the model, you better use the Jsonl file to store your results.

```json
{
  "question_id": 110, 
  "prompt": "Is there any defect in the object in this image? Answer the question using a single word or phrase.", 
  "model_output": "Yes",
}
```
- **Rename your Jsonl file**  
Rename your Jsonl file to ```xxxx_StyleName.jsonl``` like the following project tree. You must keep the style of the suffix consistent with the example.
```
.
├── answers_Benchmark_AD.jsonl
├── xxxxxxxx_CT.jsonl
├── xxxxxxxx_MRI.jsonl
├── xxxxxxxx_Med-X-RAY.jsonl
├── xxxxxxxx_RS.jsonl
├── xxxxxxxx_Robots.jsonl
├── xxxxxxxx_defect_detection.jsonl
├── xxxxxxxx_game.jsonl
├── xxxxxxxx_infrard.jsonl
├── xxxxxxxx_style_cartoon.jsonl
├── xxxxxxxx_style_handmake.jsonl
├── xxxxxxxx_style_painting.jsonl
├── xxxxxxxx_style_sketch.jsonl
├── xxxxxxxx_style_tattoo.jsonl
├── xxxxxxxx_xray.jsonl
```

- **Evaluate your model output**  
Modify the file path and run the script [scripts/evaluate.sh](scripts/evaluate.sh)
```
bash scripts/evaluate.sh
```
Note: Score will be saved in the file [results](evaluate_results/). Robots and game scores are included in the [evaluate_results/Robots.jsonl](evaluate_results/robots.jsonl) and [evaluate_results/game.jsonl](evaluate_results/game.jsonl) respectively.
## Baseline
|Model|VRAM required|
|:---|:---:|
|InstructBLIP-7B|30GB|
|InstructBLIP-13B|65GB|
|LLava-1.5-7B|<24GB|
|LLava-1.5-13B|30GB|
### LLaVA  
- **Install**

1. Clone this repository and navigate to LLaVA folder
```bash
git clone https://github.com/haotian-liu/LLaVA.git
cd LLaVA
```

2. Install Package
```Shell
conda create -n llava python=3.10 -y
conda activate llava
pip install --upgrade pip  # enable PEP 660 support
pip install -e .
```

3. Install additional packages for training cases
```Shell
pip install -e ".[train]"
pip install flash-attn --no-build-isolation
```
4. LLaVA Weights  
Please check out our [Model Zoo](https://github.com/haotian-liu/LLaVA/blob/main/docs/MODEL_ZOO.md) for all public LLaVA checkpoints, and the instructions of how to use the weights.


- **Run and evaluate LLaVA on our Benchmark**
1.  Add the file [BenchLMM_LLaVA_model_vqa.py](baseline/LLaVA/BenchLMM_LLaVA_model_vqa.py) to the path ```LLaVA/llava/eval/``` 

2. Modify the file path and run the script [scripts/LLaVA.sh](scripts/LLaVA.sh)
```Shell
bash scripts/LLaVA.sh
```
3. Evaluate results
```Shell
bash scripts/evaluate.sh
```

Note: Score will be saved in the file [results](evaluate_results/).


### InstructBLIP 

- **Install**  
```
git clone https://github.com/salesforce/LAVIS.git  
cd LAVIS  
pip install -e .  
```

- **Prepare Vicuna Weights**  
InstructBLIP uses frozen Vicuna 7B and 13B models. Please first follow the [instructions](https://github.com/lm-sys/FastChat) to prepare Vicuna v1.1 weights.   
Then modify the ```llm_model``` in the [Model Config](https://github.com/salesforce/LAVIS/blob/main/lavis/configs/models/blip2/blip2_instruct_vicuna7b.yaml) to the folder that contains Vicuna weights.

- **Run InstructBLIP on our Benchmark**

Modify the file path and run the script [BenchLMM/scripts/InstructBLIP.sh](scripts/InstructBLIP.sh)
```
bash BenchLMM/scripts/InstructBLIP.sh
```
- **Evaluate results**
Modify the file path and run the script [BenchLMM/scripts/evaluate.sh](scripts/evaluate.sh)
```
bash BenchLMM/scripts/evaluate.sh
```

Note: Score will be saved in the file [results](evaluate_results/).


----


## Cite our work
```bibtex
@article{cai2023benchlmm,
  title={BenchLMM: Benchmarking Cross-style Visual Capability of Large Multimodal Models},
  author={Cai, Rizhao and Song, Zirui and Guan, Dayan and Chen, Zhenhao and Luo, Xing and Yi, Chenyu and Kot, Alex},
  journal={arXiv preprint arXiv:2312.02896},
  year={2023}
}
```

## Contact
If you have any question or issue with our project, please contact Dayan Guan: dayan.guan@outlook.com


## Acknowledgement
This research is supported in part by the Rapid-Rich Object Search (ROSE) Lab of Nanyang Technological University and the NTU-PKU Joint Research Institute (a collaboration between NTU and Peking University that is sponsored by a donation from the Ng Teng Fong Charitable Foundation). We are deeply grateful to Yaohang Li from the University of Technology Sydney for his invaluable assistance in conducting the experiments, and to Jingpu Yang, Helin Wang, Zihui Cui, Yushan Jiang, Fengxian Ji, and Yuxiao Hang from NLULab@NEUQ (Northeastern University at Qinhuangdao, China) for their meticulous efforts in annotating the dataset. We also would like to thank Prof. Miao Fang (PI of NLULab@NEUQ) for his supervision and insightful suggestion during discussion on this project.
## Related project
- [InstructBLIP](https://github.com/salesforce/LAVIS/blob/main/projects/instructblip)

- [LLaVA](https://github.com/haotian-liu/LLaVA)

- [MM-VET](https://github.com/yuweihao/MM-Vet)
- [PCA-EVAL](https://github.com/pkunlp-icler/PCA-EVAL)
