#!/usr/bin/env jq

def repeat(str; times):
    str as $str | times as $times | [range($times)] | map($str) | join("");

def epid_info(place; confirm_num; suspect_num; death_num; cure_num):
    place as $place | {"确": confirm_num, "疑": suspect_num, "亡": death_num, "愈": cure_num} | to_entries | map(join("：")) | [$place, .[]] | join("，");

.data.times,
epid_info("全国"; .data.gntotal; .data.sustotal; .data.deathtotal; .data.curetotal),
(
    .data.list | map((.value, .susNum, .deathNum, .cureNum) |= tonumber) | sort_by(.value) | reverse | .[] | repeat(" "; 4)+epid_info(.name; .value; .susNum; .deathNum; .cureNum),
    (
        .city | map((.conNum, .susNum, .deathNum, .cureNum) |= tonumber) | sort_by(.conNum) | reverse | .[] | repeat(" "; 8)+epid_info(.name; .conNum; .susNum; .deathNum; .cureNum)
    )
)

