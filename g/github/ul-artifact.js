const artifact = require('@actions/artifact');
const client = artifact.create();
const name = process.argv[2];
const files = process.argv.slice(3);
async function main()
{
    console.log(await client.uploadArtifact(name, files, "build/artifacts/up", {
	continueOnError: false,
    }));
}

main();
