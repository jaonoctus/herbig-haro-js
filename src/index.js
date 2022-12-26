const { Command } = require('commander')
const { version } = require('../package.json')
const { checkIfBtrfsIsInstalled } = require('./utils/checkDeps')

async function main() {
    const program = new Command()
    
    program
        .name('hh')
        .description('Herbig-Haro: a BTRFS interactive CLI')
        .version(version, '-v, --version')
    
    program.parse(process.argv)

    await checkIfBtrfsIsInstalled()

    console.log('> BTRFS is installed ☕')
}

main()
