import argparse
import json
import requests
import sys
import urllib

import pandas as pd
import requests

from urllib.error import HTTPError
from urllib.parse import quote
from urllib.parse import urlencode


CLIENT_ID = "foo"
API_KEY = "foo"

def fix_case(s):
    ary = s.split(" ")
    ary = [
        a[0].upper() + a[1:].lower()
            if len(a) > 1
            else a[0].upper()
        for a in ary if len(a) > 0
    ]
    return " ".join(ary)

def unpack_data_slice():
    x = pd.read_csv(
        "./data/dataslice2.csv",
        header=None)\
        .applymap(lambda s: fix_case(str(s)))
    
    out = []
    for _, (camis, restaurant, city, streetno, street, zipcode) in x.iterrows():
        out.append({
            'CAMIS': camis,
            'params': {
                'name': restaurant,
                'address1': " ".join((streetno, street)),
                'city': city,
                'state': "NY",
                'country': "US",
                'zip_code': zipcode
            }
        })

    return out

if __name__ == "__main__":
    x = unpack_data_slice()

    headers = {
        'Authorization': 'Bearer %s' % API_KEY,
    }

    url_data = "https://api.yelp.com/v3/businesses/{rid}"
    url_match = url_data.format(rid="matches")
    reffile = "reference.json"
    errfile = "errors.json"

    LOAD = True
    
    if LOAD:
        with open(reffile, "r") as file:
            ref = json.load(file)
        with open(errfile, "r") as file:
            err = json.load(file)
    else:
        ref = {}
        err = {}

    try:
        for e, xx in enumerate(x): # 853
            params = xx["params"]
            camis = xx["CAMIS"]
            if (camis in ref) or (camis in err):
                print("Skipping #%d camis: %s, already found" % (e, camis))
            else:
                print("Trying #%d camis: %s..." % (e, camis), end=" ")
                r = requests.get(url=url_match, headers=headers, params=params)
                match_result = r.json()
                try:
                    if len(match_result["businesses"]) > 0:
                        rid = match_result["businesses"][0]["id"]
                        r = requests.get(url=url_data.format(rid=rid), headers=headers)
                        ref[camis] = {}
                        ref[camis]["yelp"] = r.json()
                        print("Got it!")
                    else:
                        ref[camis] = {}
                        print("No match!" % camis)
                except Exception as e:
                    if "error" in match_result:
                        if "code" in match_result["error"]:
                            if match_result["error"]["code"] == \
                                "ACCESS_LIMIT_REACHED":
                                # short circuit -- don't write failure
                                # to file
                                raise ValueError()
                    err[camis] = match_result
    except Exception as e:
        pass

    with open(reffile, "w") as file:
        file.write(json.dumps(ref, indent=4))
    with open(errfile, "w") as file:
        file.write(json.dumps(err, indent=4))

