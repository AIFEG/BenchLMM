import json

# Function to convert actions to a formatted string
def format_actions(actions, answer_index):
    return actions[answer_index]

# Read the source JSON file
source_file = 'robot_meta_data.json'  # Replace with your source file path
dest_file = 'Benchmark_LLaVA_Robots.jsonl'    # Replace with your destination file path

answers = []
indexes = []
with open(source_file, 'r') as source:
    data = json.load(source)
    for item in data:
        index = item["index"]
        answer = format_actions(item["actions"], item["answer_index"])
        answers.append(answer)
        indexes.append(index)
    
with open(dest_file, 'r') as input_file, open('output.json', 'w') as output_file:
    for line in input_file:
        data = json.loads(line)
        data["answer"] = answers[data["question_id"]]

        json.dump(data, output_file)
        output_file.write('\n')