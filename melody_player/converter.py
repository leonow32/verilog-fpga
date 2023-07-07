melody = "4g2 8.#a2 16g2 16- 16g2"

duration = {
    "64.": "0030",
    "64":  "0020",
    "32.": "0060",
    "32":  "0040",
    "16.": "00BB",
    "16":  "007D",
    "8.":  "0177",
    "8":   "00FA",
    "4.":  "02EE",
    "4":   "01F4",
    "2.":  "05DC",
    "2":   "03E8",
    "1.":  "0BB8",
    "1":   "07D0",
}

frequency = {
    "#c1": "070B",
    "c1":  "0777",
    "#d1": "0647",
    "d1":  "06A6",
    "e1":  "05EC",
    "#f1": "0547",
    "f1":  "0597",
    "#g1": "04B3",
    "g1":  "04FB",
    "#a1": "0430",
    "a1":  "0470",
    "b1":  "03F4",
    "#c2": "0385",
    "c2":  "03BB",
    "#d2": "0323",
    "d2":  "0353",
    "e2":  "02F6",
    "#f2": "02A3",
    "f2":  "02CB",
    "#g2": "0259",
    "g2":  "027D",
    "#a2": "0218",
    "a2":  "0238",
    "b2":  "01FA",
    "#c3": "01C2",
    "c3":  "01DD",
    "#d3": "0191",
    "d3":  "01A9",
    "e3":  "017B",
    "#f3": "0151",
    "f3":  "0165",
    "#g3": "012C",
    "g3":  "013E",
    "#a3": "010C",
    "a3":  "011C",
    "b3":  "00FD",
    "-":   "0000",
}

notes = melody.split(" ")

for note in notes:
    print(f"Processing note: {note}")
    
    for item in frequency:
        if item in note:
            print(f"Found note {item}")
            break;
    
    for item in duration:
        if item in note:
            print(f"Found duration {item}")
            break;

print(notes)