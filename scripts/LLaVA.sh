#!/bin/bash

# Define the paths for the answers folder, jsonl files, and base image folder
ANSWERS_FOLDER="/path/to/answers"
JSONL_FILE_PATH="/path/to/jsonl"
IMAGE_FOLDER_base="/path/to/image"

# Iterate over all .jsonl files in the jsonl folder
for JSONL_FILE in "$JSONL_FILE_PATH"/*.jsonl; do
    # Extract the filename without path and extension
    FILENAME=$(basename -- "$JSONL_FILE")
    FILENAME="${FILENAME%.*}"

    # Determine the image-folder based on the filename
    case $FILENAME in
        Benchmark_AD)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/AD";;
        Benchmark_CT|Benchmark_Med-X-Ray|Benchmark_MRI)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/Med";;
        Benchmark_defect_detection)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/defect_detection";;
        Benchmark_infrard)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/infrard";;
        Benchmark_game)
            IMAGE_FOLDER="$IMAGE_FOLDER_base/open_game";;
        Benchmark_robots)
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
    python model_vqa.py \
        --model-path liuhaotian/llava-v1.5-13b \
        --question-file "$JSONL_FILE" \
        --image-folder "$IMAGE_FOLDER" \
        --answers-file "$ANSWER_FILE"
done
