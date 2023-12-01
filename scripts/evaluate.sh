  
  #!/bin/bash

WORKSPACE_PATH="/workspace/Benckmark/"
EVALUATE_FOLDER="$WORKSPACE_PATH/open_fla/result"
RESULT_SOURCE_FOLDER="$WORKSPACE_PATH/open_fla/7B"

function evaluate() {
    local input_file="$1"
    local script="$2"
    local output_file="$3"
    
    OPENAI_API_KEY=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 \
    python "$WORKSPACE_PATH/evaluate/$script" \
        --prediction_jsonl_path "$input_file" \
        --ground_truth_jsonl_path "$input_file" \
        --output_jsonl_path "$output_file" \
        --gpt_model "gpt-3.5-turbo"

    python "$WORKSPACE_PATH/evaluate/avg_score.py" "$output_file"
}

# Evaluate AD.jsonl
evaluate "$RESULT_SOURCE_FOLDER/AD.jsonl" \
         "gpt_evaluation_script_AD.py" \
         "$EVALUATE_FOLDER/AD_evaluate.json"

# Evaluate RS.jsonl
evaluate "$RESULT_SOURCE_FOLDER/RS.jsonl" \
         "gpt_evaluation_script_RS.py" \
         "$EVALUATE_FOLDER/RS_evaluate.json"

# Evaluate style/*.jsonl
for file in "$RESULT_SOURCE_FOLDER/style"/*.jsonl; do
    base_name=$(basename "$file" .jsonl)
    output_file="$EVALUATE_FOLDER/${base_name}_evaluate.json"
    evaluate "$file" "gpt_evaluation_script_style.py" "$output_file"
done

# Evaluate xray.jsonl
evaluate "$RESULT_SOURCE_FOLDER/xray.jsonl" \
         "gpt_evaluation_script_xray.py" \
         "$EVALUATE_FOLDER/xray_evaluate.json"

# Evaluate Med/*.jsonl
for file in "$RESULT_SOURCE_FOLDER/Med"/*.jsonl; do
    base_name=$(basename "$file" .jsonl)
    output_file="$EVALUATE_FOLDER/${base_name}_evaluate.json"
    evaluate "$file" "gpt_evaluation_script.py" "$output_file"
done

# Evaluate other files with the default script
for file in "$RESULT_SOURCE_FOLDER"/*.jsonl; do
    if [[ "$file" != *"AD.jsonl" ]] && \
       [[ "$file" != *"RS.jsonl" ]] && \
       [[ "$file" != *"xray.jsonl" ]] && \
       [[ "$file" != *"Med/"* ]]; then
        base_name=$(basename "$file" .jsonl)
        output_file="$EVALUATE_FOLDER/${base_name}_evaluate.json"
        evaluate "$file" "gpt_evaluation_script.py" "$output_file"
    fi
done
