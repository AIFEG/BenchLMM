# BenchLMM: Benchmarking Cross-style Visual Capability of Large Multimodal Models

## Demo

![BenchGPT/imgs/demo.png](Demo)


## Directory Structure

- **baseline/**: 

  - Contains sample Python code demonstrating how the model reads in, processes images and questions, and outputs the results.

- **evaluate/**: 

  - All the Python code used for evaluating the model's output. This evaluation is done by using GPT to compare the model output answers with ground truth answers.

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

## Evaluate on our Benchmark

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

- **Evaluate results**





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
```
pip install -e ".[train]"
pip install flash-attn --no-build-isolation
```
- LLaVA Weights  
Please check out our [Model Zoo](https://github.com/haotian-liu/LLaVA/blob/main/docs/MODEL_ZOO.md) for all public LLaVA checkpoints, and the instructions of how to use the weights.


## Cite our work



## Related project
- [InstructBLIP](https://github.com/salesforce/LAVIS/blob/main/projects/instructblip)

- [LLaVA](https://github.com/haotian-liu/LLaVA)


## Acknowledgement
