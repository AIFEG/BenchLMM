import re
import json
import openai  # Assuming openai is installed and properly set up
import time
from tqdm import tqdm

import argparse
from openai import OpenAI
client = OpenAI()
def load_jsonl(file_path):
    with open(file_path, 'r') as file:
        return [json.loads(line) for line in file]

def get_gpt_scores(prediction_jsonl_path, ground_truth_jsonl_path, output_jsonl_path, gpt_model):
    # Load the ground truths
    ground_truths = load_jsonl(ground_truth_jsonl_path)
    
    # Create a dictionary for easy access to ground truths
    gt_dict = {item['question_id']: item for item in ground_truths}
    
    # Process each prediction
    predictions = load_jsonl(prediction_jsonl_path)
        
    with open(output_jsonl_path, 'w') as out_file:
        for item in tqdm(predictions,desc='Evaluating, If stuck, please Ctrl + C .', dynamic_ncols=True):
            question_id = item['question_id']
            prediction_text = item.get('model_output',"")
            
            gt_item = gt_dict.get(question_id, {})
            gt_answer = gt_item.get('answer',"")
            
            prediction_text=str(prediction_text)
            gt_answer=str(gt_answer)
            
            
            gt_question = gt_item.get('prompt')
            
            print(f"question_id: {question_id}, prediction_text: {prediction_text}, gt_answer: {gt_answer}")
            if not prediction_text or not gt_answer:
                print(f"Skipping question_id {question_id} due to empty prediction_text or gt_answer.")
                continue
            
            retries = 0
            max_retries = 3
            while retries < max_retries:
            # Create a question for the GPT model and other processing here...
                question = f"""Compare the ground truth and prediction from AI models, to give a correctness score for the prediction. Ignore case, single and plural grammar problems, and consider whether the meaning is similar. If the meaning is similar, it deserves full marks.  A '/' in ground truth indicates that there are multiple responses to the question, with full marks for any one answer. The correctness score is 0.0 (totally wrong), 0.1, 0.2, 0.3, 0.4, 0.5, 0.6, 0.7, 0.8, 0.9, or 1.0 (totally right). 
                Example:
                Question | Ground truth | Prediction | Correctness
                --- | --- | --- | ---
                How many apples are here? | 10 | 7 | 0.0
                How many apples are here? | 10 | 10 | 1.0
                What are keeping the elephants in their area? | bars / fence / fences / cage | fence | 1
                What are keeping the elephants in their area? | bars / fence / fences / cage | They are stuck in the cage. | 1.0
                Identify the relevant traffic signal for the ego-vehicle's current path | None | Green | 0.0
                Identify the relevant traffic signal for the ego-vehicle's current path | Green Light | Red | 0.0
                Identify the relevant traffic signal for the ego-vehicle's current path | Green Light | Green | 1.0
                What can the organ with black color in this image be used for?| breathe | Breathing. | 1.0
               
                Here is the QA you need to compare and score 
                Question: {gt_question} 
                Ground Truth: {gt_answer}
                Prediction: {prediction_text} 
                Score :
                
                Provide only the numerical correctness score as the output. 
                """

                try: 
                    response = client.chat.completions.create(
                    model=gpt_model,
                    max_tokens=64,
                    messages=[{"role": "user", "content": question}],
                    timeout = 10,
                )
                    # print("response: ",response)
                except:
                    print("sleep 30s")
                    time.sleep(30)

            # Example of how you might write results to the output file
                
                else:
                    # Example of how you might write results to the output file
                    model_response = response.choices[0].message.content
                    print(f"model_response: {model_response}")
                    try:
                        score_matches = re.findall(r"(\d+(\.\d+)?)", model_response)
                        if score_matches:
                            if len(score_matches) > 1:
                                raise ValueError(f"Multiple numbers detected: {model_response}")
                            
                            score = float(score_matches[0][0])
                            # print(f"model_response: {model_response}")
                            print(f"score: {score}")
                            if 0 <= score <= 1:
                                result = {
                                    'question_id': question_id,
                                    'image': gt_item.get('image', ''),
                                    'model_response': score
                                }
                                out_file.write(json.dumps(result) + '\n')
                                break
                        else: 
                            raise ValueError(f"Invalid response format: {model_response}")
                    except ValueError:
                        pass
            
            
                retries += 1
                if retries == max_retries:
                    print(f"Failed to get a valid score after {max_retries} attempts for question_id {question_id}.")


# 调用函数
#get_gpt_scores("/workspace/LLaVA/Zirui/Results/llava_1.5/llava_1.5_13B_orignal.jsonl", "/workspace/LLaVA/Zirui/jsonl/llava/Benckmark_LLaVA_style.jsonl", "/workspace/LLaVA/Zirui/evaluate/score/oringal_score_LLaVA_1.5_13B.jsonl", "gpt-4-0613")

def main():
    parser = argparse.ArgumentParser(description='Evaluate predictions using GPT.')
    parser.add_argument('--prediction_jsonl_path', type=str, required=True,help='Path to the prediction JSONL file.')
    parser.add_argument('--ground_truth_jsonl_path', type=str, required=True,help='Path to the ground truth JSONL file.')
    parser.add_argument('--output_jsonl_path', type=str, required=True,help='Path to save the output JSONL file.')
    parser.add_argument('--gpt_model', type=str, required=True, help='GPT model to use for evaluation.')
    
    args = parser.parse_args()
    get_gpt_scores(args.prediction_jsonl_path, args.ground_truth_jsonl_path, args.output_jsonl_path, args.gpt_model)

if __name__ == '__main__':
    main()
