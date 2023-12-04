import re
import openai
import argparse
import json
from tqdm import tqdm
import requests
import concurrent.futures
import time

MAX_RETRY=2000
CONCURRENT_CONNECTIONS=4

parser = argparse.ArgumentParser()
parser.add_argument("--meta_data", type=str, default='BenchGPT/jsonl/game_meta_data.json')
parser.add_argument('--model_output', type=str, default='results/chatgpt_holmes_outputs/Open-World Game.json')
parser.add_argument("--openai_key", type=str, default="sk-xxxx")
parser.add_argument("--output_path", type=str, default="output.json")
parser.add_argument("--temperture", type=float, default=0)

args = parser.parse_args()

headers = {
    'Authorization': f'Bearer {args.openai_key}',
    'Content-Type': 'application/json',
}

template = """
[Action Choices]: {actions}

[Agent Answer]: {model_output}
[Correct Action]: {true_action}

[System]

You should carefully compare the [Agent Answer] with the [Action Choices], and tell which action the agent is choosing. 
If the selected action in the [Agent Answer] equals to the [Correct Action], the action score is 1; otherwise, it is 0.

You should give your accessment evidences and then the scores.

Your output MUST contains 2 lines with the following format:
action accessment evidence: <accessment evidences here>
action score: <score here>
"""


def parse_scores(generated_text):
    generated_text = generated_text.split('\n')
    generated_text = [x for x in generated_text if x != '']
    action_score = float(generated_text[1].split(':')[-1])
    return action_score,0,0


def eval_entry(entry):
    meta_data = entry['meta_data']
    model_output = entry['model_output']
    domain = meta_data['domain']
    question = meta_data["question"]
    action_list = [f"({chr(ord('A') + i)}) {choice}" for i, choice in enumerate(meta_data["actions"])]
    actions =  " ".join(action_list)
    true_action = action_list[meta_data['answer_index']]
    reason = meta_data["reason"]
    key_concept = meta_data["key_concept"]
    prompt = template.format(actions=actions, 
                             model_output=model_output, 
                             true_action=true_action, 
)
    
    for i in range(MAX_RETRY):
        try:
            request = {
                "model": "gpt-3.5-turbo",
                "messages": [
                    {
                        "role": "user",
                        "content": prompt
                    }
                ],
                "temperature": args.temperture,
            }
            
            while True:
                try:
                    response = requests.post('https://api.openai.com/v1/chat/completions',
                                    headers=headers,
                                    data=json.dumps(request),
                                    timeout=20)
                    response = json.loads(response.text)
                    review = response['choices'][0]['message']['content']
                    action_score, perception_score, cognition_score = parse_scores(review)
                    break 
                except Exception as e:
                    print(e)
                    request["temperature"] = 0.7
            time.sleep(1)
            return {"review": review,
                    "action_score": action_score,
                    "perception_score": perception_score,
                    "cognition_score": cognition_score,
                    "prompt": prompt
            }
        except openai.error.RateLimitError:
            print('rate limit')
            time.sleep(20)
        raise RuntimeError(f"Failed after {MAX_RETRY} retries.")
    

if __name__ == '__main__':
    with open(args.model_output, 'r') as file:
        model_outputs = [json.loads(line) for line in file]
    with open(args.meta_data, 'r') as file:
        meta_data = json.load(file)

    data = []
    for meta in meta_data:
        model_output = next((m for m in model_outputs if m['question_id'] == meta['index']), None)
        if model_output:
            data.append({
                "question_id": meta['index'],
                "meta_data": meta,
                "action_candidates": " ".join(meta['actions']),
                "true_action": meta['actions'][meta['answer_index']],
                "model_output": model_output['model_output']
            })
            
    with concurrent.futures.ThreadPoolExecutor(max_workers=CONCURRENT_CONNECTIONS) as executor:
        future2entry = {executor.submit(eval_entry, entry): entry for entry in data}
        print(f"Total {len(data)} entries")
        for future in tqdm(concurrent.futures.as_completed(future2entry), total=len(data)):
            entry = future2entry[future]
            result = future.result()
            entry.update(result) 
            del entry['meta_data']
            # print(entry) 
    
    average_action_score = sum([d['action_score'] for d in data]) / len(data)
    average_perception_score = sum([d['perception_score'] for d in data]) / len(data)
    average_cognition_score = sum([d['cognition_score'] for d in data]) / len(data)
    
    data = [{"average_action_score": average_action_score, 
            "average_perception_score": average_perception_score,
            "average_cognition_score": average_cognition_score
            } ] + data
    json.dump(obj=data, fp=open(args.output_path, 'w'), indent=4)
