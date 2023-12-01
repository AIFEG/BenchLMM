#!/bin/bash

WORKSPACE_PATH="/workspace/Benckmark/llava/Stage1_without_pior"
EVALUATE_FOLDER="$WORKSPACE_PATH/minigpt4/score"
RESULT_SOURCE_FOLDER="$WORKSPACE_PATH/minigpt4"
GROUND_TRUTH_FOLDER="/workspace/Benckmark/llava"

function evaluate() {
    local input_file="$1"
    local ground_truth_file="$2"
    local script="$3"
    local output_file="$4"
    
    OPENAI_API_KEY=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 \
    python "$WORKSPACE_PATH/evaluate/$script" \
        --prediction_jsonl_path "$input_file" \
        --ground_truth_jsonl_path "$ground_truth_file" \
        --output_jsonl_path "$output_file" \
        --gpt_model "gpt-4-0613"

    python "$WORKSPACE_PATH/evaluate/avg_score.py" "$output_file"
}

# # Evaluate AD.jsonl
# evaluate "$RESULT_SOURCE_FOLDER/AD.jsonl" \
#         "$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_AD.jsonl" \
#         "gpt_evaluation_script_AD.py" \
#         "$EVALUATE_FOLDER/AD_evaluate.json"

# # # Evaluate RS.jsonl
# evaluate "$RESULT_SOURCE_FOLDER/RS.jsonl" \
#         "$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_RS.jsonl" \
#         "gpt_evaluation_script_RS.py" \
#         "$EVALUATE_FOLDER/RS_evaluate.json"

# # # Evaluate infrard.jsonl
# evaluate "$RESULT_SOURCE_FOLDER/infrard.jsonl" \
#         "$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_infrard.jsonl" \
#         "gpt_evaluation_script_infrard.py" \
#         "$EVALUATE_FOLDER/infrard_evaluate.json"
# # Evaluate cartoon.jsonl
evaluate "$RESULT_SOURCE_FOLDER/cartoon.jsonl" \
        "$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_style_cartoon.jsonl" \
        "gpt_evaluation_script_style.py" \
        "$EVALUATE_FOLDER/cartoon_evaluate.json"
# # Evaluate handmake.jsonl
# evaluate "$RESULT_SOURCE_FOLDER/handmake.jsonl" \
#         "$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_style_handmake.jsonl" \
#         "gpt_evaluation_script_style.py" \
#         "$EVALUATE_FOLDER/handmake_evaluate.json"
# Evaluate painting.jsonl
# evaluate "$RESULT_SOURCE_FOLDER/painting.jsonl" \
#         "$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_style_painting.jsonl" \
#         "gpt_evaluation_script_style.py" \
#         "$EVALUATE_FOLDER/painting_evaluate.json"


# # Evaluate sketch.jsonl
# evaluate "$RESULT_SOURCE_FOLDER/sketch.jsonl" \
#         "$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_style_sketch.jsonl" \
#         "gpt_evaluation_script_style.py" \
#         "$EVALUATE_FOLDER/sketch_evaluate.json"

# # Evaluate tattoo.jsonl
# evaluate "$RESULT_SOURCE_FOLDER/tattoo.jsonl" \
#         "$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_style_tattoo.jsonl" \
#         "gpt_evaluation_script_style.py" \
#         "$EVALUATE_FOLDER/tattoo_evaluate.json"

# Evaluate defect_detection.jsonl
# evaluate "$RESULT_SOURCE_FOLDER/defect_detection.jsonl" \
#         "$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_defect_detection.jsonl" \
#         "gpt_evaluation_script.py" \
#         "$EVALUATE_FOLDER/defect_detection_evaluate.json"

# Evaluate style/*.jsonl
# for file in "$RESULT_SOURCE_FOLDER"/*.jsonl; do
#     base_name=$(basename "$file" .jsonl)
#     ground_truth_file="$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_style_$base_name.jsonl"
#     output_file="$EVALUATE_FOLDER/${base_name}_evaluate.json"
#     evaluate "$file" "$ground_truth_file" "gpt_evaluation_script_style.py" "$output_file"
# done

# # Evaluate xray.jsonl
# evaluate "$RESULT_SOURCE_FOLDER/xray.jsonl" \
#         "$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_xray.jsonl" \
#         "gpt_evaluation_script_xray.py" \
#         "$EVALUATE_FOLDER/xray_evaluate.json"

# Evaluate Med/*.jsonl
# for file in "$RESULT_SOURCE_FOLDER"/*.jsonl; do
#     base_name=$(basename "$file" .jsonl)
#     ground_truth_file="$GROUND_TRUTH_FOLDER/Med/Benchmark_LLaVA_$base_name.jsonl"
#     output_file="$EVALUATE_FOLDER/${base_name}_evaluate.json"
#     evaluate "$file" "$ground_truth_file" "gpt_evaluation_script.py" "$output_file"
# done

# Evaluate other files with the default script
# for file in "$RESULT_SOURCE_FOLDER"/*.jsonl; do
#     if [[ "$file" != *"AD.jsonl" ]] && \
#        [[ "$file" != *"RS.jsonl" ]] && \
#        [[ "$file" != *"xray.jsonl" ]] && \
#        [[ "$file" != *"Med/"* ]]; then
#         base_name=$(basename "$file" .jsonl)
#         ground_truth_file="$GROUND_TRUTH_FOLDER/Benchmark_LLaVA_$base_name.jsonl"
#         output_file="$EVALUATE_FOLDER/${base_name}_evaluate.json"
#         evaluate "$file" "$ground_truth_file" "gpt_evaluation_script.py" "$output_file"
#     fi
# done
