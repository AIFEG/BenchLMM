import argparse
import json
import os

def calculate_average_score(jsonl_path):
    total_score = 0
    count = 0
    
    with open(jsonl_path, 'r') as file:
        for line in file:
            data = json.loads(line)
            score_str = data.get('model_response')
            
            try:
                score = float(score_str)
                total_score += score
                count += 1
            except ValueError:
                print(f"Could not convert score '{score_str}' to a float. Skipping.")
       
    if count == 0:
        print("No valid scores found.")
        return
    
    average_score = total_score / count
    print(f"The average score is: {average_score:.3f}")
    return average_score

def main():
    parser = argparse.ArgumentParser(description='Calculate the average score from a jsonl file.')
    parser.add_argument('score_jsonl_path', type=str, help='Path to the jsonl file.')
    
    args = parser.parse_args()
    avg_score = calculate_average_score(args.score_jsonl_path)
    
    if avg_score is not None:
        output_path = './evaluate_results/average_score.json'
        output_dir = os.path.dirname(output_path)

        # Create directory if it doesn't exist
        if not os.path.exists(output_dir):
            os.makedirs(output_dir)
            
        new_data = {
            'source_file': args.score_jsonl_path,
            'average_score': avg_score,
        }
        
        if os.path.exists(output_path):
            try:
                with open(output_path, 'r') as f:
                    data = json.load(f)
                    if not isinstance(data, dict):
                        raise ValueError('Data is not a dictionary')
                    if 'scores' not in data:
                        data['scores'] = []
                    data['scores'].append(new_data)
            except (json.JSONDecodeError, ValueError):
                data = {'scores': [new_data]}
        else:
            data = {'scores': [new_data]}
        
        with open(output_path, 'w') as f:
            json.dump(data, f, indent=4)
        print(f"Average score appended to {output_path}")

if __name__ == '__main__':
    main()
