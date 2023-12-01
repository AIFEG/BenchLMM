from transformers import InstructBlipProcessor, InstructBlipForConditionalGeneration
import torch
from tqdm import tqdm
import json
import argparse
import os
import torch
from PIL import Image
from tqdm import tqdm

def get_local_image(file):
    return Image.open(file)

if __name__ == "__main__":
    parser = argparse.ArgumentParser(description="Read JSONL file and update image path")
    parser.add_argument("read_jsonl_path", help="Path to the JSONL file")
    parser.add_argument("parent_image_folder", help="Parent folder for the images")
    parser.add_argument("output_jsonl_path", help="Path to output the updated JSON file")

    args = parser.parse_args()

    load_bit = "bf16"
    precision = {}
    if load_bit == "bf16":
        precision["torch_dtype"] = torch.bfloat16
    elif load_bit == "fp16":
        precision["torch_dtype"] = torch.float16
    elif load_bit == "fp32":
        precision["torch_dtype"] = torch.float32

    model = InstructBlipForConditionalGeneration.from_pretrained("Salesforce/instructblip-vicuna-13b",cache_dir="/workspace/.cache")
    processor = InstructBlipProcessor.from_pretrained("Salesforce/instructblip-vicuna-13b",cache_dir="/workspace/.cache")
    device = "cuda" if torch.cuda.is_available() else "cpu"
    model.eval()
    model.to(device)

    data = []
    with open(args.read_jsonl_path, 'r') as file:
        lines = file.readlines()
        for line in tqdm(lines, desc="Processing lines"):
            json_line = json.loads(line.strip())
            image_location = os.path.join(args.parent_image_folder, json_line['image'])
            image = get_local_image(image_location).convert("RGB")
            prompts_input = json_line['text']
            inputs = processor(images=image, text=prompts_input, return_tensors="pt").to(device)
            
            response = model.generate(
                        **inputs,
                        do_sample=False,
                        num_beams=5,
                        max_length=256,
                        min_length=1,
                        top_p=0.9,
                        repetition_penalty=1.5,
                        length_penalty=1.0,
                        temperature=1,
                )
            json_line['model_output'] = processor.batch_decode(response, skip_special_tokens=True)[0].strip()
            
            with open(args.output_jsonl_path, 'a') as outfile:
                json.dump(json_line, outfile)
                outfile.write('\n')