fn main() raises:
    var lines = DynamicVector[String]()
    lines.push_back("............................................................................................................................................")
    with open("input", "r") as f:
        let flines = f.read().split("\n")
        for l in range(len(flines)):
            lines.push_back("." + flines[l] + ".")
    lines.push_back("............................................................................................................................................")

    for line in range(1, len(lines) - 1):
        for c in range(1, len(lines[0]) - 1):
            
