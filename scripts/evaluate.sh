#!/bin/bash

WORKSPACE_PATH="/hdd_16T/Zirui/Test2/BenchLMM" # Please put your absolute workspace path here. It will be used as root folder for all the following folders.
GROUND_TRUTH_FOLDER="$WORKSPACE_PATH/jsonl" # The input folder of the ground truth answers.
MODEL_PREDICT_FOLDER="$WORKSPACE_PATH/results" # The input folder of your model predict answers.
RESULT_OUTPUT_FOLDER="$WORKSPACE_PATH/evaluate_results" # The output folder of the gpt evaluate results. Python script will generate results here.
OPENAI_API_KEY="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" # Please put your openai key here

function evaluate() {
    local prediction_file="$1"
    local script="$2"
    local ground_truth_file="$3"
    local output_file="$4"
    
    export OPENAI_API_KEY="$OPENAI_API_KEY"
    python "$WORKSPACE_PATH/evaluate/$script" \
        --prediction_jsonl_path "$MODEL_PREDICT_FOLDER/$prediction_file" \
        --ground_truth_jsonl_path "$GROUND_TRUTH_FOLDER/$ground_truth_file" \
        --output_jsonl_path "$RESULT_OUTPUT_FOLDER/$output_file" \
        --gpt_model "gpt-3.5-turbo"
    
    python "$WORKSPACE_PATH/evaluate/avg_score.py" "$RESULT_OUTPUT_FOLDER/$output_file"
}

# Function to evaluate robots and game files
function evaluate_robots_and_games() {
    local prediction_file="$1"
    local meta_data_file="$2"
    local script="$3"
    local output_file="$4"
    local temperature=$5

    export OPENAI_API_KEY="$OPENAI_API_KEY"
    python "$WORKSPACE_PATH/evaluate/$script" \
        --model_output "$MODEL_PREDICT_FOLDER/$prediction_file" \
        --meta_data "$GROUND_TRUTH_FOLDER/$meta_data_file" \
        --openai_key "$OPENAI_API_KEY" \
        --output_path "$RESULT_OUTPUT_FOLDER/$output_file" \
        --temperture "$temperature"
}

# Function to determine the corresponding ground truth file
function get_ground_truth_file() {
    local prediction_file="$1"
    
    case "$prediction_file" in
        *AD*) echo "Benchmark_AD.jsonl" ;;
        *CT*) echo "Benchmark_CT.jsonl" ;;
        *MRI*) echo "Benchmark_MRI.jsonl" ;;
        *Med-X-RAY*) echo "Benchmark_Med-X-RAY.jsonl" ;;
        *RS*) echo "Benchmark_RS.jsonl" ;;
        *xray*) echo "Benchmark_xray.jsonl" ;;
        *defect_detection*) echo "Benchmark_defect_detection.jsonl" ;;
        *game*) echo "Benchmark_game.jsonl" ;;
        *Robots*) echo "Benchmark_Robots.jsonl" ;;
        *infrard*) echo "Benchmark_infrard.jsonl" ;;
        *style_cartoon*) echo "Benchmark_style_cartoon.jsonl" ;;
        *style_handmake*) echo "Benchmark_style_handmake.jsonl" ;;
        *style_painting*) echo "Benchmark_style_painting.jsonl" ;;
        *style_sketch*) echo "Benchmark_style_sketch.jsonl" ;;
        *style_tattoo*) echo "Benchmark_style_tattoo.jsonl" ;;
        
        *) echo "unknown" ;;
    esac
}

# Function to determine the appropriate evaluation script based on file name
function get_evaluation_script() {
    local file_name="$1"
    
    # Update these conditions based on your specific evaluation scripts and their naming conventions
    if [[ "$file_name" == *"AD.jsonl" ]]; then
        echo "gpt_evaluation_script_AD.py"
    elif [[ "$file_name" == *"RS.jsonl" ]]; then
        echo "gpt_evaluation_script_RS.py"
    elif [[ "$file_name" == *"xray.jsonl" ]]; then
        echo "gpt_evaluation_script_xray.py"
    # style-related filenames
    elif [[ "$file_name" == *"style"*.jsonl ]]; then
        echo "gpt_evaluation_script_style.py"
    elif [[ "$file_name" == *"cartoon".jsonl ]]; then
        echo "gpt_evaluation_script_style.py"
    elif [[ "$file_name" == *"handmake".jsonl ]]; then
        echo "gpt_evaluation_script_style.py"
    elif [[ "$file_name" == *"painting".jsonl ]]; then
        echo "gpt_evaluation_script_style.py"
    elif [[ "$file_name" == *"sketch".jsonl ]]; then
        echo "gpt_evaluation_script_style.py"
    elif [[ "$file_name" == *"tattoo".jsonl ]]; then
        echo "gpt_evaluation_script_style.py"
    elif [[ "$file_name" == *"game".jsonl ]] || [[ "$file_name" == *"Robots".jsonl ]]; then
        echo "gpt_evaluation_script_Robots_Games.py"
    else
        echo "gpt_evaluation_script.py"
    fi
}

# Main loop for file processing
echo "========================================"
echo "Starting evaluation of prediction files..."
echo "========================================"

for file in "$MODEL_PREDICT_FOLDER"/*.jsonl; do
    base_name=$(basename "$file")

    if [[ "$base_name" == *"Robots.jsonl" ]] || [[ "$base_name" == *"game.jsonl" ]]; then
        script_name="gpt_evaluation_script_Robots_Games.py"

        dir_path=${dir_path/\/.\//}
        type_part=${base_name##*answers_Benchmark_}
        type_part=${type_part%.jsonl}

        # meta_data_file="${base_name%.jsonl}_meta_data.json"
        meta_data_file="$dir_path${type_part}_meta_data.json"
        output_file="${base_name%.jsonl}_evaluate.json"
        evaluate_robots_and_games "$base_name" "$meta_data_file" "$script_name" "$output_file" 0
    else
        ground_truth_file=$(get_ground_truth_file "$base_name")
        if [ "$ground_truth_file" != "unknown" ]; then
            script_name=$(get_evaluation_script "$base_name")
            output_file="${base_name%.jsonl}_evaluate.json"
            evaluate "$base_name" "$script_name" "$ground_truth_file" "$output_file"
        else
            echo "No matching ground truth file for $file"
        fi
    fi
done

echo "========================================"
echo "Evaluation process complete."
echo "========================================"
