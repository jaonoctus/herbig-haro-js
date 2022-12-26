const { runCommand } = require('./runCommand')

async function checkIfBtrfsIsInstalled() {
    try {
        await runCommand('which btrfs')
    } catch (error) {
        console.error(`Command 'btrfs' not found, but can be installed with:\n`)
        console.error('$ sudo apt install btrfs-progs')
        process.exit(1)
    }
}

exports.checkIfBtrfsIsInstalled = checkIfBtrfsIsInstalled
