let this_release_date = process.argv[2];
//this_release_date = this_release_date.substr(1, this_release_date.length - 2)
let last_release_date = process.argv[3];
//last_release_date = last_release_date.substr(1, this_release_date.length - 2)
let child_process = require("child_process");
let log = "";
let json = {};
json.tag_name = this_release_date;
json.name = `${this_release_date} (automatic release)`;
json.prerelease = true;
let body = `\n\n`;
body += log;
json.body = body;
console.error(JSON.stringify(json));
console.log(JSON.stringify(json));
