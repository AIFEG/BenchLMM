# BenchGPT: Benchmarking Cross-style Visual Capability of Large Multimodal Models

## Overview

This archive involves processing and evaluating images and questions using a model that outputs results based on the given inputs. It utilizes Python code for reading, processing, and evaluating images and questions against ground truth answers.

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

- **images/**: 

  - This directory contains all image files of different styles.
>>>>>>> origin/master
