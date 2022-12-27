import random
from random import randint
import json

d = {
    "task": [],
    "resource": []
}

for i in range(500):
    d["task"].append(randint(1024, 2048))

for i in range(300):
    d["resource"].append(randint(512, 1024))

for i in range(700):
    d["resource"].append(randint(2048, 4096))

random.shuffle(d["resource"])

with open("data.json", "w") as f:
    json.dump(d, f, indent=2)