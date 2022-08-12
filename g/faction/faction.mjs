import { read } from "node-yaml";
import { execFileSync } from "child_process";
import { writeFileSync } from "fs";

let {jobs} = await read(".github/workflows/split1.yml");

for (let jobname in jobs) {
    let job = jobs[jobname];
    let sh = "";
    sh += "mkdir -p $FACTION/" + jobname + "\n";
    sh += "cd $FACTION/" + jobname + "\n";

    if (job["runs-on"] !== "ubuntu-latest")
	throw new Error("bad runs-on");

    for (let step of job.steps) {
	if (step.uses) {
	    if (step.uses === "actions/checkout@v3") {
		sh += "git clone --branch faction git@github.com:pipcet/pearl\n";
		sh += "cd pearl\n";
	    } else if (step.uses === "./g/github/env/") {
	    } else {
		throw new Error("bad uses: " + step.uses);
	    }
	} else if (step.run) {
	    sh += step.run + "\n";
	}
    }

    writeFileSync(process.env["FACTION"] + "/" + jobname + ".sh", sh);
}
