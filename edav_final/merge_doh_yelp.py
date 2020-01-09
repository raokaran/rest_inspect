import os
import json

import pandas as pd
import numpy as np

reffile = "reference.json"
# errfile = "errors.json"

datfile = os.path.join(".", "data", 
    "DOHMH_New_York_City_Restaurant_Inspection_Results.csv")

data = pd.read_csv(datfile, index_col=[0])
data = data.sort_index()
original_cols = data.columns

with open(reffile, "r") as file:
    yelp = json.load(file)

def tabulate(data, yelp):
    out = pd.DataFrame(index=data.index.unique())
    # generate a histogram of categories
    categories = {}
    for key in yelp:
        if ("yelp" in yelp[key]) and ("categories" in yelp[key]["yelp"]):
            for cat in yelp[key]["yelp"]["categories"]:
                if cat["title"] in categories:
                    categories[cat["title"]] += 1
                else:
                    categories[cat["title"]] = 1

    hist = pd.DataFrame({"ct": categories})
    hist = hist.sort_values("ct")[::-1]

    # find minimum number of categories required to meet threshold
    threshold = 0.95
    for ee, n_categories in enumerate(range(1, len(hist)+1)):
        totl = 0
        succ = 0
        for key in yelp:
            if (("yelp" in yelp[key])
                and ("categories" in yelp[key]["yelp"]) \
                and (len(yelp[key]["yelp"]["categories"]) > 0)):
                totl += 1
                if any(
                    hist.index[:n_categories].isin(
                        map(lambda d: d["title"], yelp[key]["yelp"]["categories"])
                    )
                ):
                    succ += 1
        if succ / totl > threshold:
            break
    
    hist = hist.reindex(hist.index[:ee])

    yelp_cat = dict.fromkeys(data.index.unique())
    for key in yelp_cat:
        cats = list(
            map(
                lambda d: d["title"], 
                    yelp[str(key)]["yelp"]["categories"]
                    if ((str(key) in yelp)
                        and ("yelp" in yelp[str(key)])
                        and ("categories" in yelp[str(key)]["yelp"]))
                    else []
            ))
        mask = hist.index.isin(cats)
        if len(hist.index[mask]):
            yelp_cat[key] = hist.index[mask][0]
        else:
            yelp_cat[key] = "Other"
    out["yelp_cat"] = pd.Series(yelp_cat).reindex(out.index)

    keydata = {
            int(x) : 
            (len(yelp[x]["yelp"]["price"]) * 1. 
                if ("price" in yelp[x]["yelp"])
                else np.nan)
            for x in yelp 
        }
    out["price"] = pd.Series(keydata).reindex(out.index)

    keydata = {
        int(x) : 
        (yelp[x]["yelp"]["rating"] if ("rating" in yelp[x]["yelp"])
            else np.nan)
        for x in yelp 
    }
    out["rating"] = pd.Series(keydata).reindex(out.index)

    keydata = {
        int(x) : (yelp[x]["yelp"]["review_count"] if ("review_count" in yelp[x]["yelp"])
            else np.nan)
        for x in yelp 
    }
    out["review_count"] = pd.Series(keydata).reindex(out.index)

    keydata = {
        int(x) : ((
                yelp[x]["yelp"]["coordinates"]["latitude"],
                yelp[x]["yelp"]["coordinates"]["longitude"]
            ) if ("coordinates" in yelp[x]["yelp"])
            else (np.nan, np.nan))
        for x in yelp
    }
    longs, lats = map(
        lambda ary: pd.Series(ary, index=map(int, yelp.keys())).reindex(out.index),
        zip(*pd.Series(keydata))
    )
    out["longitude"], out["latitude"] = longs, lats

    keydata = {
        int(x) : ((
                min(float(j["start"]) for j in yelp[x]["yelp"]["hours"][0]["open"]),
                max(float(j["end"]) + 
                    (0. if float(j["end"]) > float(j["start"]) else 2400.)
                    for j in yelp[x]["yelp"]["hours"][0]["open"])
            ) if ("hours" in yelp[x]["yelp"])
            else (np.nan, np.nan))
        for x in yelp
    }
    opens, closes = map(
        lambda ary: pd.Series(ary, index=map(int, yelp.keys())).reindex(out.index),
        zip(*pd.Series(keydata))
    )
    out["opens"], out["closes"] = opens, closes
    # buggy
    out["is_overnight"] = out["closes"] > 2400.

    return out

tabulated = tabulate(data, yelp)

tabulated.to_csv("tbl_yelp.csv")
