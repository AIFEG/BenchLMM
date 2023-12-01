
#!/bin/bash
export CUDA_VISIBLE_DEVICES=0
# Define sets of parameters

PARAMS=(
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_AD.jsonl /workspace/Benckmark/images/AD /workspace/Benckmark/result_blip/13B/AD.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_infrard.jsonl /workspace/Benckmark/images/infrard /workspace/Benckmark/result_blip/13B/infrard.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_RS.jsonl /workspace/Benckmark/images/RS /workspace/Benckmark/result_blip/13B/RS.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_style_cartoon.jsonl /workspace/Benckmark/images/style /workspace/Benckmark/result_blip/13B/cartoon.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_style_handmake.jsonl /workspace/Benckmark/images/style /workspace/Benckmark/result_blip/13B/handmake.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_style_painting.jsonl /workspace/Benckmark/images/style /workspace/Benckmark/result_blip/13B/painting.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_style_sketch.jsonl /workspace/Benckmark/images/style /workspace/Benckmark/result_blip/13B/sketch.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_style_tattoo.jsonl /workspace/Benckmark/images/style /workspace/Benckmark/result_blip/13B/tattoo.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_style_weather.jsonl /workspace/Benckmark/images/style /workspace/Benckmark/result_blip/13B/weather.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_defect_detection.jsonl /workspace/Benckmark/images/defect_detection/defect_detection/defect_detection /workspace/Benckmark/result_blip/13B/defect_detection.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_xray.jsonl /workspace/Benckmark/images/Xray /workspace/Benckmark/result_blip/13B/xray.jsonl"
    # "/workspace/Benckmark/llava/Med/Benchmark_LLaVA_CT.jsonl /workspace/Benckmark/images/Med /workspace/Benckmark/result_blip/13B/CT.jsonl"
    # "/workspace/Benckmark/llava/Med/Benchmark_LLaVA_Med-X-RAY.jsonl /workspace/Benckmark/images/Med /workspace/Benckmark/result_blip/13B/Med-X-RAY.jsonl"
    # "/workspace/Benckmark/llava/Med/Benchmark_LLaVA_MRI.jsonl /workspace/Benckmark/images/Med /workspace/Benckmark/result_blip/13B/MRI.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_game.jsonl /workspace/Benckmark/images/open_game /workspace/Benckmark/result_blip/13B/game.jsonl"
    # "/workspace/Benckmark/llava/Benchmark_LLaVA_Robots.jsonl /workspace/Benckmark/images/Robots /workspace/Benckmark/result_blip/13B/Robots.jsonl"
    "/workspace/Benckmark/llava/Benchmark_LLaVA_original.jsonl /workspace/Benckmark/images/orignal /workspace/Benckmark/result_blip/7B/original.jsonl"

)

# Loop through each set of parameters
for param_set in "${PARAMS[@]}"; do
    # Parse parameters  
    read -r READ_JSONL_PATH PARENT_IMAGE_FOLDER OUTPUT_JSON_PATH <<< "$param_set"
    
    # Run Python program with the arguments
    python Benckmark/blip_image_result_copy.py "$READ_JSONL_PATH" "$PARENT_IMAGE_FOLDER" "$OUTPUT_JSON_PATH"
done
