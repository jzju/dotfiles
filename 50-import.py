import json
import math
import pickle
import os
import re
import shutil
import warnings
import numpy as np
import pandas as pd
import multiprocessing as mp
import traceback as tb
from collections import defaultdict
from datetime import datetime
from pymongo import MongoClient
from time import sleep

warnings.filterwarnings("ignore")


def plo(path):
    with open(path, "rb") as f:
        return pickle.load(f)


def pdu(data, path):
    with open(path, "wb") as f:
        pickle.dump(data, f)


class SetEncoder(json.JSONEncoder):
    def default(self, obj):
        if isinstance(obj, set):
            return list(obj)
        return json.JSONEncoder.default(self, obj)


def jlo(path):
    with open(path, "rb") as f:
        return json.load(f)


def jdu(d, path=None):
    if path is None:
        print(json.dumps(d, indent=2, ensure_ascii=0, cls=SetEncoder))
    else:
        with open(path, "w") as f:
            json.dump(d, f, indent=2, ensure_ascii=0, cls=SetEncoder)
