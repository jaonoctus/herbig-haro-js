const { spawn } = require('child_process')

function runCommand(argsString = '') {
    const [command, ...commandArgs] = argsString.split(' ')

    return new Promise((resolve, reject) => {
        const child = spawn(command, commandArgs);

        let stdoutString
        let stderrString
        let errorString

        child.stdout.on('data', (data) => {
            stdoutString = Buffer.from(data).toString()
        });

        child.stderr.on('data', (data) => {
            stderrString = Buffer.from(data).toString()
        });

        child.on('error', (error) => {
            errorString = Buffer.from(error).toString()
        });

        child.on('close', (code) => {
            if (code === 0) {
                resolve({
                    code,
                    stdout: stdoutString
                })
            } else {
                reject({
                    code,
                    stderr: stderrString,
                    error: errorString
                })
            }
        });
    })
}

exports.runCommand = runCommand
