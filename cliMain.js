const Asearch = require('./')

function cliMain (argv) {
  if (argv.length < 4) {
    console.error("Usage: asearch left right [ambig]")

    return 2
  }

  const ambig = argv[4] === undefined ? undefined : Number(argv[4])

  if (ambig < 0 || ambig >= 4) {
    console.error("Ambig is out of range 0~3")

    return 2
  }

  const match = Asearch(argv[2])

  return match(argv[3], ambig) ? 0 : 1
}

module.exports = { cliMain }
