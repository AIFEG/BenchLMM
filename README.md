



<p align="center">
    <img src="imgs/tittle_fig.png" width="150" style="margin-bottom: 0.2;"/>
<p>
<h2 align="center"> <a href="https://arxiv.org/abs/2311.10122"> BenchLMM: Benchmarking Cross-style Visual Capability of Large Multimodal Models</a></h2>
<h5 align="center"> If you like our project, please give us a star ⭐ on GitHub for latest update.  </h2>



<h5 align="center">
    
[![hf_space](https://img.shields.io/badge/🤗-Dataset%20Spaces-blue.svg)](https://huggingface.co/datasets/AIFEG/BenchGPT)
<!-- [![Open in OpenXLab](https://cdn-static.openxlab.org.cn/app-center/openxlab_app.svg)](https://openxlab.org.cn/apps/detail/houshaowei/Video-LLaVA) -->
[![arXiv](https://img.shields.io/badge/Arxiv-2311.10122-b31b1b.svg?logo=arXiv)](https://arxiv.org/abs/2311.10122) <br>
<!-- [![License](https://img.shields.io/badge/License-Apache%202.0-yellow)](https://github.com/PKU-YuanGroup/Video-LLaVA/blob/main/LICENSE)  -->
[![GitHub issues](https://img.shields.io/github/issues/PKU-YuanGroup/Video-LLaVA?color=critical&label=Issues)](https://github.com/AIFEG/BenchGPT/issues?q=is%3Aopen+is%3Aissue)
[![GitHub closed issues](https://img.shields.io/github/issues-closed/PKU-YuanGroup/Video-LLaVA?color=success&label=Issues)](https://github.com/AIFEG/BenchGPT/issues?q=is%3Aissue+is%3Aclosed)  <br>
<!-- [![zhihu](https://img.shields.io/badge/-Twitter@Nate%20Raw%20-black?logo=twitter&logoColor=1D9BF0)](https://twitter.com/_nateraw/status/1726783481248977037) -->
<!-- [![zhihu](https://img.shields.io/badge/-Twitter@Aran%20Komatsuzaki%20-black?logo=twitter&logoColor=1D9BF0)](https://twitter.com/arankomatsuzaki/status/1726421417963516144) -->
<!-- [![zhihu](https://img.shields.io/badge/-Twitter@jesselaunz%20-black?logo=twitter&logoColor=1D9BF0)](https://twitter.com/jesselaunz/status/1726850138776453379)
[![zhihu](https://img.shields.io/badge/-WeChat@量子位-000000?logo=wechat&logoColor=07C160)](https://mp.weixin.qq.com/s/EFqLv_Euf5VU024zOtzkkg)
[![zhihu](https://img.shields.io/badge/-WeChat@新智元-000000?logo=wechat&logoColor=07C160)](https://mp.weixin.qq.com/s/uwaxMu8UbJpcLTXsNJwpVQ)
[![zhihu](https://img.shields.io/badge/-知乎-000000?logo=zhihu&logoColor=0084FF)](https://zhuanlan.zhihu.com/p/668166885)
[![zhihu](https://img.shields.io/badge/-YouTube-000000?logo=youtube&logoColor=FF0000)](https://www.youtube.com/watch?v=EFkN00rGq1U&ab_channel=JesseLau-aTrader) -->
<!--[![zhihu](https://img.shields.io/badge/-Bilibili-000000?logo=bilibili&logoColor=00A1D6)](https://zhuanlan.zhihu.com/p/668166885)-->

</h5>


## Benchmark Examples
![Demo](imgs/demo.png)

Note: For a simple presentation, the questions in Domestic Robot and Open Game have been simplified from multiple-choice format. Please see our [Benchmark](https://huggingface.co/datasets/AIFEG/BenchGPT) for more examples and detailed questions.
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

  - This directory contains the image which used in this page. However, It's not out benchmark images.


- **results/**: 

  - This directory contains the inference results of the baseline models.

- **scripts/**: 

  - Contains the scripts to run the baseline and evaluate the results.


## Evaluate on our Benchmark
Download our benchmark image from our [Releases](https://github.com/AIFEG/BenchGPT/releases/tag/images) or [Hugging face](https://huggingface.co/datasets/AIFEG/BenchGPT)


Prepare your results in the following format, Key "prompt" is the input of the model, you better use the Jsonl file to store your results.

```json
{
  "question_id": 110, 
  "prompt": "Is there any defect in the object in this image? Answer the question using a single word or phrase.", 
  "model_output": "Yes",
}
```

Modify the file path and run the script [BenchGPT/scripts/evaluate.sh](scripts/evaluate.sh)
```
bash BenchGPT/scripts/evaluate.sh
```

## Baseline
|Model|VRAM required|
|:---|:---:|
|InstructBLIP-7B|30GB|
|InstructBLIP-13B|65GB|
|LLava-1.5-7B|<24GB|
|LLava-1.5-13B|30GB|
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

Modify the file path and run the script [BenchGPT/scripts/InstructBLIP.sh](scripts/InstructBLIP.sh)
```
bash BenchGPT/scripts/InstructBLIP.sh
```
- **Evaluate results**
Modify the file path and run the script [BenchGPT/scripts/evaluate.sh](scripts/evaluate.sh)
```
ash BenchGPT/scripts/evaluate.sh
```




----
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
1.  Add the file [BenchGPT_LLaVA_model_vqa.py](baseline/LLaVA/BenchGPT_LLaVA_model_vqa.py) to the path ```LLaVA/llava/eval/``` 

2. Modify the file path and run the script [BenchGPT/scripts/LLaVA.sh](scripts/LLaVA.sh)
```Shell
bash BenchGPT/scripts/LLaVA.sh
```
3. Evaluate results
```Shell
bash BenchGPT/scripts/evaluate.sh
```

Note: Score will be saved in the file [results](evaluate_results/).



## Cite our work
```
```




## Acknowledgement

## Related project
- [InstructBLIP](https://github.com/salesforce/LAVIS/blob/main/projects/instructblip)

- [LLaVA](https://github.com/haotian-liu/LLaVA)

- [MM-VET](https://github.com/yuweihao/MM-Vet)
- [PCA-EVAL](https://github.com/pkunlp-icler/PCA-EVAL)
