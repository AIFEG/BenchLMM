#!/bin/bash

# Define the paths for the answers folder, jsonl files, and base image folder
ANSWERS_FOLDER="/workspace/Test/BenchLMM/results" # The LLaVA output  
JSONL_FILE_PATH="/workspace/Test/BenchLMM/jsonl"
IMAGE_FOLDER_base="/workspace/Benckmark/images"
BenchLMM_LLaVA_model_vqa_PATH="/workspace/Test/LLaVA/llava/eval/BenchLMM_LLaVA_model_vqa.py" # path to the BenchLMM_LLaVA_model_vqa.py
# Iterate over all .jsonl files in the jsonl folder
for JSONL_FILE in "$JSONL_FILE_PATH"/*.jsonl; do
    # Extract the filename without path and extension
    FILENAME=$(basename -- "$JSONL_FILE")
    FILENAME="${FILENAME%.*}"

    # Determine the image-folder based on the filename
    case $FILENAME in
        Benchmark_AD)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/AD";;
        Benchmark_CT|Benchmark_Med-X-RAY|Benchmark_MRI)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/Med";;
        Benchmark_defect_detection)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/defect_detection";;
        Benchmark_infrard)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/infrard";;
        Benchmark_game)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/open_game";;
        Benchmark_Robots)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/Robots";;
        Benchmark_RS)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/RS";;
        Benchmark_style_cartoon|Benchmark_style_handmake|Benchmark_style_painting|Benchmark_style_sketch|Benchmark_style_tattoo)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/style";;
        Benchmark_xray)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/Xray";;
        *)
            # Print a message and skip if no matching image folder is found
            echo "No matching image folder for $FILENAME. Skipping."
            continue;;
    esac

    # Define the full path for the answer-file
    ANSWER_FILE="$ANSWERS_FOLDER/answers_${FILENAME}.jsonl"

    # Execute the model_vqa.py script
    python $BenchLMM_LLaVA_model_vqa_PATH \
        --model-path liuhaotian/llava-v1.5-13b \
        --question-file "$JSONL_FILE" \
        --image-folder "$IMAGE_FOLDER" \
        --answers-file "$ANSWER_FILE"
done
