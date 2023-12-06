#!/bin/bash

# Define paths
JSONL_FILE_PATH="/workspace/Test3/BenchLMM/jsonl"  # Path to the JSONL files
IMAGE_FOLDER_BASE="/workspace/Benckmark/images"   # Base image folder
INSTRUCTBLIP_PY_PATH="/workspace/Test3/BenchLMM/baseline/InstructBLIP/blip_image_result1.py"  # Path to the blip_image_result1.py
OUTPUT_JSONL_FOLDER="/workspace/Test3/BenchLMM/results"  # Output folder for processed JSONL files

# Iterate over all .jsonl files in the jsonl folder
for JSONL_FILE in "$JSONL_FILE_PATH"/*.jsonl; do
    # Extract the filename without path and extension
    FILENAME=$(basename -- "$JSONL_FILE")
    FILENAME="${FILENAME%.*}"

    # Determine the image-folder based on the filename
    case $FILENAME in
        Benchmark_AD)
            IMAGE_FOLDER="$IMAGE_FOLDER_BASE/AD";;
        Benchmark_CT|Benchmark_Med-X-RAY|Benchmark_MRI)
            IMAGE_FOLDER="$IMAGE_FOLDER_BASE/Med";;
        Benchmark_defect_detection)
            IMAGE_FOLDER="$IMAGE_FOLDER_BASE/defect_detection";;
        Benchmark_infrard)
            IMAGE_FOLDER="$IMAGE_FOLDER_BASE/infrard";;
        Benchmark_game)
            IMAGE_FOLDER="$IMAGE_FOLDER_BASE/open_game";;
        Benchmark_Robots)
            IMAGE_FOLDER="$IMAGE_FOLDER_BASE/Robots";;
        Benchmark_RS)
            IMAGE_FOLDER="$IMAGE_FOLDER_BASE/RS";;
        Benchmark_style_cartoon|Benchmark_style_handmake|Benchmark_style_painting|Benchmark_style_sketch|Benchmark_style_tattoo)
            IMAGE_FOLDER="$IMAGE_FOLDER_BASE/style";;
        Benchmark_xray)
            IMAGE_FOLDER="$IMAGE_FOLDER_BASE/Xray";;
        *)
            # Print a message and skip if no matching image folder is found
            echo "No matching image folder for $FILENAME. Skipping."
            continue;;
    esac

    # Define the output JSONL file path
    OUTPUT_JSONL_FILE="$OUTPUT_JSONL_FOLDER/processed_${FILENAME}.jsonl"

    # Execute the InstructBLIP.py script
    python $INSTRUCTBLIP_PY_PATH \
        "$JSONL_FILE" \
        "$IMAGE_FOLDER" \
        "$OUTPUT_JSONL_FILE"
done
