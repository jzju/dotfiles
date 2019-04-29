import json
import math
import multiprocessing as mp
import os
import pickle
import re
import shutil
import traceback as tb
import warnings
from collections import Counter, defaultdict
from contextlib import contextmanager
from datetime import datetime, timedelta
from importlib import import_module
from time import sleep, time
from types import SimpleNamespace as NS

mods = {"numpy": "np", "polars": "pl", "psycopg": "", "pymongo": "!MongoClient", "httpx": "", "pendulum": ""}
for k, v in mods.items():
    try:
        if v[0] == "!":
            exec(f'_mod = import_module("{k}")\n{v[1:]} = getattr(_mod, v[1:])')
        else:
            v = v if v else k
            exec(f'{v} = import_module("{k}")')
    except:
        pass

warnings.filterwarnings("ignore")


def ni(o):
    if isinstance(o, dict):
        o = o.items()
    return next(iter(o))


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


def to_batch(vals, n):
    return [vals[i * n : (i + 1) * n] for i in range((len(vals) + n - 1) // n)]


class AD(dict):
    def __new__(cls, init={}, **kwargs):
        if isinstance(init, list):
            self = []
            for v in init:
                self.append(super().__new__(cls))
                self[-1].__init__(v)
        else:
            self = super().__new__(cls)
        return self

    def dolist(self, v):
        res = []
        for vv in v:
            if type(vv) == dict:
                res.append(AD(vv))
            elif type(vv) == list:
                res.append(self.dolist(vv))
            else:
                res.append(vv)
        return res

    def __init__(self, init={}, **kwargs):
        if isinstance(init, str):
            init = json.loads(init)
        init.update(kwargs)
        for k, v in init.items():
            if type(v) == dict:
                self[k] = AD(v)
            elif type(v) == list:
                self[k] = self.dolist(v)
            else:
                self[k] = v

    def __getattr__(self, k):
        return self[k]

    def __setattr__(self, k, v):
        self[k] = v
